package starlingone.events {
	import starling.events.Event;
	import starlingone.display.Board;

	public class BridgeEvent extends Event{
		public static const FADED_IN:String="onefadedin";
		public static const FADED_OUT:String="onefadedout";
		public static const LOAD_COMPLETE:String="oneloadcomplete";
		public var from:Board;
		public var to:Board;
		public function BridgeEvent(str:String, t:Board, f:Board=null) {
			// constructor code
			super(str, true);
			from = f;
			to = t;
		}

	}
}