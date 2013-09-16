package
{
	/**
	 * ...
	 * @author Samar
	 */
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Main extends Sprite 
	{
		public static const GAME_PAUSE:String = "game_pause";
		public static const GAME_RESUME:String = "game_resume";
		public static const GAME_START:String = "game_start";
		public static const GAME_DELAY_TIME:Number = 2000;
		public static const IS_DEBUG:Number = 0;
		private var _board:Board;
		private var _gameAutoTimer:Timer;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			_board = new Board();
			_board.x = 50;
			_board.y = 50;
			addChild(_board);
			
			_gameAutoTimer = new Timer(GAME_DELAY_TIME, 1);
			_gameAutoTimer.addEventListener(TimerEvent.TIMER, gameAutoTimerHandler);
			
			start_game.addEventListener(MouseEvent.CLICK, startGameClickHandler);
			stop_game.addEventListener(MouseEvent.CLICK, gamePauseHandler);
			start_game.buttonMode = stop_game.buttonMode = true;
			this.addEventListener(Main.GAME_PAUSE, gamePauseHandler);
			this.addEventListener(Main.GAME_RESUME, gameResumeHandler);
			
			/**
			 * My debug functions.
			 */
			match_test.addEventListener(MouseEvent.CLICK, matchTestHandler);
			auto_fill.addEventListener(MouseEvent.CLICK, autoFillHandler);
			get_moves.addEventListener(MouseEvent.CLICK, getMovesHandler);
			
		}
		
		private function gameResumeHandler(e:Event):void 
		{
			startGame();
		}
		
		private function gamePauseHandler(e:Event):void 
		{
			pauseGame();
		}
		
		private function startGameClickHandler(e:Event):void 
		{
			startGame();
		}
		
		private function gameAutoTimerHandler(e:TimerEvent):void {
			_board.dispatchEvent(new Event(Board.GET_POSSIBLE_MOVES));
		}
		
		public function pauseGame():void {
			if(_gameAutoTimer.running)
				_gameAutoTimer.stop();
		}
		
		public function startGame():void {
			if(!_gameAutoTimer.running)
				_gameAutoTimer.start();
		}
		
		/**
		 * Dispatch event get possible moves.
		 * @param	e	MouseEvent
		 */
		private function getMovesHandler(e:MouseEvent):void 
		{
			_board.dispatchEvent(new Event(Board.GET_POSSIBLE_MOVES));
		}
		
		/**
		 * Dispatch event fill blank boxes
		 * @param	e	MouseEvent
		 */
		private function autoFillHandler(e:MouseEvent):void 
		{
			_board.dispatchEvent(new Event(Board.FILL_BLANK_BOXES));
		}
		
		/**
		 * Dispatch event activate match find event.
		 * @param	e	MouseEvent
		 */
		private function matchTestHandler(e:MouseEvent):void 
		{
			_board.dispatchEvent(new Event(Board.ACTIVATE_MATCH_FIND));
		}
	}
	
}