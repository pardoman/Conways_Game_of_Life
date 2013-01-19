package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author Federico Medina
	 */
	public class Main extends Sprite 
	{
		
		[Embed(source = "../lib/map.png")] private static const MAP_1:Class;
		[Embed(source = "../lib/map2.png")] private static const MAP_2:Class;
		[Embed(source = "../lib/map3.png")] private static const MAP_3:Class;
		[Embed(source = "../lib/map4.png")] private static const MAP_4:Class;
		[Embed(source = "../lib/map5.png")] private static const MAP_5:Class;
		[Embed(source = "../lib/map6.png")] private static const MAP_6:Class;
		
		private var m_gamesOfLife:Vector.<GameOfLife> = new Vector.<GameOfLife>;
		private var m_dragClicker:DragClicker;
		private var m_txtMessage:TextField;
		private var m_txtGameInfo:TextField;
		private var m_txtGameName:TextField;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			//Overall message
			var textFormat:TextFormat = new TextFormat("Arial", 20, 0xFFFFFF, true, null, null, null, null, TextFormatAlign.RIGHT);
			m_txtMessage = new TextField;
			m_txtMessage.width = 400;
			m_txtMessage.height = 60;
			m_txtMessage.multiline = true;
			m_txtMessage.defaultTextFormat = textFormat;
			m_txtMessage.wordWrap = true;
			m_txtMessage.selectable = false;
			m_txtMessage.x = 330;
			m_txtMessage.y = 520;
			addChild(m_txtMessage);
			m_txtMessage.text = "Conway's Game of Life\nby Federico Medina"; //http://en.wikipedia.org/wiki/Conway's_Game_of_Life
			
			//Create games
			createGameOfLife(MAP_2, "Pulsar (period 3)", 	8, 90, 50);
			createGameOfLife(MAP_1, "Still lifes & pulsars",8, 280, 50);
			createGameOfLife(MAP_3, "Gosper Glider Gun",	8, 70, 250);
			createGameOfLife(MAP_4, "Infinite Growth 1*",	4, 550, 30); 	//220
			createGameOfLife(MAP_5, "Map from the Internet",9, 480, 220); 	// 90
			createGameOfLife(MAP_6, "Infinite Growth 2*",	4,100, 440); 	//140
			
			
			//Click detector
			m_dragClicker = new DragClicker(20, onClick);
			addChild(m_dragClicker);
			
			createGameTextFields();
		}
			
		private function createGameTextFields():void
		{
			//Game ticks
			var textFormat:TextFormat = new TextFormat("Arial", 14, 0x00, true, null, null, null, null, TextFormatAlign.LEFT);
			m_txtGameInfo = new TextField;
			m_txtGameInfo.border = true;
			m_txtGameInfo.borderColor = 0x6BAE28;
			m_txtGameInfo.background = true;
			m_txtGameInfo.backgroundColor = 0xFFFFFF;
			m_txtGameInfo.width = 90;
			m_txtGameInfo.height = 18;
			m_txtGameInfo.multiline = true;
			m_txtGameInfo.defaultTextFormat = textFormat;
			m_txtGameInfo.wordWrap = true;
			m_txtGameInfo.selectable = false;
			m_txtGameInfo.visible = false;
			addChild(m_txtGameInfo);
			
			//game name
			textFormat = new TextFormat("Arial", 12, 0x00, true, null, null, null, null, TextFormatAlign.CENTER);
			m_txtGameName = new TextField;
			m_txtGameName.border = true;
			m_txtGameName.borderColor = 0x6BAE28;
			m_txtGameName.background = true;
			m_txtGameName.backgroundColor = 0xFFFFFF;
			m_txtGameName.width = 90;
			m_txtGameName.height = 18;
			m_txtGameName.multiline = true;
			m_txtGameName.defaultTextFormat = textFormat;
			m_txtGameName.wordWrap = true;
			m_txtGameName.selectable = false;
			m_txtGameName.visible = false;
			addChild(m_txtGameName);
		}
		
		private function createGameOfLife(mapClass:Class, mapName:String, scale:int, posX:int, posY:int):void
		{
			var game:GameOfLife = new GameOfLife(mapClass,scale,mapName);
			game.x = posX;
			game.y = posY;
			addChild(game);
			m_gamesOfLife.push(game);
			
			game.addEventListener(MouseEvent.MOUSE_OVER, onRolloverGame, false, 0, true);
			game.addEventListener(MouseEvent.MOUSE_OUT, onRolloutGame, false, 0, true);
		}
		
		private function onRolloverGame(e:MouseEvent):void 
		{
			m_txtGameInfo.visible = true;
			m_txtGameName.visible = true;
			
			m_txtGameInfo.x = e.currentTarget.x;
			m_txtGameInfo.y = e.currentTarget.y - m_txtGameInfo.height - 1;
			
			if (e.currentTarget is GameOfLife) 
			{
				var game:GameOfLife = e.currentTarget as GameOfLife;
				game.notifyMouseOver(true);
				
				m_txtGameInfo.text = " Tick # " + game.tickCount;
				m_txtGameName.text = game.mapName;
				m_txtGameName.width = game.width - 20;
				m_txtGameName.x = e.currentTarget.x + 6;
				m_txtGameName.y = e.currentTarget.y + e.currentTarget.height - 6;
			}
		}
		
		private function onRolloutGame(e:MouseEvent):void 
		{
			m_txtGameInfo.visible = false;
			m_txtGameName.visible = false;
			
			if (e.currentTarget is GameOfLife) {
				(e.currentTarget as GameOfLife).notifyMouseOver(false);
			}
		}
		
		private function onClick(e:MouseEvent = null):void 
		{	
			for each (var game:GameOfLife in m_gamesOfLife)
			{
				if (game.getRect(stage).containsPoint(new Point(stage.mouseX, stage.mouseY)))
				{
					game.tick();
					m_txtGameInfo.text = " Tick # " + game.tickCount;
					break;
				}
			}
		}
		
	}
	
}