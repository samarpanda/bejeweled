package  
{
	/**
	 * ...
	 * @author Samar
	 */
	import events.BoardClearEvent;
	import events.BoxGravityEvent;
	import events.BoxSwapEvent;
	import events.CardEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Box extends Sprite
	{
		public static const FIRST_ROW_ADD_CARD:String = "first_row_add_card";
		public static const MIN_SAME_CARDS:Number = 2;
		private var _rowIndex:Number = 0;
		private var _colIndex:Number = 0;
		private var _card:Card;
		private var _key:uint;
		// Temp
		private var _contArr:Array;
		
		/**
		 * Constructor function.
		 * @param	rowIndex 	Number	row Index
		 * @param	colIndex	Number 	Column Index
		 * @param	arr			Array	card content array
		 */
		public function Box(rowIndex:Number, colIndex:Number, arr:Array) 
		{
			this._rowIndex = rowIndex;
			this._colIndex = colIndex;
			this._contArr = arr;
			init();
		}
		
		/**
		 * Init function.
		 */
		private function init():void {
			_card = new Card();
			addChild(_card);
			var id:Number = getInitialRandomCardId(MIN_SAME_CARDS);
			_card.dispatchEvent(new CardEvent(id, CardEvent.CARD_CHANGE));
			
			this.addEventListener(BoxGravityEvent.CONTENT_PUSH_DOWN, cardPushDownHandler);
			this.addEventListener(Box.FIRST_ROW_ADD_CARD, firstRowAddCardHandler);
			this.addEventListener(BoxSwapEvent.SWAP_CARD, swapCardHandler);
			this.addEventListener(MouseEvent.CLICK, changeToWildCardHandler);
		}
		/**
		 * Change to wild card.
		 * @param	e
		 */
		private function changeToWildCardHandler(e:MouseEvent):void 
		{
			if(Board(parent).wcards > 0){
				_card.dispatchEvent(new CardEvent(Card.GS_WILD, CardEvent.CARD_CHANGE));
				parent.dispatchEvent(new Event(Board.USED_WILD_CARD));
			}
		}
		
		/**
		 * Listen to BoardClearEvent and clear card on satistying few conditions.
		 * @param	e	BoardClearEvent
		 */
		private function clearCardHandler(e:BoardClearEvent):void 
		{
			var arr:Array = e.boxes as Array;
			if (arr.indexOf(_rowIndex + "$" + _colIndex) > -1 ) {
				//trace("Clear this box .... ", _rowIndex + "$" + _colIndex);
				_card.dispatchEvent(new CardEvent(Card.GS_CLEAR, CardEvent.CARD_CHANGE));
			}
		}
		
		/**
		 * Handy to swap card between boxes via Custom event.
		 * @param	e	BoxSwapEvent
		 */
		private function swapCardHandler(e:BoxSwapEvent):void {
			var box1:Box = this;
			var box2:Box = e.box as Box;
			var newCard1:Number = box2.key;
			var newCard2:Number = box1.key;
			box1.card.dispatchEvent(new CardEvent(newCard1, CardEvent.CARD_CHANGE));
			box2.card.dispatchEvent(new CardEvent(newCard2, CardEvent.CARD_CHANGE));
			/**
			 * Remove matching elements
			 */
			//parent.dispatchEvent(new Event(Board.ACTIVATE_MATCH_FIND));
			Helper.addDelay(function() {
				parent.dispatchEvent(new Event(Board.ACTIVATE_MATCH_FIND));
			});
		}
		
		/**
		 * Add cards to first row when its empty
		 * @param	e Event
		 */
		private function firstRowAddCardHandler(e:Event):void 
		{
			if (this.key == Card.GS_CLEAR) {
				var id;
				/**
				 * Random cards
				 */
				id = getRandomCardId();
				
				/**
				 * Player friendly random cards.
				 */
				//id = getInitialRandomCardId(MIN_SAME_CARDS);
				_card.dispatchEvent(new CardEvent(id, CardEvent.CARD_CHANGE));
			}
		}
		
		/**
		 * Push card down when column below is blank. Kind of Gravity effect.
		 * @param	e BoxGravityEvent Custom event.
		 */
		private function cardPushDownHandler(e:BoxGravityEvent):void 
		{
			var lowerBox:Box = e.lowerBox as Box;
			var box:Box = this;
			var id:Number;
			if (box.key != Card.GS_CLEAR && lowerBox.key == Card.GS_CLEAR) {
				lowerBox.card.dispatchEvent(new CardEvent(this.key, CardEvent.CARD_CHANGE));
				box.card.dispatchEvent(new CardEvent(Card.GS_CLEAR, CardEvent.CARD_CHANGE));
			}
		}
		
		/**
		 * Helper to select card fot initial placements. More player friendly and no matched selection.
		 * @param	min Number - Max similar adjacent cards allowed.
		 * @return	id  Number - Refers which card to show i.e cardId.
		 */
		private function getInitialRandomCardId(min:Number):Number {
			var id:Number;
			do{
				id = getRandomCardId();
			} while (rowV(id) > min || columnV(id) > min)
			return id;
		}
		
		/**
		 * Get Random CardId.
		 * @return id Number
		 */
		private function getRandomCardId():Number {
			var id:Number = Card.GS_RANDOM_OPTIONS[Math.floor(Math.random() * Card.GS_RANDOM_OPTIONS.length)];
			return id;
		}
		
		/**
		 * 
		 * @param	id	:uint CardId
		 * @return	i	:uint Count of adjacent cards in a row with respect to a Card.
		 */
		private function rowV(id:uint):uint {
			var i:uint = 1;
			var j:int = _colIndex;
			while (check(id, _rowIndex, j-1)) {
				j--;
				i++;
			}
			j = _colIndex;
			while (check(id, _rowIndex, j+1)) {
				j++;
				i++;
			}
			return i;
		}
		
		/**
		 * 
		 * @param	id	:uint CardId i.e cardValue
		 * @return	i	:uint Count of adjacent cards in a column with respect to a Card.
		 */
		private function columnV(id:uint):uint {
			var i:uint = 1;
			var j:int = _rowIndex;
			while (check(id, j-1, _colIndex)) {
				j--;
				i++;
			}
			j = _rowIndex;
			while (check(id, j+1, _colIndex)) {
				j++;
				i++;
			}
			return i;
		}
		
		/**
		 * Match to Cards
		 * @param	id	uint CardId
		 * @param	r	int	 Row Number
		 * @param	c	int  Column Number
		 * @return	Boolean True/False
		 */
		private function check(id:uint, r:int, c:int):Boolean {
			if (this._contArr[r] == null) {
				return false;
			}
			if (this._contArr[r][c] == null) {
				return false;
			}
			var box:Box = this._contArr[r][c];
			if (!box)
				return false;
			if (id == Card.GS_CLEAR || box.key == Card.GS_CLEAR)
				return false;
			if (box.key == Card.GS_WILD)
				return true;
			return id == box.key;
		}
		
		/**
		 * Box key as per cardId.
		 */
		public function get key():uint 
		{
			return this._card.id;
		}
		
		/**
		 * Get Card associated to a box.
		 */
		public function get card():Card 
		{
			return _card;
		}
		
		/**
		 * Get row index associate to a box.
		 * @return	Number	row index of box.
		 */
		public function get rowIndex():Number 
		{
			return _rowIndex;
		}
		
		/**
		 * Get column index associated to a box.
		 * @return	Number	Column index of box
		 */
		public function get colIndex():Number 
		{
			return _colIndex;
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			//trace("RowIndex: ", this._rowIndex, " ColIndex: ",this._colIndex, " Arr : ",Board(parent).contArr );
			this.card.dispatchEvent(new CardEvent(Card.GS_CLEAR, CardEvent.CARD_CHANGE));
		}
	}

}