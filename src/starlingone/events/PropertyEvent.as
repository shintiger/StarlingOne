package starlingone.events {
	import starling.events.Event;

	public class PropertyEvent extends Event{
		public static const RENDER:String="onerender";
		public function PropertyEvent(type:String, bubbling:Boolean=false, data:Object=null) {
			// constructor code
			super(type, bubbling, data);
		}
	}
}
