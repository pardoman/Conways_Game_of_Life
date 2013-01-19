package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Federico Medina
	 */
	public class DragClicker extends Sprite 
	{
		private var m_drag:Boolean = false;
		private var m_center:Point = new Point;
		private var m_distance:Number;
		private var m_callback:Function;
		
		public function DragClicker(distance:Number, callback:Function) 
		{
			m_distance = distance;
			m_callback = callback;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			m_drag = true;
			m_callback.call();
			m_center.x = stage.mouseX;
			m_center.y = stage.mouseY;
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			m_drag = false;
			m_center.x = stage.mouseX;
			m_center.y = stage.mouseY;
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{
			if (m_drag == false)
				return;
			
			var dist:Number = Point.distance(m_center, new Point(stage.mouseX, stage.mouseY));
			
			if (dist > m_distance) {
				m_callback.call();
				m_center.x = stage.mouseX;
				m_center.y = stage.mouseY;
			}
		}
	}

}