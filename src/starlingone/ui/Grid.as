package starlingone.ui {
	import starling.display.Sprite;
	import starling.display.DisplayObject;
	import starlingone.display.Inheritor;
	import flash.geom.Rectangle;
	import starling.display.Quad;
	import starlingone.display.Paint;
	import starlingone.utils.Rgb;

	public class Grid extends Sprite{
		private var _viewPort:Rectangle;
		private var _colorize:Boolean = false;
		public var _quad:Quad;
		public var children:Vector.<Grid> = new Vector.<Grid>();
		public var color:int=0xffffff;
		public var gridSet:Gridset;
		public function Grid(rect:Rectangle, border:Number=1) {
			super();
			_viewPort = rect;
			//_quad = new Paint("ff");
			_quad = new Quad(_viewPort.width, _viewPort.height, 0);
			addChild(_quad);
			x = _viewPort.x;	
			y = _viewPort.y;
			_quad.width = _viewPort.width-(border*2);
			_quad.height = _viewPort.height-(border*2);
			_quad.x = border;
			_quad.y = border;
			_quad.alpha = 0;
			_colorize = true;
			// constructor code
		}
		override public function addChild(obj:DisplayObject):DisplayObject{
			var ret:DisplayObject;
			if(!(obj is Grid) && numChildren>0){
				throw new Error("Grid can only add grid child");
			}else{
				if(contains(_quad)){
					removeChild(_quad);
				}
				ret = super.addChild(obj);
				if(obj is Grid){
					var grid:Grid = obj as Grid;
					grid.colorize = colorize;
				}
			}
			return ret;
		}
		public function split(numCell:int, isVertical:Boolean=false, firstGridLength:Number=0, reverse:Boolean=false):Gridset{
			var gs:Gridset = new Gridset();
			var totalLength:Number;
			var fixedLength:Number;
			var fixedPos:Number = 0;
			var posOffset:Number=0;
			var seq:Number=0;
			var averageLength:Number;
			var averageNum:Number;
			var grid:Grid;
			var rect:Rectangle;
			var pos:Number;
			var averageCount:int=numCell;
			var endGrid:Grid;
			if(isVertical){
				totalLength = _viewPort.height;
				fixedLength = _viewPort.width;
			}else{
				totalLength = _viewPort.width;
				fixedLength = _viewPort.height;
			}
			if(firstGridLength>0){
				if(firstGridLength<=1){
					firstGridLength = totalLength*firstGridLength;
				}
				averageCount-=1;
				averageLength = (totalLength-firstGridLength)/averageCount;
				if(reverse){
					endGrid = create(isVertical, firstGridLength, fixedLength, 0, fixedPos);
				}else{
					append(create(isVertical, firstGridLength, fixedLength, 0, fixedPos), gs, 0);
					posOffset = firstGridLength;
					seq = 1;
				}
			}else{
				averageLength = totalLength/numCell;
			}
			for(var i:int=0;i<averageCount;i++){
				pos = i*averageLength+posOffset;
				append(create(isVertical, averageLength, fixedLength, pos, fixedPos), gs, seq/numCell);
				seq++;
			}
			if(endGrid!=null){
				append(endGrid, gs, seq/numCell);
			}
			gridSet = gs;
			return gs;
		}
		private function append(grid:Grid, gs:Gridset, percent:Number):int{
			var ind:int = children.length;
			
			gs.append(grid);
			children.push(grid);
			addChild(grid);
			grid.changeColor(0xff00ff, percent);
			return ind;
		}
		public function get colorize():Boolean{
			return _colorize;
		}
		public function changeColor(col:int,percent:Number):void{
			var rgb:Rgb = Rgb.hexToRgb(col);
			rgb.red *= percent;
			rgb.green *= percent;
			rgb.blue *= percent;
			_quad.color = rgb.toHex();
		}
		public function set colorize(col:Boolean):void{
			_colorize = col;
			if(col){
				//_quad.color = Math.random()*0xffffff;
				//_quad.alpha = 0.5;
				_quad.alpha = 0.5;
			}else{
				_quad.alpha = 0;
			}
		}
		public function flattenIn(org:Vector.<Grid>=null):Vector.<Grid>{
			var child:DisplayObject;
			var grid:Grid;
			if(org==null){
				org = new Vector.<Grid>();
			}
			if(children.length==0){
				org.push(this);
			} else {
				for(var i:int=0; i<children.length; i++){
					child = children[i];
					if(child is Grid){
						grid = child as Grid;
						grid.flattenIn(org);
					}
				}
			}
			return org;
		}
		public static function create(isVertical:Boolean, leng:Number, fixedLength:Number, pos:Number=0, fixedPos:Number=0):Grid{
			var rect:Rectangle;
			if(isVertical){
				rect = new Rectangle(0, 0, fixedLength, leng);
				rect.y = pos;
			}else{
				rect = new Rectangle(0, 0, leng, fixedLength);
				rect.x = pos;
			}
			var grid:Grid = new Grid(rect);
			return grid;
		}
	}
}