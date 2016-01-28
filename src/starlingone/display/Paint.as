package starlingone.display {
	import starling.utils.AssetManager;
	import starling.textures.Texture;
	import flash.display.Bitmap;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.TextureAtlas;

	public class Paint extends Inheritor{
		protected var _textureName:String;
		protected var _subtextureName:String;
		protected var _texture:Texture;
		private var _image:Image;
		protected var _alignCenter:Boolean = false;
		public function Paint(textureName:String=null, subtextureName:String=null) {
			super();
			_textureName = textureName;
			_subtextureName = subtextureName;
			addEventListener(Event.ADDED_TO_STAGE, onCreated);
		}
		public static function createByClass(imageClass:Class):Paint{
			var paint:Paint = new Paint();
			paint.setBgByTexture(Texture.fromEmbeddedAsset(imageClass));
			return paint;
		}
		public function setBgByTexture(texture:Texture):Image{
			if(_image!=null && contains(_image)){
				removeChild(_image);
			}
			_image = new Image(texture);
			addChild(_image);
			applyPreset();
			return _image;
		}
		protected function onCreated(e:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, onCreated);
			
			if(_image==null && _textureName!=null){
				_texture = getTexture(assetManager);
				if(_texture==null){
					_texture = getTexture(globalAssets);
					if(_texture==null){
						throw new Error("Can't find texture : ", _textureName);
					}
				}
				setBgByTexture(_texture);
				_center();
			}
		}
		private function getTexture(am:AssetManager):Texture{
			if(_subtextureName!=null){
				var _atlas:TextureAtlas = am.getTextureAtlas(_textureName);
				if(_atlas==null){
					return null;
				}
				return _atlas.getTexture(_textureName);
			}else{
				return am.getTexture(_textureName);
			}
		}
		public function set alignCenter(ac:Boolean):void{
			_alignCenter = ac;
			if(_image!=null && ac){
				_center();
			}
		}
		public function get alignCenter():Boolean{
			return _alignCenter;
		}
		protected function _center():void{
			_image.x = _image.width*-0.5;
			_image.y = _image.height*-0.5;
		}
		public function disposeTexture():void{
			if(_texture!=null){
				_texture.dispose();
			}
		}
	}
}