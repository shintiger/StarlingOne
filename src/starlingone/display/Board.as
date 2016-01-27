package starlingone.display {
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;
	import starlingone.events.BridgeEvent;
	import flash.filesystem.File;
	import starling.animation.Juggler;
	import starling.events.EnterFrameEvent;
	import starlingone.events.BoardEvent;
	import flash.geom.Rectangle;
	
	public class Board extends Frame{
		public var isActivated:Boolean = false;
		private var isInited:Boolean = false;
		protected var _onProgress:Function;
		public function Board(assetQuery:Array=null,viewport:Rectangle=null) {
			// constructor code
			super();
			assetManager = new AssetManager();
			juggler = new Juggler();
			if(assetQuery!=null){
				enqueueArray(assetQuery, assetManager);
			}
			addEventListener(Event.ADDED_TO_STAGE, launch);
		}
		protected function launch(e:Event=null):void{
			removeEventListener(Event.ADDED_TO_STAGE, launch);
			play();
		}
		public function init(onProgress:Function=null):void{
			if(isInited){
				return;
			}
			_onProgress = onProgress;
			isInited = true;
			if(_assetManager.numQueuedAssets>0){
				_assetManager.loadQueue(onAssetProgress);
			}
		}
		public function onActivate():void{
			isActivated = true;
			dispatchEvent(new BoardEvent(BoardEvent.ACTIVATED));
		}
		public function onDeactivate():void{
			isActivated = false;
			touchable = false;
		}
		protected function onAssetProgress(ratio:Number):void{
			if(_onProgress!=null){
				_onProgress(ratio);
			}
			if(ratio==1.0){
				dispatchEvent(new BoardEvent(BoardEvent.COMPLETED));
			}
		}
		protected function remove(e:Event):void{
		}
		override public function dispose():void{
			_assetManager.purge();
			_juggler.purge();
			coreDispose();
		}
		public function coreDispose():void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			removeEventListener(Event.REMOVED_FROM_STAGE, remove);
			super.dispose();
		}
		public function play():void{
			addEventListener(EnterFrameEvent.ENTER_FRAME, onLoop);
		}
		public function stop():void{
			removeEventListener(EnterFrameEvent.ENTER_FRAME, onLoop);
		}
		protected function onLoop(e:EnterFrameEvent):void{
			juggler.advanceTime(e.passedTime);
		}
		public static function enqueueArray(assetQuery:Array, am:AssetManager):void{
			var appDir:File = File.applicationDirectory;
			for each (var path:String in assetQuery){
				if(path is String){
					am.enqueue(appDir.resolvePath(path));
				}
			}
		}
	}
}
