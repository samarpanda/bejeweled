package  
{
	/**
	 * ...
	 * @author Samar
	 */
	import events.CardEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Card extends MovieClip
	{
		public static const GS_WILD:Number = 4;
		public static const GS_CLEAR:Number = 5;
		public static const GS_RANDOM_OPTIONS:Array = [1, 2, 3];
		
		private var _id:Number;
		
		/**
		 * Constructor function
		 */
		public function Card() {
			init();
		}
		
		/**
		 * Add Listener to CardEvent.CARD_CHANGE event and clear card.
		 */
		private function init() {
			addEventListener(CardEvent.CARD_CHANGE, cardChangeHandler);
		}
		
		/**
		 * Listen to CardEvent.CARD_CHANGE event and clear card.
		 * @param	e	CardEvent
		 */
		private function cardChangeHandler(e:CardEvent):void 
		{
			this._id = e.itemId;
			this.gotoAndStop(this._id);
		}
		
		/**
		 * Set cardId and update card picture accordingly.
		 * @param	id
		 */
		private function setId(id:Number):void {
			this._id = id;
			this.gotoAndStop(id);
		}
		
		/**
		 * Get Card id
		 * @return Number
		 */
		public function get id():Number 
		{
			return this._id;
		}
	}

}