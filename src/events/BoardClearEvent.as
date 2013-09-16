package events 
{
	/**
	 * ...
	 * @author Samar
	 */
	import flash.events.Event;
	
	public class BoardClearEvent extends Event 
	{
		public static const CLEAR_CARD:String = "board_clear_card";
		private var _boxes:Array;
		
		public function BoardClearEvent(boxesArr:Array, type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			_boxes = boxesArr;
		} 
		
		public override function clone():Event 
		{ 
			return new BoardClearEvent(boxes, type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("Array", "BoardClearEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get boxes():Array 
		{
			return _boxes;
		}
		
	}
	
}