package starlingone.animation {
	import starling.display.DisplayObject;
	import starling.animation.Tween;
	import starling.animation.Transitions;
	import starling.animation.Juggler;
	import starlingone.events.TweenQueryEvent;
	import starling.events.EventDispatcher;
	import starlingone.display.Animator;
	import starlingone.display.EndingAction;

	public class TweenChain extends EventDispatcher{
		private var _obj:DisplayObject;
		private var _tw:Tween;
		private var _chain:Vector.<TweenNode> = new Vector.<TweenNode>();
		private var _recentEditingNode:TweenNode;
		private var _jug:Juggler;
		public var onComplete:Function;
		public function TweenChain(obj:DisplayObject, jug:Juggler=null) {
			// constructor code
			_obj = obj;
			_jug = jug;
		}
		public function set juggler(jug:Juggler):void{
			_jug = jug;
		}
		public function get juggler():Juggler{
			return _jug;
		}
		public function append(tween:Tween):TweenChain{
			var immediate:Boolean = _chain.length==0 ? true : false;
			var twn:TweenNode = new TweenNode(tween, tween.onComplete);
			tween.onComplete = onTweenCompleted;
			_chain.push(tween);
			if(immediate){
				start();
			}
			return this;
		}
		public function animate(properties:Object, duration:*=1.0, transition:Object=null):TweenChain{
			var immediate:Boolean = _chain.length==0 ? true : false;
			var twn:TweenNode = TweenNode.create(_obj, properties, duration, transition);
			trace("prop", properties);
			_chain.push(twn);
			_recentEditingNode = twn;
			twn.tween.onComplete = onTweenCompleted;
			if(immediate){
				start();
			}
			return this;
		}
		public function animateFrom(properties:Object, duration:*=1.0, transition:Object=null):TweenChain{
			var src:Object = {};
			for (var key:String in properties){
				if(_obj.hasOwnProperty(key)){
					src[key] = _obj[key];
				}
			}
			for (var k:String in src){
				_obj[key] = properties[k];
			}
			return animate(src, duration, transition);
		}
		public function moveTo(x:Number, y:Number, duration:*=1.0, transition:Object=null):TweenChain{
			return animate({"x":x, "y":y}, duration, transition);
		}
		public function moveFrom(x:Number, y:Number, duration:*=1.0, transition:Object=null):TweenChain{
			var src:Object = {};
			src.x = _obj.x;
			src.y = _obj.y;
			
			_obj.x = x;
			_obj.y = y;
			return moveTo(src.x, src.y, duration, transition);
		}
		public function done(onComplete:Function):TweenChain{
			_recentEditingNode.onComplete = onComplete;
			return this;
		}
		public function start():Tween{
			var twn:TweenNode = _chain[0];
			var anim:Animator;
			trace("start!");
			if(twn.frameLabel!=null){
				anim = _obj as Animator;
				var duration:Number = anim.gotoAndPlay(twn.frameLabel, EndingAction.BACK);
				trace("duration:", duration);
				//twn.tween = twn.tween.reset(_obj, 1, twn.tween.transition);
				var twn2:TweenNode = TweenNode.create(_obj, twn.properties, duration, twn.tween.transition);
				twn2.tween.onComplete = twn.tween.onComplete;
				twn2.tween.onCompleteArgs = twn.tween.onCompleteArgs;
				twn2.tween.onComplete = onTweenCompleted;
				twn.tween = twn2.tween;
				//var tw:Tween = new Tween(_obj, duration, twn.tween.transition);
				//tw.
			}
			_jug.add(twn.tween);
			return twn.tween;
		}
		public function stop():Tween{
			_jug.remove(current());
			return current();
		}
		public function current():Tween{
			if(_chain.length==0){
				return null;
			}
			return _chain[0].tween;
		}
		public function dispose():void{
			//TODO
		}
		private function onTweenCompleted():void{
			var twn:TweenNode = _chain.shift();
			var twe:TweenQueryEvent;
			_jug.remove(twn.tween);
			trace("next!");
			if(_chain.length==0){
				twe = new TweenQueryEvent(TweenQueryEvent.END);
				if(twn.onComplete!=null){
					if(twn.tween.onCompleteArgs!=null){
						twn.onComplete.apply(twn.tween, twn.tween);
					}else{
						twn.onComplete();
					}
				}
			}else{
				twe = new TweenQueryEvent(TweenQueryEvent.CHANGE);
				twe.next = _chain[0];
				start();
			}
			twe.recentCompleted = twn;
			dispatchEvent(twe);
			
		}
	}
}