package starlingone.display {
	import starlingone.events.BridgeEvent;
	import starling.display.Quad;

	public class Bridge extends Inheritor{
		public var from:Board;
		public var to:Board;
		protected var myQuad:Quad;
		public function Bridge() {
			// constructor code
			super();
		}
		public function fadeIn():void{
		}
		public function fadedIn():void{
			dispatchEvent(new BridgeEvent(BridgeEvent.FADED_IN, to, from));
		}
		public function fadeOut(f:Board, t:Board):void{
			from = f;
			to = t;
		}
		public function fadedOut():void{
			dispatchEvent(new BridgeEvent(BridgeEvent.FADED_OUT, to, from));
		}
		public function onProgress(ratio:Number):void{
		}
		protected function createQuad(col:int):Quad{
			myQuad = new Quad(2800, 2000, col);
			myQuad.x=-500;
			myQuad.y=-300;
			return myQuad;
		}
	}
}