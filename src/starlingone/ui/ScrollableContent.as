package starlingone.ui {
	import starlingone.display.Inheritor;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	
	public class ScrollableContent extends Inheritor{
		public function ScrollableContent() {
			// constructor code
			super();
		}
		/*override public function get parent():DisplayObjectContainer{
			if(super.parent==null){
				return null;
			}
			return super.parent.parent as DisplayObjectContainer;
		}*/
	}
	
}
