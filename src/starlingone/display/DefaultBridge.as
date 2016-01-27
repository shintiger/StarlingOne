package starlingone.display {
	import starling.animation.Tween;
	import starling.animation.Transitions;
	import starling.display.Quad;
	import starling.core.Starling;

	public class DefaultBridge extends Bridge{
		private var _duration:Number;
		private var _color:int;
		protected var haha:String="xdd";
		public function DefaultBridge(duration:Number=0.5, color=0x000000) {
			super();
			_duration = duration;
			_color = color;
		}
		override public function onProgress(ratio:Number):void{
			trace("loaded:",ratio,haha);
		}
		override public function fadeIn():void{
			super.fadeIn();
			
			var tw:Tween = new Tween(myQuad, _duration);
			myQuad.alpha=1;
			tw.animate("alpha", 0);
			tw.onComplete = fadedIn;
			juggler.add(tw);
		}
		override public function fadeOut(f:Board, t:Board):void{
			super.fadeOut(f, t);
			
			myQuad = createQuad(_color);
			var tw:Tween = new Tween(myQuad, _duration);
			myQuad.alpha=0;
			tw.animate("alpha", 1);
			tw.onComplete = fadedOut;
			juggler.add(tw);
			addChild(myQuad);
		}
	}
}