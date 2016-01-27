package starlingone.animation {
	import starling.animation.Tween;
	import starlingone.display.Animator;
	import starling.display.DisplayObject;

	public class TweenNode {
		public var tween:Tween;
		public var onComplete:Function;
		public var onCompleteArgs:Array;
		public var frameLabel:String;
		public var anim:Animator;
		public var duration:Number;
		public var properties:Object;
		public function TweenNode(nodeTween:Tween, tweenComplete:Function=null) {
			// constructor code
			tween = nodeTween;
			onComplete = tweenComplete;
		}
		public static function create(_obj:DisplayObject, properties:Object, duration:*=1.0, transition:Object=null):TweenNode{
			var _duration:Number;
			var _tw:Tween;
			if(duration is String){
				if(!(_obj is Animator)){
					throw new Error("Use Frame Label as Duration should be Animator");
				}
				_duration = 1.1;
			}else if(!(duration is Number)){
				throw new Error("Duration can only be Frame Label or Number.");
			}else{
				_duration = duration as Number;
			}
			if(transition==null){
				_tw = new Tween(_obj, _duration);
			}else{
				_tw = new Tween(_obj, _duration, transition);
			}
			for (var key:String in properties){
				if(_obj.hasOwnProperty(key)){
					_tw.animate(key, properties[key]);
				}
			}
			var twn:TweenNode = new TweenNode(_tw);
			twn.properties = properties;
			twn.duration = _tw.totalTime;
			twn.onCompleteArgs = _tw.onCompleteArgs;
			
			if(duration is String){
				twn.frameLabel = duration as String;
			}
			return twn;
		}
	}
}