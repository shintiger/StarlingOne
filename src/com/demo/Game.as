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
	import starlingone.display.Div;
	import nape.geom.Vec2;
	import starlingone.display.DefaultBridge;
	import nape.space.Space;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import nape.util.Debug;
	import nape.util.BitmapDebug;
	import starling.core.Starling;
	import nape.phys.Material;
	import nape.shape.Circle;

	public class Game extends StarlingOne{
		/* PNG texture */
		[Embed(source="/assets/default.png")]
		public static const defaultBg:Class;
		public static var ratio:Number = 0;
		public static var ratioSpeed:Number = 0.01;
		public function Game() {
			super(defaultBg);
			//var landBoard:Board = new Board(["assets/landing", "assets/monster"]);
			var landBoard:Board = new Board();
			//var paint:Paint = new Paint("3b4");
			landBoard.addEventListener(TouchEvent.TOUCH, onTouch);
			//landBoard.content.addEventListener(TouchEvent.TOUCH, onTouch);
			//paint.addEventListener(TouchEvent.TOUCH, onTouch);
			landBoard.addEventListener(BoardEvent.ACTIVATED, onAct);
			//landBoard.addChild(paint);
			start(landBoard);
			alpha = 0.2;
		}
		private function onAct(e:BoardEvent):void{
			var anim:Animator = new Animator("quad", "none");
			var landBoard:Board = e.target as Board;
			loadGlobalAsset(["assets/movie"], function():void{
				landBoard.addChild(anim);
				trace("done!");
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
				var div:Div = new Div(subGrid.getBounds(grid));
				div.addChild(anim);
				div.scrollable = true;
				//board.addChild(div);
				div.addBackground(0xff00f0);
				trace(subGrid.width, subGrid.height);
				//board.addChild(grid);
				
				/*board.addChild(cQuad);
				board.addEventListener(BoardEvent.COMPLETED, onCompleted);
				board.addEventListener(BoardEvent.ACTIVATED, onActivated);
				board.addChild(anim);
				board.addChild(cn);*/
				//func(board);
				var napeBoard:NapeCase = new NapeCase(["assets/test", "assets/landing"], viewport);
				var bdg = new DefaultBridge(0.2, 0xff00ff);
				StarlingOne.switchToBoard(napeBoard, bdg);
			}
		}
		private function func(bo:Board):void{
			var space:Space = new Space(new Vec2(0, 5000));
			var floorPhysicsBody:Body = new Body(BodyType.STATIC);
			var p:Polygon = new Polygon (
				Polygon.rect(
					0, 			// x position
					stage.stageHeight, 	// y position
					stage.stageWidth, 	// width
					100			// height
				)
			);
			var paint:Paint = new Paint("ff");
			currentBoard.addChild(paint);
			floorPhysicsBody.shapes.add(p);
			space.bodies.add(floorPhysicsBody);
			floorPhysicsBody.space = space;
			var ballPhysicsBody:Body = new Body(BodyType.DYNAMIC, new Vec2(100, 100));
			var material:Material = new Material(1.5);
			ballPhysicsBody.shapes.add(new Circle(paint.width / 2, null, material));
			space.bodies.add(ballPhysicsBody);
			ballPhysicsBody.userData.graphic = paint;
			addEventListener(EnterFrameEvent.ENTER_FRAME, function(e:EnterFrameEvent):void{
				space.step(1 / frameRate);
				space.liveBodies.foreach(function(b:Body):void{
					var graphic:Paint = b.userData.graphic;
					graphic.x = b.position.x;
					graphic.y = b.position.y;
					graphic.rotation = (b.rotation * 180 / Math.PI) % 360;
				});
			});
			//Starling.current.nativeStage.addChild(debug.display);
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