package starlingone.display {
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.utils.AssetManager;
	import starling.textures.TextureAtlas;
	import starling.textures.Texture;
	import starlingone.StarlingOne;
	import starling.animation.Tween;

	public class Animator extends Inheritor{
		private var _textureName:String;
		private var _currentMc:MovieClip;
		private var _defaultMc:MovieClip;
		private var _defaultLabel:String;
		private var _atlas:TextureAtlas;
		private var _endingAction:String;
		public function Animator(textureName:String=null, defaultLabel:String=null) {
			// constructor code
			super();
			_textureName = textureName;
			_defaultLabel = defaultLabel;
			addEventListener(Event.ADDED_TO_STAGE, onCreated);
		}
		protected function onCreated(e:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, onCreated);
			
			if(_atlas==null && _textureName!=null){
				var atlas:TextureAtlas = assetManager.getTextureAtlas(_textureName);
				if(atlas==null){
					atlas = globalAssets.getTextureAtlas(_textureName);
					if(atlas==null){
						throw new Error("Can't find texture atlas : ",_textureName);
					}
				}
				_atlas = atlas;
				//if(_defaultLabel!=null){
				back();
				applyPreset();
				//}
			}
		}
		private function removeCurrentMc():void{
			if(_currentMc!=null && contains(_currentMc)){
				juggler.remove(_currentMc);
				removeChild(_currentMc);
				_currentMc.removeEventListener(Event.COMPLETE, onMcComplete);
			}
		}
		public function gotoAndPlay(frameLabel:String, endingAction:String="back"):Number{
			_endingAction = endingAction;
			
			removeCurrentMc();
			var frames:Vector.<Texture> = _atlas.getTextures(frameLabel);
			var mc:MovieClip = new MovieClip(frames, StarlingOne.frameRate);
			if(endingAction!=EndingAction.LOOP && endingAction!=EndingAction.ONCE){
				mc.addEventListener(Event.COMPLETE, onMcComplete);
			}
			mc.currentFrame = 0;
			if(endingAction==EndingAction.LOOP){
				mc.loop = true;
			}else if(endingAction==EndingAction.ONCE){
				mc.loop = false;
			}
			_currentMc = mc;
			juggler.add(_currentMc);
			addChild(_currentMc);
			
			return _currentMc.totalTime;
		}
		public function gotoAndStop(frameLabel:String):void{
			gotoAndPlay(frameLabel, EndingAction.LOOP);
			_currentMc.stop();
		}
		public function stop():void{
			if(_currentMc!=null){
				_currentMc.stop();
			}
		}
		public function play():void{
			if(_currentMc!=null){
				_currentMc.play();
			}
		}
		public function back():void{
			if(_defaultLabel!=null){
				gotoAndPlay(_defaultLabel, EndingAction.LOOP);
			}else{
				gotoAndPlay("", EndingAction.LOOP);
			}
		}
		private function onMcComplete(e:Event):void{
			if(_endingAction==EndingAction.BACK){
				back();
			}else if(_endingAction==EndingAction.DISPOSE){
				removeCurrentMc();
				_currentMc.dispose();
				dispose();
			}
		}
		public function disposeTexture():void{
			if(_atlas!=null){
				_atlas.dispose();
			}
		}
	}
}