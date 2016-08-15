package
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	public class Game
	{
		/** Determines life cell color*/
		public var lifeColor:uint=0xff0000;
	
		private var xnumRows:int=0;
		private var xnumCols:int=0;
		private var xcellDim:Number = 10;
		private var numCells:int;
		private var maxCol:int;
		private var maxRow:int;
		
		private var wid:int;
		private var hei:int;
		
		private var rects:Vector.<Vector.<Rectangle>> = new Vector.<Vector.<Rectangle>>();
		private var matrix:Vector.<Vector.<Boolean>> = new Vector.<Vector.<Boolean>>();
		
		private var intervalId:uint;
		private var xgenFrequency:Number = 1000/30;
		
		private var xview:Sprite;
		private var lifeSpace:Shape;
		
		public function Game(rows:int,cols:int)
		{
			xnumRows = rows;
			xnumCols = cols;
			super();
			build();
		}
		
		private function build():void
		{
			wid = numCols * cellDim;
			hei = numRows * cellDim;
			numCells = numRows * numCols;
			maxRow = numRows -1;
			maxCol = numCols -1;
			buildView();
			buildVectors();
		}
		
		private function buildView():void
		{
			if(view == null)
				xview = new Sprite();
			drawGrid();
			if(lifeSpace == null)
			{
				lifeSpace = new Shape();
				view.addChild(lifeSpace);
			}
		}
		
		private function buildVectors():void
		{
			rects.length = 0;
			matrix.length = 0;
			var r:int,c:int, rec:Rectangle, row:Vector.<Rectangle>, m:Vector.<Boolean>;
			for(r = 0; r < numRows; r++)
			{
				row = new Vector.<Rectangle>();
				m = new Vector.<Boolean>();
				for(c = 0; c < numCols; c++)
				{
					row[c] = new Rectangle(c * cellDim, r * cellDim, cellDim, cellDim);
					m[c] = false;
				}
				rects[r] = row;
				matrix[r] = m;
			}
		}
		
		private function drawGrid():void
		{
			var g:Graphics = view.graphics
			g.clear();
			g.lineStyle(1,0x333333,1,true,"noscale")
			var i:int, pos:Number;
			for(i=numCols;i>-1;i--)
			{
				pos = i*cellDim;
				g.moveTo(0,pos);
				g.lineTo(wid,pos);
			}
			for(i=numRows;i>-1;i--)
			{
				pos = i*cellDim;
				g.moveTo(pos,0);
				g.lineTo(pos,hei);
			}			
		}
		
		private function drawFromMatrix():void
		{
			var g:Graphics = this.lifeSpace.graphics, rec:Rectangle;
			g.clear();
			g.beginFill(lifeColor);
			
			for(var i:int = numRows; i-->0;)
			{
				for(var j:int = numCols; j-->0;)
				{
					if(!matrix[i][j]) continue;
					rec = rects[i][j];
					g.drawRect(rec.x,rec.y,rec.width,rec.height);
				}
			}
		}
		
		private function countNeighbors(r:int, c:int,minusSelf:Boolean):int
		{
			var sy:int = r > 0 ? -1 : 0;
			var ey:int = r < maxRow ? 2 : 1;
			var sx:int = c > 0 ? -1 : 0;
			var ex:int = c < maxCol ? 2 : 1;
			var n:int = 0;
			for(var i:int = sy;i < ey; i++)
				for(var j:int=sx; j < ex; j++)
					if(matrix[r + i][c + j])
						n++;
			return minusSelf ? n-1 : n;
		}
		
		/** One generation sequence. Kills and raises cells. Called automatically in interval 
		 * (determined by <code>genFrequency</code>) if <code>startWithPattern</code> or 
		 * <code>resume</code> was called. @see #genFrequency */
		public function tick():void
		{
			var alive:Boolean;	
			var nm:Vector.<Vector.<Boolean>> = new Vector.<Vector.<Boolean>>(numRows);
			for(var r:int = 0; r < numRows; r++)
			{
				var nr:Vector.<Boolean> = new Vector.<Boolean>(numCols);
				for(var c:int = 0; c < numCols; c++)
				{
					alive = matrix[r][c];
					var nn:int = countNeighbors(r,c,alive);
					nr[c] =  alive ? (nn > 1 && nn < 4) : (nn == 3) // main conditions
				}
				nm[r] =nr;
			}
			matrix = nm;
			drawFromMatrix();
		}
		
		/** Starts generations succession.\n
		 * @param pat - pattern to start with - bi-dimensional array of booleans.
		 * First dimiension - rows, second dimension - columns.*/
		public function startWithPattern(pat:Vector.<Vector.<Boolean>>):void
		{
			if(!intervalId)
				intervalId = setInterval(tick,genFrequency);
			matrix = pat;
			drawFromMatrix();
		}
		
		/** Pauses succession. */
		public function pause():void
		{
			clearInterval(intervalId);
		}
		
		/** Starts succession. */
		public function resume():void
		{
			clearInterval(intervalId);
			intervalId = setInterval(tick,xgenFrequency);
		}
		/** Determines number of rows in life-space grid. Changing this property re-builds game.
		 * Has to match patterns length. */
		public function get numRows():int {	return xnumRows }
		public function set numRows(v:int):void
		{
			xnumRows = v;
			this.build();
		}
		/** Determines number of columns in life-space grid. Changing this property re-builds game. 
		 * * Has to match patterns length.*/
		public function get numCols():int {	return xnumCols }
		public function set numCols(v:int):void
		{
			xnumCols = v;
			this.build();
		}
		/** Determines single life cell width and height (px). Changing this property re-builds game. */
		public function get cellDim():Number { return xcellDim }
		public function set cellDim(v:Number):void
		{
			xcellDim = v;
			this.build();
		}
		/** Determines how frequent (ms) generation dies/raises. Default 1000/30. */
		public function get genFrequency():Number {	return xgenFrequency }
		public function set genFrequency(v:Number):void
		{
			xgenFrequency = v;
			clearInterval(intervalId);
			intervalId = setInterval(tick,v);
		}
		/** Visual representation of life space. */
		public function get view():Sprite { return xview }
	}
}