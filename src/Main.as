package  {
	import flash.display.Sprite;
	import starling.core.Starling;
	import com.demo.Game;
	import starlingone.StarlingOne;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;

	public class Main extends Sprite{
		private var _starling:Starling;
		public function Main() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			Starling.multitouchEnabled = true;
			_starling = new Starling(Game, stage);
			_starling.start();
			Starling.current.showStats = true;
		}
	}
}