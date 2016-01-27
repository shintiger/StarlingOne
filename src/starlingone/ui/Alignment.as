package starlingone.ui {
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import starlingone.display.Inheritor;

	public class Alignment {
		public function Alignment() {
			// constructor code
		}
		public static function inBound(child:DisplayObject, ratioX:Number=0.5, ratioY:Number=0.5, parent:DisplayObjectContainer=null):void{
			var sp:DisplayObjectContainer;
			var noParent:Boolean = false;
			var childId:int=-1;
			if(parent == null){
				parent = child.parent;
				if(parent == null){
					return;
				}else if(parent is ScrollableContent){
					parent = child.parent.parent;
					if(parent==null){
						return;
					}
				}
			}
			if(parent.parent == null){
				sp = new DisplayObjectContainer();
				sp.addChild(parent);
				noParent = true;
			}
			var grandParent:DisplayObjectContainer = parent.parent;
			var bound:Rectangle = child.getBounds(parent);
			if(parent.contains(child)){
				childId = parent.getChildIndex(child);
				parent.removeChild(child);
			}
			var grandBound:Rectangle = parent.getBounds(parent.parent);
			if(parent is Inheritor){
				var inh:Inheritor = parent as Inheritor;
				grandBound = inh.bound;
			}
			if(childId>0){
				parent.addChildAt(child, childId);
			}
			var grandBoundOffsetX:Number = grandBound.left-parent.x;
			var grandBoundOffsetY:Number = grandBound.top-parent.y;
			var boundOffsetX:Number = bound.left-child.x;
			var boundOffsetY:Number = bound.top-child.y;
			var minX:Number = grandBoundOffsetX-boundOffsetX;
			var minY:Number = grandBoundOffsetY-boundOffsetY;
			var maxX:Number = grandBound.right-parent.x-(bound.right-child.x);
			var maxY:Number = grandBound.bottom-parent.y-(bound.bottom-child.y);
			
			if(noParent){
				sp.removeChild(parent);
			}
			//trace("maxmin",maxX, minX, grandBoundOffsetX,boundOffsetX, child.x, bound.left, grandParent, ratioX, ratioY);
			child.x = minX+(maxX-minX)*ratioX;
			child.y = minY+(maxY-minY)*ratioY;
		}
	}
}