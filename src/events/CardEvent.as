package events 
{
	/**
	 * ...
	 * @author Samar
	 */
	import flash.events.Event;

	public class CardEvent extends Event 
	{
		public static const CARD_CHANGE:String = "card_change";
		private var _itemId:Number;
		
		public function CardEvent(itemId:Number, type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			this._itemId = itemId;
		}
		
		public override function clone():Event 
		{ 
			return new CardEvent(itemId, type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("CardTypeId", "CardEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get itemId():Number 
		{
			return _itemId;
		}
		
	}
	
}