package starlingone.display {
	import flash.geom.Rectangle;
	import starlingone.events.PropertyEvent;
	import starling.events.Event;
	import starling.display.Quad;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starlingone.ui.ScrollableContent;
	import starling.display.DisplayObjectContainer;
	import starling.utils.AssetManager;
	import starling.animation.Juggler;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import flash.geom.Point;

	public class Div extends Inheritor{
		public var content:ScrollableContent = new ScrollableContent();
		public var dynamicSize:Boolean = false;
		protected var _scrollable:Boolean = false;
		private var _tapStart:Point;
		private var _tapStartContent:Point;
		public function Div(viewport:Rectangle=null) {
			// constructor code
			super();
			_bound = viewport;
			if(viewport == null){
				dynamicSize = true;
			}else{
				x = _bound.x;
				y = _bound.y;
				_bound.x = 0;
				_bound.y = 0;
			}
			nativeAddChild(content);
			touchable = true;
		}
		public function get scrollable():Boolean{
			return _scrollable;
		}
		public function set scrollable(scroll:Boolean):void{
			if(_scrollable!=scroll){
				if(scroll){
					scrollStart();
				}else{
					scrollEnd();
				}
			}
			_scrollable=scroll;
		}
		protected function scrollStart():void{
			addEventListener(TouchEvent.TOUCH, onTouchEventStart);
		}
		protected function scrollEnd():void{
			removeEventListener(TouchEvent.TOUCH, onTouchEventStart);
		}
		protected function onTouchEventStart(e:TouchEvent):void{
			var t:Touch = e.getTouch(this);
			if(!t){
				return;
			}
			e.stopPropagation();
			switch(t.phase){
				case TouchPhase.BEGAN:
					_tapStart = new Point(t.globalX, t.globalY);
					_tapStartContent = new Point(content.x, content.y);
					break;
				case TouchPhase.MOVED:
					var bd:Rectangle;
					if(content.width>bound.width){
						content.x = _tapStartContent.x+(t.globalX-_tapStart.x);
						bd = content.getBounds(this);
						if(content.x>(content.x-bd.left)){
							content.x = content.x-bd.left;
						}else if(content.x<-(bd.right-content.x-bound.width)){
							content.x = -(bd.right-content.x-bound.width);
						}
					}
					if(content.height>bound.height){
						content.y = _tapStartContent.y+(t.globalY-_tapStart.y);
						bd = content.getBounds(this);
						if(content.y>(content.y-bd.top)){
							content.y = content.y-bd.top;
						}else if(content.y<-(bd.bottom-content.y-bound.height)){
							content.y = -(bd.bottom-content.y-bound.height);
						}
					}
					break;
				case TouchPhase.ENDED:
					_tapStart = null;
					_tapStartContent = null;
					break;
			}
		}
		override public function set assetManager(am:AssetManager):void{
			content.assetManager = am;
			super.assetManager = am;
		}
		override public  function set juggler(jug:Juggler):void{
			content.juggler = jug;
			super.juggler = jug;
		}
		public function addBackground(value:*):void{
			if(_bound!=null){
				if(value is String){
					var p:Paint = new Paint(value);
					p.addEventListener(PropertyEvent.RENDER, function(e:Event):void{
						p.width = bound.width;
						p.height = bound.height;
					});
					nativeAddChildAt(p, 0);
				}else if(value is int){
					var q:Quad = new Quad(bound.width, bound.height, value);
					nativeAddChildAt(q, 0);
				}
			}
		}
		protected function defaultBound(obj:DisplayObject):void{
			if(obj is Div && obj!=null){
				var div:Div = obj as Div;
				if(div.dynamicSize){
					div.bound = bound;
				}
			}
		}
		override public function get numChildren():int{
			return content.numChildren;
		}
		override public function addChild(child:DisplayObject):DisplayObject{
			var obj:DisplayObject = content.addChild(child);
			defaultBound(obj);
			return obj;
		}
		
		override public function getChildIndex(child:DisplayObject):int{
			return content.getChildIndex(child);
		}
		override public function getChildAt(index:int):DisplayObject{
			return content.getChildAt(index);
		}
		override public function getChildByName(name:String):DisplayObject{
			return content.getChildByName(name);
		}
		override public function removeChild(child:DisplayObject, dispose:Boolean=false):DisplayObject{
			return content.removeChild(child, dispose);
		}
		override public function removeChildAt(index:int, dispose:Boolean=false):DisplayObject{
			return content.removeChildAt(index, dispose);
		}
		override public function contains(child:DisplayObject):Boolean{
			return content.contains(child);
		}
		public function nativeAddChild(child:DisplayObject):DisplayObject{
			return super.addChild(child);
		}
		public function nativeAddChildAt(child:DisplayObject, index:int):DisplayObject{
			return super.addChildAt(child, index);
		}
		public function nativeGetChildIndex(child:DisplayObject):int{
			return super.getChildIndex(child);
		}
		public function nativeGetChildAt(index:int):DisplayObject{
			return super.getChildAt(index);
		}
		public function nativeGetChildByName(name:String):DisplayObject{
			return super.getChildByName(name);
		}
		public function nativeContains(child:DisplayObject):Boolean{
			return super.contains(child);
		}
		
		
		
		/*override public function addChildAt(child:DisplayObject, index:int):DisplayObject{
			var obj:DisplayObject = content.addChildAt(child, index);
			defaultBound(obj);
			return obj;
		}*/
	}
}