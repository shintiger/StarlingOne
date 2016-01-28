package com.demo {
	import starlingone.display.Board;
	import flash.geom.Rectangle;
	import starling.events.EnterFrameEvent;
	import starlingone.events.BoardEvent;
	import nape.space.Space;
	import nape.phys.Body;
	import nape.shape.Polygon;
	import nape.phys.BodyType;
	import nape.geom.Vec2;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	import starling.events.TouchEvent;
	import nape.phys.Material;
	import starlingone.display.Paint;
	import nape.shape.Circle;
	import starlingone.StarlingOne;
	import starling.display.Quad;

	public class NapeCase extends Board{
		private var space:Space;
		private var floorPhysicsBody:Body;
		private var p:Polygon;
		public function NapeCase(assetQuery:Array=null, _viewport:Rectangle=null) {
			// constructor code
			super(assetQuery, _viewport);
			space = new Space(new Vec2(0, 5000));
			floorPhysicsBody = new Body(BodyType.STATIC);
			trace(_viewport.height, _viewport.width);
			p = new Polygon (
				Polygon.rect(
					0, 			// x position
					_viewport.height, 	// y position
					_viewport.width, 	// width
					100			// height
				)
			);
			var _quad:Quad = new Quad(100, 100, 0x00ff00);
			addChild(_quad);
			addEventListener(BoardEvent.COMPLETED, onCompleted);
			addBackground(0xf0f0f0);
		}
		private function onCompleted(e:BoardEvent):void{
			removeEventListener(BoardEvent.COMPLETED, onCompleted);
			
			floorPhysicsBody.shapes.add(p);
			space.bodies.add(floorPhysicsBody);
			floorPhysicsBody.space = space;
			addBall();
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		private function onTouch(e:TouchEvent):void{
			var t:Touch = e.getTouch(this);
			if(t && t.phase == TouchPhase.BEGAN){
				trace("woo!");
				addBall();
			}
		}
		private function addBall():Paint{
			var paint:Paint = new Paint("ball");
			addChild(paint);
			paint.alignCenter = true;
			var ballPhysicsBody:Body = new Body(BodyType.DYNAMIC, new Vec2(100, 100));
			var material:Material = new Material(1.5);
			ballPhysicsBody.shapes.add(new Circle(paint.width / 2, null, material));
			space.bodies.add(ballPhysicsBody);
			ballPhysicsBody.userData.graphic = paint;
			return paint;
		}
		override protected function onLoop(e:EnterFrameEvent):void{
			super.onLoop(e);
			space.step(1 / StarlingOne.frameRate);
			space.liveBodies.foreach(function(b:Body):void{
				var graphic:Paint = b.userData.graphic;
				graphic.x = b.position.x;
				graphic.y = b.position.y;
				graphic.rotation = (b.rotation * 180 / Math.PI) % 360;
			});
		}
	}
}
