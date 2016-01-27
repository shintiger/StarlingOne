package  {
	import flash.display.Sprite;
	import starling.core.Starling;
	import com.demo.Game;
	import starlingone.StarlingOne;

	public class Main extends Sprite{
		private var _starling:Starling;
		public function Main() {
			Starling.multitouchEnabled = true;
			_starling = new Starling(Game, stage);
			_starling.start();
			Starling.current.showStats = true;
		}
	}
}