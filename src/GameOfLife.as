package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	[SWF(width="500", height="500", frameRate="30")]
	
	public class GameOfLife extends Sprite
	{
		private var game:Game;
		private var pattern:PatternGenerator;
		private var numRows:int = 50;
		private var numCells:int = 50;
		private var isBuilt:Boolean;
		
		public function GameOfLife()
		{
			stage ? ats() : this.addEventListener(Event.ADDED_TO_STAGE,ats);
		}
		
		protected function ats(e:Event=null):void
		{
			stage.scaleMode = "noScale";
			stage.align = "TL";
			if(!isBuilt)
				build();
		}
		
		protected function onKeyDown(e:KeyboardEvent):void
		{
			if(e.keyCode == 13)
				game.startWithPattern(pattern.nextPattern());
		}
		
		private function build():void
		{
			game = new Game(numRows,numCells);
			addChild(game.view);
			
			pattern = new PatternGenerator(numRows,numCells);
			isBuilt = true;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
	}
}