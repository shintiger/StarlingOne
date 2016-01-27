package starlingone.events {
	import starling.events.Event;
	import starlingone.display.Board;
	import starlingone.display.Bridge;

	public class BoardEvent extends Event{
		public static const COMPLETED:String="oneboardcompleted";
		public static const ACTIVATED:String="oneboardactivated";
		public static const SWITCH:String="oneboardswitch";
		public var actionStr:String;
		public var createdBoard:Board;
		public var createdBridge:Bridge;
		public function BoardEvent(type:String, bubbling:Boolean=false, data:Object=null) {
			// constructor code
			super(type, bubbling, data);
		}
	}
}