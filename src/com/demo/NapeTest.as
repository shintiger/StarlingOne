package com.demo {
	import starling.display.Sprite;
	import starlingone.display.Inheritor;
	import starling.events.Event;
	import nape.space.Space;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Circle;
	import starlingone.StarlingOne;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starlingone.display.Paint;
	import nape.geom.Vec2;
	import nape.phys.Material;
	import starling.events.EnterFrameEvent;
	import starling.display.Quad;
	import nape.shape.Polygon;

	public class NapeTest extends Inheritor{
		private var space:Space;
		private var floorPhysicsBody:Body;
		public function NapeTest() {
			// constructor code
			super();
			space = new Space(new Vec2(0, 5000));
			floorPhysicsBody = new Body(BodyType.STATIC);
			var p1:Polygon = new Polygon (
				Polygon.rect(
					0, 			// x position
					StarlingOne.displayHeight, 	// y position
					StarlingOne.displayWidth, 	// width
					200			// height
				)
			);
			var p2:Polygon = new Polygon (
				Polygon.rect(
					-100, 			// x position
					0, 	// y position
					100, 	// width
					StarlingOne.displayHeight			// height
				)
			);
			var p3:Polygon = new Polygon (
				Polygon.rect(
					StarlingOne.displayWidth, 			// x position
					0, 	// y position
					100, 	// width
					StarlingOne.displayHeight			// height
				)
			);
			floorPhysicsBody.shapes.add(p1);
			floorPhysicsBody.shapes.add(p2);
			floorPhysicsBody.shapes.add(p3);
			floorPhysicsBody.rotation=1;
			space.bodies.add(floorPhysicsBody);
			//floorPhysicsBody.space = space;
			
			var _quad:Quad = new Quad(100, 100, 0x00ff00);
			addChild(_quad);
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEFF);
		}
		private function onAdded(e:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			addEventListener(TouchEvent.TOUCH, onTouch);
			addBall();
		}
		private function onTouch(e:TouchEvent):void{
			var t:Touch = e.getTouch(this);
			if(t && t.phase == TouchPhase.BEGAN){
				addBall(t.globalX, t.globalY);
			}
		}
		public function addBall(xx:Number=100,yy:Number=100):Paint{
			var paint:Paint = new Paint("ball");
			addChild(paint);
			paint.alignCenter = true;
			var ballPhysicsBody:Body = new Body(BodyType.DYNAMIC, new Vec2(xx, yy));
			var material:Material = new Material(1.75);
			ballPhysicsBody.shapes.add(new Circle(paint.width >> 1, null, material));
			//ballPhysicsBody.space = space;
			space.bodies.add(ballPhysicsBody);
			ballPhysicsBody.userData.graphic = paint;
			return paint;
		}
		private function onEFF(e:EnterFrameEvent):void{
			space.step(1 / StarlingOne.frameRate);
			space.liveBodies.foreach(function(b:Body):void{
				var graphic:Paint = b.userData.graphic;
				graphic.x = b.position.x;
				graphic.y = b.position.y;
				graphic.rotation = b.rotation;
			});
		}
	}
}