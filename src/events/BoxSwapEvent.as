package events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Samar
	 */
	public class BoxSwapEvent extends Event 
	{
		public static const SWAP_CARD:String = "swap_card";
		private var _box:Box;
		
		public function BoxSwapEvent(box:Box, type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			_box = box;
		} 
		
		public override function clone():Event 
		{ 
			return new BoxSwapEvent(box, type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("Box", "BoxSwapEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get box():Box 
		{
			return _box;
		}
		
	}
	
}