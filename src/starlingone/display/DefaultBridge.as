package starlingone.display {
	import starling.animation.Tween;
	import starling.animation.Transitions;
	import starling.display.Quad;
	import starling.core.Starling;
	import starlingone.animation.TweenChain;

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
			
			tweenChain.animate({"alpha":0}, _duration).done(fadedIn);
			return;
			/*var tw:Tween = new Tween(myQuad, _duration);
			myQuad.alpha=1;
			tw.animate("alpha", 0);
			tw.onComplete = fadedIn;
			juggler.add(tw);*/
		}
		override public function fadeOut(f:Board, t:Board):void{
			super.fadeOut(f, t);
			
			myQuad = createQuad(_color);
			alpha = 0;
			//myQuad.alpha = 0;
			tweenChain.animate({"alpha":1}, _duration).done(fadedOut);
			addChild(myQuad);
			return;
			/*var tw:Tween = new Tween(myQuad, _duration);
			myQuad.alpha=0;
			tw.animate("alpha", 1);
			tw.onComplete = fadedOut;
			juggler.add(tw);
			addChild(myQuad);*/
		}
	}
}