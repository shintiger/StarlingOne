package starlingone.events {
	import starling.events.Event;
	import starlingone.animation.TweenNode;

	public class TweenQueryEvent extends Event{
		public static const END:String="oneend";
		public static const CHANGE:String="onechange";
		public var recentCompleted:TweenNode;
		public var next:TweenNode;
		public function TweenQueryEvent(type:String, bubbling:Boolean=false, data:Object=null) {
			// constructor code
			super(type, bubbling, data);
		}
	}
}