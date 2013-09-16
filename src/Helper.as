package  
{
	/**
	 * ...
	 * @author Samar
	 */
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class Helper 
	{
		
		public function Helper() {}
		
		public static function addDelay(func:*):void {
			var timer:Timer = new Timer(1000, 1);
			timer.addEventListener(TimerEvent.TIMER, func);
			timer.start();
		}
	}

}