package  
{
	/**
	 * ...
	 * @author Samar
	 */
	import events.BoxGravityEvent;
	import events.BoxSwapEvent;
	import events.CardEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	public class Board extends Sprite {
		
		public static const ACTIVATE_MATCH_FIND:String = "activate_match_find";
		public static const FILL_BLANK_BOXES:String = "fill_in_blank_boxes";
		public static const GET_POSSIBLE_MOVES:String = "get_possible_moves";
		public static const USED_WILD_CARD:String = "used_wild_card";
		private static const COLS:Number = 5;
		private static const ROWS:Number = 5;
		private var _contArr:Array = new Array();
		private var _wcards:Number = 3;
		
		public function Board() {
			init();
		}
		
		private function init():void {
			this.create();
			this.addEventListener(Board.FILL_BLANK_BOXES, fillBlankBoxesHandler);
			this.addEventListener(Board.ACTIVATE_MATCH_FIND, matchedCardHandler);
			this.addEventListener(Board.GET_POSSIBLE_MOVES, getPossibleMovesHandler);
			this.addEventListener(Board.USED_WILD_CARD, updateWildCardUsage);
		}
		
		private function updateWildCardUsage(e:Event):void 
		{
			_wcards--;
		}
		
		/**
		 * Game AI: Get possible moves 
		 * @param	e	Event
		 */
		private function getPossibleMovesHandler(e:Event):void 
		{
			parent.dispatchEvent(new Event(Main.GAME_PAUSE));
			var box1:Box;
			var box2:Box;
			var gotIt:Boolean = false;
			for (var i:uint = 0; i < ROWS; i++ ) {
				for (var j:uint = 0; j < COLS; j++ ) {
					if (i < ROWS-1) {
						swapBox(i,j,i+1,j);
						if (rowV(i, j) > 2 || columnV(i, j) > 2 || rowV(i + 1, j) > 2 || columnV(i + 1, j) > 2 ) {
							if(Main.IS_DEBUG)
								trace("ROWS: ", i, ",", j, " <- Move to -> ", i + 1, ", ", j);
							box1 = _contArr[i][j] as Box;
							box2 = _contArr[i + 1][j] as Box;
							gotIt = true;
						}
						swapBox(i, j, i + 1, j);
						if (gotIt)
							break;
					}
					if (j < COLS-1) {
						swapBox(i,j,i,j+1);
						if (rowV(i, j) > 2 || columnV(i, j) > 2 || rowV(i, j + 1) > 2 || columnV(i, j + 1) > 2 ) {
							if(Main.IS_DEBUG)
								trace("COLS: ", i, ",", j, " <- Move to -> ", i, ", ", j + 1);
							box1 = _contArr[i][j] as Box;
							box2 = _contArr[i][j + 1] as Box;
							gotIt = true;
						}
						swapBox(i,j,i,j+1);
						if (gotIt)
							break;
					}
				}
				if (gotIt)
					break;
			}
			box1.dispatchEvent(new BoxSwapEvent(box2, BoxSwapEvent.SWAP_CARD));
		}
		
		/**
		 * Swaping box 
		 * @param	r1	uint	Box1 row
		 * @param	c1	uint	Box1 column
		 * @param	r2	uint	Box2 row
		 * @param	c2	uint	Box2 column
		 */
		private function swapBox(r1:uint, c1:uint, r2:uint, c2:uint):void {
			var box:Box = _contArr[r1][c1];
			_contArr[r1][c1] = _contArr[r2][c2];
			_contArr[r2][c2] = box;
		}
		
		/**
		 * Listner to fill in blank boxes with card with Gravity effect.
		 * @param	e
		 */
		private function fillBlankBoxesHandler(e:Event):void 
		{
			var box:Box;
			var lowerBox:Box;
			var count:Number = 0;
			while(count < ROWS){
				for (var i:int = ROWS-1; i >= 0; i-- ) {
					for (var j:uint = 0; j < COLS; j++ ) {
						box = _contArr[i][j];
						// Push card down
						if (i <= ROWS-2) {
							lowerBox = _contArr[i + 1][j];
							box.dispatchEvent(new BoxGravityEvent(lowerBox, BoxGravityEvent.CONTENT_PUSH_DOWN));
						}
						// Create new cards for top row
						if (i == 0) {
							box.dispatchEvent(new Event(Box.FIRST_ROW_ADD_CARD));
						}
					}
				}
				count++;
			}
		}
		
		/**
		 * Clear cards on match found.
		 * @param	e
		 */
		private function matchedCardHandler(e:Event):void {
			var startTime:int = getTimer();
			var count = 0;
			var isRemoved:Boolean = true;
			while (isRemoved) {
				isRemoved = removeMatchedCards();
				if (isRemoved)
					this.dispatchEvent(new Event(Board.FILL_BLANK_BOXES));
				else
					break;
				count++;
			}
			if(Main.IS_DEBUG)
				trace("Count >> ", count," >> ", getTimer() - startTime);
			parent.dispatchEvent(new Event(Main.GAME_RESUME));
		}
		
		private function removeMatchedCards():Boolean {
			var box:Box;
			var lowerBox:Box;
			var i:int;
			var j:uint;
			var r:Boolean = false;
			var isRemoved:Boolean = false;
			var t:Number;
			var clearCardArr:Array;
			var startTime:int = getTimer();
			for (i = ROWS-1; i >= 0; i-- ) {
				for (j = 0; j < COLS; j++ ) {
					if (rowV(i, j) > 2 || columnV(i, j) > 2) {
						box = _contArr[i][j];
						clearCardArr = new Array(box);
						r = true;
						if (rowV(i, j) > 2) {
							t = j;
							while (check(box.key, i, t-1)) {
								t--;
								clearCardArr.push(_contArr[i][t]);
							}
							t = j;
							while (check(box.key, i, t+1)) {
								t++;
								clearCardArr.push(_contArr[i][t]);
							}
						}
						if (columnV(i,j) > 2) {
							t = i;
							while (check(box.key, t-1, j)) {
								t--;
								clearCardArr.push(_contArr[t][j]);
							}
							t = i;
							while (check(box.key, t+1, j)) {
								t++;
								clearCardArr.push(_contArr[t][j]);
							}
						}
						var toRemove:Number = clearCardArr.length;
						if( toRemove > 2){
							for (i = 0; i < toRemove; i++ ) {
								//Check value of jewel.
								//trace(Box(clearCardArr[i]).key);
								Box(clearCardArr[i]).card.dispatchEvent(new CardEvent(Card.GS_CLEAR, CardEvent.CARD_CHANGE));
							}
							isRemoved = true;
						}
						//trace(clearCardArr);
						break;
					}
					else
						clearCardArr = null;
				}
				if (r)
					break;
			}
			//trace("count >> ", clearCardArr);
			return isRemoved;
		}
		
		/**
		 * Generate boxes for Board.
		 */
		private function create():void {
			var box:Box;
			for (var i:Number = 0; i < ROWS; i++ ) {
				this._contArr[i] = [];
				for (var j:Number = 0; j < COLS; j++ ) {
					box = new Box(i, j, this._contArr);
					box.x = j * box.width;
					box.y = i * box.height;
					this._contArr[i][j] = box;
					addChild(box);
				}
			}
		}
		
		/**
		 * 
		 * @param	r
		 * @param	c
		 * @return	uint	Match count in row
		 */
		private function rowV(r:uint, c:uint):uint {
			var count:uint = 1;
			var t:int = c;
			var box:Box = this._contArr[r][c];
			var u:uint = box.key;
			while (check(u, r, t-1)) {
				t--;
				count++;
			}
			t = c;
			while (check(u, r, t+1)) {
				t++;
				count++;
			}
			return count;
		}
		
		/**
		 * 
		 * @param	r
		 * @param	c
		 * @return	uint	Match count in column
		 */
		private function columnV(r:uint, c:uint):uint {
			var count:uint = 1;
			var i:int = r;
			var box:Box = this._contArr[r][c];
			var u:uint = box.key;
			while (check(u, i-1, c)) {
				i--;
				count++;
			}
			i = r;
			while (check(u, i+1, c)) {
				i++;
				count++;
			}
			return count;
		}
		
		/**
		 * Validate matching of card among boxes.
		 * @param	g
		 * @param	r
		 * @param	c
		 * @return	Boolean true/false
		 */
		private function check(g:uint, r:int, c:int):Boolean {
			if (this._contArr[r] == null) {
				return false;
			}
			if (this._contArr[r][c] == null) {
				return false;
			}
			var box:Box = this._contArr[r][c];
			if (!box)
				return false;
			if (g == Card.GS_CLEAR || box.key == Card.GS_CLEAR)
				return false;
			if (box.key == Card.GS_WILD)
				return true;
			return g == box.key;
		}
		
		public function get contArr():Array 
		{
			return _contArr;
		}
		
		public function get wcards():Number 
		{
			return _wcards;
		}
	}
}