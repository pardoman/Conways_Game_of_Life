package  
{
	import adobe.utils.ProductManager;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Federico Medina
	 */
	public class GameOfLife extends Sprite
	{	
		private var m_bitmap:Bitmap;
		private var m_currentBD:BitmapData;
		private var m_nextBD:BitmapData;
		
		private var m_width:int;
		private var m_height:int;
		private var m_scale:Number;
		
		private var m_neighbours:Vector.<Point> = new Vector.<Point>;
		private var m_tickCount:int;
		private var m_mapName:String;
		private var m_container:Sprite = new Sprite;
		private var m_sprBorder:Sprite = new Sprite;
		
		public function get tickCount():int 
		{
			return m_tickCount;
		}
		
		public function get mapName():String 
		{
			return m_mapName;
		}
		
		public function GameOfLife(mapClass:Class, scale:int, mapName:String) 
		{
			addChild(m_container); //Contains all sizeable elements.
			m_scale = scale;
			m_mapName = mapName;
			m_container.scaleX = m_scale;
			m_container.scaleY = m_scale;
			
			var bitmap:Bitmap = new mapClass as Bitmap;
			m_width = bitmap.bitmapData.width;
			m_height = bitmap.bitmapData.height;
			
			m_currentBD = new BitmapData(m_width, m_height, false, 0xFFFFFF);
			m_currentBD.copyPixels(bitmap.bitmapData, bitmap.bitmapData.rect, new Point());
			m_nextBD = new BitmapData(m_width, m_height, false, 0xFFFFFF);
			
			m_bitmap = new Bitmap;
			m_bitmap.bitmapData = m_currentBD;
			m_container.addChild(m_bitmap);
			
			//Deltas for neighbours
			m_neighbours.push(new Point( -1, -1));
			m_neighbours.push(new Point( 0, -1));
			m_neighbours.push(new Point( 1, -1));
			m_neighbours.push(new Point( -1, 0));
			m_neighbours.push(new Point( 1, 0));
			m_neighbours.push(new Point( -1, 1));
			m_neighbours.push(new Point( 0, 1));
			m_neighbours.push(new Point( 1, 1));
			
			//Border
			addChild(m_sprBorder);
			redrawBorder(false);
		}
		
		private function redrawBorder(isOver:Boolean):void
		{
			m_sprBorder.graphics.clear();
			if (isOver) {
				m_sprBorder.graphics.lineStyle(5, 0x6BAE28);
			} else {
				m_sprBorder.graphics.lineStyle(1, 0xFF0000);
			}
			//m_sprBorder.graphics.drawRect( -1, -1, m_width * m_scale, height * m_scale);
			m_sprBorder.graphics.drawRect(-1, -1, width, height+2);
		}
		
		public function tick():void
		{
			m_tickCount++;
			m_nextBD.fillRect(m_nextBD.rect, 0xFFFFFF);
					
			for (var y:int = 1; y <= m_height; y++)
			{
				for (var x:int = 1; x <= m_width; x++)
				{
					var count:int = getNeighourCellCount(m_currentBD, x, y);
					
					if (isAlive(m_currentBD,x,y))
					{
						//Any live cell with fewer than two live neighbours dies, as if caused by under-population.
						//Any live cell with more than three live neighbours dies, as if by overcrowding.
						if (count < 2 || count > 3) {
							setDead(m_nextBD, x, y);
						}
						//Any live cell with two or three live neighbours lives on to the next generation.
						else 
						{
							setAlive(m_nextBD, x, y);
						}
					}
					else
					{
						//Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
						if (count == 3) {
							setAlive(m_nextBD, x, y);
						}
						
					}
				}
			}
			
			m_currentBD.copyPixels(m_nextBD, m_nextBD.rect, new Point);
			m_bitmap.bitmapData = m_currentBD;
		}
		
		private function isAlive(map:BitmapData, x:int, y:int):Boolean
		{
			var cell:uint = map.getPixel(x, y);
			return cell == 0x0;
		}
		
		private function setDead(map:BitmapData, x:int, y:int):void
		{
			map.setPixel(x,y,0xFFFFFF);
		}
		
		private function setAlive(map:BitmapData, x:int, y:int):void
		{
			map.setPixel(x,y,0x0);
		}
		
		private function getNeighourCellCount(map:BitmapData, x:int, y:int):int
		{
			var count:int = 0;
			
			for each (var p:Point in m_neighbours)
			{
				var xx:int = x + p.x;
				var yy:int = y + p.y;
				
				if (xx < 1 || xx >= m_width) continue;
				if (yy < 1 || yy >= m_height) continue;
				
				if (isAlive(map,xx,yy)) {
					count++;
				}
			}
			
			return count;
		}
		
		public function notifyMouseOver(isOver:Boolean):void
		{
			redrawBorder(isOver);
		}
		
	}
	
	

}