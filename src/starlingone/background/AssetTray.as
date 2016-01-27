package starlingone.background {
	import starling.utils.AssetManager;
	
	public class AssetTray extends AssetManager{
		//public var enqueuing:Vector.<*> = new Vector.<*>();
		public function AssetTray(scaleFactor:Number=1, useMipmaps:Boolean=false) {
			super(scaleFactor, useMipmaps);
		}
		public function getQuery():Array{
			return queue;
		}
		/*
		override public function enqueue(...rawAssets):void{
			enqueuing.push(rawAssets);
			super.enqueue.apply(this, rawAssets);
		}
		override public function loadQueue(onProgress:Function):void{
			clearQuery();
			super.loadQueue(onProgress);
		}
		override public function purge():void{
			clearQuery();
			super.purge();
		}
		override public function purgeQueue():void{
			clearQuery();
			super.purgeQueue();
		}
		protected function clearQuery():void{
			enqueuing = new Vector.<*>();
		}
		public function getList(){
			this.getList(
		}*/
	}
}