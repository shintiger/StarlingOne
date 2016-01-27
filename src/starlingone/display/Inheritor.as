package starlingone.display {
	import starling.utils.AssetManager;
	import starling.animation.Juggler;
	import starling.display.Sprite;
	import starling.display.DisplayObject;
	import starlingone.StarlingOne;
	import flash.geom.Rectangle;
	import starlingone.ui.Alignment;
	import starlingone.animation.TweenChain;
	import starling.events.Event;
	import starlingone.events.PropertyEvent;

	public class Inheritor extends Sprite{
		protected var _assetManager:AssetManager;
		protected var _juggler:Juggler;
		protected var _bound:Rectangle;
		protected var _calculatedBound:Rectangle;
		private var _syncAlign:Boolean = true;
		private var _alignRatioX:Number=0;
		private var _alignRatioY:Number=0;
		private var _padding:Number=0;
		private var _tweenChain:TweenChain;
		private var _isWaiting:Boolean = false;
		protected var _presetWidth:Number=0;
		protected var _presetHeight:Number=0;
		public function Inheritor() {
			// constructor code
			super();
		}
		override public function addChild(child:DisplayObject):DisplayObject{
			spreadAll(_assetManager, _juggler);
			if(child is Inheritor){
				var inh:Inheritor = child as Inheritor;
				inh.assetManager = _assetManager;
				inh.juggler = _juggler;
			}
			var obj:DisplayObject = super.addChild(child);
			return obj;
		}
		override public function removeChild(child:DisplayObject, dispose:Boolean=false):DisplayObject{
			spreadAll();
			var obj:DisplayObject = super.removeChild(child, dispose);
			return obj;
		}
		public function get assetManager():AssetManager{
			return _assetManager;
		}
		public function get juggler():Juggler{
			return _juggler;
		}
		public function set assetManager(am:AssetManager):void{
			_assetManager = am;
			spread(AssetManager, am);
		}
		public function set juggler(jug:Juggler):void{
			_juggler = jug;
			if(_tweenChain!=null && _tweenChain.juggler==null){
				_tweenChain.juggler = jug;
			}
			spread(Juggler, null, jug);
		}
		public function get globalAssets():AssetManager{
			return StarlingOne.globalAssets;
		}
		private function spreadAll(am:AssetManager=null, jug:Juggler=null):void{
			spread(Juggler, null, jug);
			spread(AssetManager, am);
		}
		private function spread(chgClass:Class, am:AssetManager=null, jug:Juggler=null):void{
			trace(numChildren);
			if(numChildren>0){
				var obj:DisplayObject;
				var cnode:Inheritor;
				for(var i:int=0;i<numChildren;i++){
					obj = getChildAt(i);
					if(obj is Inheritor){
						cnode = obj as Inheritor;
						if(chgClass==AssetManager)
							cnode.assetManager = _assetManager
						else
							cnode.juggler = _juggler;
					}else{
						trace("no~~");
					}
				}
			}
		}
		public function get bound():Rectangle{
			var rect:Rectangle;
			if(_bound==null){
				if(_calculatedBound==null){
					if(parent==null){
						return null;
					}
					_calculatedBound = getBounds(parent);
					var w1:Number = _calculatedBound.width;
					trace("width from",w1,_calculatedBound.left,_calculatedBound.right);
					_calculatedBound.left += padding;
					_calculatedBound.right -= padding;
					_calculatedBound.top += padding;
					_calculatedBound.bottom -= padding;
					w1 = _calculatedBound.width;
					trace("width to",w1,_calculatedBound.left,_calculatedBound.right);
					//rect = _calculatedBound;
				}
				rect = _calculatedBound;
			}else{
				rect = _bound;
			}
			
			return rect;
		}
		public function set bound(b:Rectangle):void{
			_bound = b;
		}
		public function get alignRatioX():Number{
			return _alignRatioX;
		}
		public function get alignRatioY():Number{
			return _alignRatioY;
		}
		public function set alignRatioX(ratio:Number):void{
			_alignRatioX = ratio;
			updateAlignment(true);
		}
		public function set alignRatioY(ratio:Number):void{
			_alignRatioY = ratio;
			updateAlignment(true);
		}
		public function get syncAlign():Boolean{
			return _syncAlign;
		}
		public function set syncAlign(sa:Boolean):void{
			if(_syncAlign!=sa){
				_syncAlign=sa;
				updateAlignment(true);
			}
		}
		public function get tweenChain():TweenChain{
			if(_tweenChain == null){
				tweenChainInit();
			}
			return _tweenChain;
		}
		public function get padding():Number{
			return _padding;
		}
		public function set padding(p:Number):void{
			_padding = p;
		}
		override public function set scaleX(w:Number):void{
			super.scaleX = w;
			updateAlignment();
		}
		override public function set scaleY(h:Number):void{
			super.scaleY = h;
			updateAlignment();
		}
		override public function set width(w:Number):void{
			if(numChildren==0){
				_presetWidth = w;
			}else{
				super.width = w;
			}
		}
		override public function set height(h:Number):void{
			if(numChildren==0){
				_presetHeight = h;
			}else{
				super.height = h;
			}
		}
		protected function applyPreset():void{
			if(_presetWidth!=0){
				width = _presetWidth;
				_presetWidth=0;
			}
			if(_presetHeight!=0){
				height = _presetHeight;
				_presetHeight=0;
			}
			dispatchEvent(new PropertyEvent(PropertyEvent.RENDER));
		}
		/*override public function set x (nx:Number):void{
			syncAlign = false;
			super.x = nx;
		}
		override public function set y (ny:Number):void{
			syncAlign = false;
			super.y = ny;
		}*/
		private function tweenChainInit():void{
			_tweenChain = new TweenChain(this, _juggler);
		}
		private function updateAlignment(force:Boolean=false):void{
			if(_syncAlign){
				if(force || !isNaN(_alignRatioX) || !isNaN(_alignRatioY)){
					if(stage==null){
						trace("stage null!");
						if(!_isWaiting){
							_isWaiting = true;
							addEventListener(Event.ADDED_TO_STAGE, onAdded);
						}
					}else{
						Alignment.inBound(this, _alignRatioX, _alignRatioY);
					}
				}
			}
		}
		private function onAdded(e:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			_isWaiting = false;
			trace("in4");
			Alignment.inBound(this, _alignRatioX, _alignRatioY);
		}
	}
}