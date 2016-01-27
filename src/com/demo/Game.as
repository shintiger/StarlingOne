package com.demo {
	import starlingone.StarlingOne;
	import starlingone.display.Board;
	import starlingone.display.Paint;
	import starlingone.display.Animator;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starlingone.events.BoardEvent;
	import starling.events.EnterFrameEvent;
	import starling.display.DisplayObject;
	import starlingone.ui.Alignment;
	import starling.display.Quad;
	import starlingone.display.Inheritor;
	import starling.display.DisplayObjectContainer;
	import starlingone.ui.Grid;
	import starling.animation.Tween;
	import flash.geom.Rectangle;

	public class Game extends StarlingOne{
		/* PNG texture */
		[Embed(source="/assets/default.png")]
		public static const defaultBg:Class;
		public static var ratio:Number = 0;
		public static var ratioSpeed:Number = 0.01;
		public function Game() {
			super(defaultBg);
			var landBoard:Board = new Board(["assets/landing", "assets/monster"]);
			var paint:Paint = new Paint("3b4");
			landBoard.addEventListener(TouchEvent.TOUCH, onTouch);
			landBoard.addEventListener(BoardEvent.ACTIVATED, onAct);
			landBoard.addChild(paint);
			start(landBoard);
			//alpha = 0.2;
		}
		private function onAct(e:BoardEvent):void{
			var anim:Animator = new Animator("quad", "none");
			var landBoard:Board = e.target as Board;
			loadGlobalAsset(["assets/movie"], function():void{
				landBoard.addChild(anim);
			},
			function(ratio:Number):void{
				trace("global ratio:", ratio);
			});
		}
		private function onTouch(e:TouchEvent):void{
			var t:Touch = e.getTouch(this);
			trace("hey");
			if(t && t.phase == TouchPhase.BEGAN){
				trace("ho!");
				var board:Board = new Board(["assets/monster", "assets/test"]);
				var anim:Animator = new Animator("movingquad");
				var cQuad:Quad = new Quad(800, 500, 0xff00ff);
				var cn:Inheritor = new Inheritor();
				cn.name = "cn";
				anim.name = "dragon"
				anim.x -= 100;
				anim.y -= 40;
				cQuad.x = 10;
				cQuad.y = 20;
				
				var rect:Rectangle = new Rectangle(0, 0, StarlingOne.displayWidth, StarlingOne.displayHeight);
				var grid:Grid = new Grid(rect);
				var subGrid:Grid;
				grid.colorize = true;
				//grid.split(12, false)
				//grid.split(4, false).childAt(1).split(5, true);
				grid.split(4, false, 0.6, true)[1].split(5, true)[3].split(8, false, 0.4);
				subGrid = grid.gridSet[1][3][7] as Grid;
				trace(subGrid.width, subGrid.height);
				board.addChild(grid);
				/*
				board.addChild(cQuad);
				board.addEventListener(BoardEvent.COMPLETED, onCompleted);
				board.addEventListener(BoardEvent.ACTIVATED, onActivated);
				board.addChild(anim);
				board.addChild(cn);*/
				StarlingOne.switchToBoard(board);
			}
		}
		private function onCompleted(e:BoardEvent):void{
			var board:Board = e.target as Board;
			//board.getChildByName("dragon").x=200;
		}
		private function onActivated(e:BoardEvent):void{
			var board:Board = e.target as Board;
			var an:Animator = board.getChildByName("dragon") as Animator;
			board.padding = 100;
			an.alignRatioX = .05;
			an.alignRatioY = .95;
			an.tweenChain.animate({"alignRatioX":0, "alignRatioY":0}, .5).animate({"alignRatioX":1, "alignRatioY":0}, .5).animate({
					"alignRatioX":1, "alignRatioY":1}, .5).animate({"alignRatioX":0, "alignRatioY":1}, .5);
			return;
		}
	}
}