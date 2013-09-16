package events 
{
	/**
	 * ...
	 * @author Samar
	 */
	import flash.events.Event;
	
	public class BoxGravityEvent extends Event 
	{
		public static const CONTENT_PUSH_DOWN:String = "content_push_down";
		private var _lowerBox:Box;
		
		public function BoxGravityEvent(lowerBox:Box, type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			_lowerBox = lowerBox;
		} 
		
		public override function clone():Event 
		{ 
			return new BoxGravityEvent(lowerBox, type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("Box", "BoxGravityEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get lowerBox():Box 
		{
			return _lowerBox;
		}
		
	}
	
}