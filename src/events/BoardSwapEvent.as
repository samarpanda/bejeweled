package events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Samar
	 */
	public class BoardSwapEvent extends Event 
	{
		public static const CARD_SWAP:String = "card_swap";
		
		
		public function BoardSwapEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new BoardSwapEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("BoardSwapEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}