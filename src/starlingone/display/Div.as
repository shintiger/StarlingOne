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

	public class Div extends Inheritor{
		public var content:ScrollableContent = new ScrollableContent();
		public var dynamicSize:Boolean = false;
		public function Div(viewport:Rectangle=null) {
			// constructor code
			super();
			_bound = viewport;
			if(viewport == null){
				dynamicSize = true;
			}
			nativeAddChild(content);
			touchable = true;
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
			if(obj is Div){
				var div:Div = div as Div;
				if(div.dynamicSize){
					div.bound = bound;
				}
			}
		}
		/*
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
			return super.removeChild(child, dispose);
		}
		override public function removeChildAt(index:int, dispose:Boolean=false):DisplayObject{
			return super.removeChildAt(index, dispose);
		}*/
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
		override public function get numChildren():int{
			return content.numChildren;
		}
		
		
		/*override public function addChildAt(child:DisplayObject, index:int):DisplayObject{
			var obj:DisplayObject = content.addChildAt(child, index);
			defaultBound(obj);
			return obj;
		}*/
	}
}