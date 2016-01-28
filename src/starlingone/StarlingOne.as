package starlingone {
	//import flash.display.Sprite;
	//import flash.events.Event;
	import starling.core.Starling;
	import starlingone.display.Board;
	import starling.utils.AssetManager;
	import starlingone.display.Bridge;
	import starlingone.events.BridgeEvent;
	import starling.display.Sprite;
	import starling.events.Event;
	import starlingone.background.AssetTray;
	import starlingone.display.Paint;
	import starling.display.Image;
	import starlingone.events.BoardEvent;
	import starlingone.display.DefaultBridge;
	import flash.geom.Rectangle;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	import flash.geom.Point;

	public class StarlingOne extends Sprite{
		public static const VERSION:Number=0.3;
		public static var frameRate:int = 0;
		public static var displayWidth:Number;
		public static var displayHeight:Number;
		public static var stageWidth:Number;
		public static var stageHeight:Number;
		public static var currentBoard:Board;
		public static var globalAssets:AssetManager;
		private static var _instance:StarlingOne;
		protected var _starling:Starling;
		protected var lastBridge:Bridge;
		protected var isSwitching:Boolean = false;
		private var defaultImage:Class;
		private var defaultPaint:Paint;
		private var _viewPort:Rectangle;
		private var _started:Boolean = false;
		//private var landingBoard:Board;
		public function StarlingOne(defaultImg:Class=null) {
			// constructor code
			if(_instance!=null && _instance!=this){
				throw new Error("StarlingOne must be singleton");
			}
			_instance = this;
			defaultImage = defaultImg;
			
			if(stage!=null){
				init();
			}else{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		public function start(landBoard:Board):void{
			///landingBoard = landBoard;
			//currentBoard = landingBoard;
			currentBoard = landBoard;
			globalAssets = new AssetManager();
			currentBoard.addEventListener(BoardEvent.COMPLETED, onInitiated);
			_start();
		}
		private function _start():void{
			if(!_started && currentBoard!=null && frameRate!=0){
				currentBoard.init();
				_started = true;
			}
		}
		protected function init(e:Event=null):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addEventListener(Event.RESIZE, onResize);
			onResize();
			stageWidth = Starling.current.nativeStage.stageWidth;
			stageHeight = Starling.current.nativeStage.stageHeight;
			displayWidth = stageWidth;
			displayHeight = stageHeight;
			frameRate = Starling.current.nativeStage.frameRate;
			if(defaultImage!=null){
				defaultPaint = Paint.createByClass(defaultImage);
				addChild(defaultPaint);
			}
			_start();
		}
		private function onInitiated(e:Event):void{
			if(contains(defaultPaint)){
				removeChild(defaultPaint);
				defaultPaint.disposeTexture();
			}
			addEventListener(BoardEvent.SWITCH, onSwitch);
			currentBoard.removeEventListener(BoardEvent.COMPLETED, onInitiated);
			addChild(currentBoard);
			currentBoard.onActivate();
		}
		public static function switchToBoard(target:*, bridge:Bridge=null):void{
			var sOne:StarlingOne = getInstance();
			if(sOne.isSwitching){
				return;
			}
			var e:BoardEvent = new BoardEvent(BoardEvent.SWITCH, true);
			if(target is String){
				e.actionStr = target;
			}else if(target is Board){
				e.createdBoard = target;
			}
			if(bridge!=null){
				e.createdBridge = bridge;
			}else{
				e.createdBridge = new DefaultBridge();
			}
			sOne.dispatchEvent(e);
		}
		public static function loadGlobalAsset(rawAssets:Array, onComplete:Function=null, onProgress:Function=null):AssetManager{
			Board.enqueueArray(rawAssets, globalAssets);
			globalAssets.loadQueue(function(ratio:Number){
				if(ratio==1.0 && onComplete!=null){
					onComplete();
				}else if(onProgress!=null){
					onProgress(ratio);
				}
			});
			return globalAssets;
		}
		private function onSwitch(e:BoardEvent):void{
			if(e.createdBoard!=null && e.createdBridge!=null){
				switchBoard(e.createdBoard, e.createdBridge);
			}
		}
		public static function getInstance():StarlingOne{
			return _instance;
		}
		public static function get currentAssets():AssetManager{
			return currentBoard.assetManager;
		}
		protected function switchBoard(toBoard:Board, bridge:Bridge):void{
			isSwitching = true;
			currentBoard.onDeactivate();
			bridge.addEventListener(BridgeEvent.FADED_OUT, onFadedOut);
			bridge.assetManager = globalAssets;
			bridge.juggler = Starling.juggler;
			addChild(bridge);
			lastBridge = bridge;
			trace("toBoard:", toBoard);
			bridge.fadeOut(currentBoard, toBoard);
		}
		private function onFadedOut(e:BridgeEvent):void{
			var bridge:Bridge = e.target as Bridge;
			bridge.removeEventListener(BridgeEvent.FADED_OUT, onFadedOut);
			
			var to:Board = bridge.to;
			var from:Board = bridge.from;
			if(contains(from)){
				removeChild(from);
				from.dispose();
			}
			trace("bridge.to:", bridge.to);
			currentBoard = to;
			currentBoard.addEventListener(BoardEvent.COMPLETED, onLoaderComplete);
			//currentBoard.addEventListener(BridgeEvent.LOAD_COMPLETE, onLoaderComplete);
			//currentBoard.progressUpdateTo = bridge;
			currentBoard.init(bridge.onProgress);
		}
		//private function onLoaderComplete(e:BridgeEvent):void{
		private function onLoaderComplete(e:Event):void{
			addChildAt(currentBoard, 0);
			currentBoard.removeEventListener(BoardEvent.COMPLETED, onLoaderComplete);
			//currentBoard.removeEventListener(BridgeEvent.LOAD_COMPLETE, onLoaderComplete);
			lastBridge.addEventListener(BridgeEvent.FADED_IN, onFadedIn);
			lastBridge.fadeIn();
		}
		private function onFadedIn(e:BridgeEvent):void{
			lastBridge.removeEventListener(BridgeEvent.FADED_IN, onFadedIn);
			removeChild(lastBridge, true);
			isSwitching = false;
			currentBoard.onActivate();
		}
		protected function onResize(e:Event=null,size:Point=null):void{
			if(size==null){
				return;
			}
			RectangleUtil.fit(
				new Rectangle(0, 0, stage.stageWidth, stage.stageHeight),
				new Rectangle(0, 0, size.x, size.y),
				ScaleMode.SHOW_ALL, false,
				Starling.current.viewPort
			);
			
		}
		public static function get viewport():Rectangle{
			return new Rectangle(0, 0, displayWidth, displayHeight);
		}
	}
}