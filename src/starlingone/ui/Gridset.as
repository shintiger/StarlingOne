package starlingone.ui {
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	public dynamic class Gridset extends Proxy{
		private var _children:Vector.<Grid> = new Vector.<Grid>();
		public function Gridset() {
			// constructor code
		}
		override flash_proxy function getProperty(name:*):* {
			var grid:Grid = _children[name];
			if(grid.gridSet!=null){
				return grid.gridSet;
			}
			return grid;
		}
		public function append(grid:Grid):Grid{
			_children.push(grid);
			return grid;
		}
		public function childAt(pos:int):Grid{
			return _children[pos];
		}
	}
}