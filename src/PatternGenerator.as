package
{
	
	public class PatternGenerator
	{
		private static const tumblerPattern:Array = 
			[	[0,1,1,0,1,1,0],
				[0,1,1,0,1,1,0],
				[0,0,1,0,1,0,0],
				[1,0,1,0,1,0,1],
				[1,0,1,0,1,0,1],
				[1,1,0,0,0,1,1]
			];
		private static const queenPattern:Array = 
			[	[1,1,0,0],
				[0,0,1,0],
				[0,0,0,1],
				[0,0,0,1],
				[0,0,0,1],
				[0,0,1,0],
				[1,1,0,0]
			];
		
		private var types:Array = [random,queenBeeShuttle,tumbler];
		private var typeIndex:int = -1;
		
		private var numCells:int;
		private var xmatrix:Vector.<Vector.<Boolean>>;
		
		public var numRows:int;
		public var numCols:int;
		
		public function PatternGenerator(rows:int,cols:int)
		{
			numRows = rows;
			numCols = cols;
		}
		
		private function patternToMatrix(patt:Array):Vector.<Vector.<Boolean>>
		{
			var ph:int = patt.length;
			var pw:int = patt[0].length;
			var hoffset:int = (numCols-pw)/2;
			var voffset:int = (numRows-ph)/2;
			var matrix:Vector.<Vector.<Boolean>> = getFreshMatrix();
			for(var r:int = 0; r < ph; r++)
				for(var c:int = 0; c < pw; c++)
					if(patt[r][c])
						matrix[voffset + r][hoffset + c] = true;
			return matrix;
		}
		
		private function getFreshMatrix():Vector.<Vector.<Boolean>>
		{
			if(xmatrix == null)
				xmatrix = new Vector.<Vector.<Boolean>>(numRows);
			for(var i:int = 0; i < numRows; i++)
				xmatrix[i] = new Vector.<Boolean>(numCols);
			return xmatrix;
		}
		
		public function random():Vector.<Vector.<Boolean>>
		{
			numCells = numRows * numCols;
			var numLive:int = int(numCells/2);
			var liver:Vector.<int> = new Vector.<int>();
			var randomIds:Vector.<int> = new Vector.<int>();
			var matrix:Vector.<Vector.<Boolean>> = getFreshMatrix();
			
			// generate list of numbers from 0 - num cells
			for(var i:int = 0; i < numCells; i++)
				liver[i] = i;
			
			// getting random elements from the list so we have unique cell id's
			for(i = 0; i < numLive; i++)
				randomIds[i] = liver.splice(Math.floor(Math.random() * liver.length),1).pop();
			
			//from uniqe cell id's we deduct it's coordinates and sign it as busy in matrix
			for(i = 0; i < numLive; i++)
			{
				var id:int = randomIds[i];
				var r:int = id % numRows;
				var c:int = Math.floor(id/numCols);
				matrix[r][c] = true;
			}
			return matrix;
		}
		
		public function queenBeeShuttle():Vector.<Vector.<Boolean>>
		{
			return patternToMatrix(queenPattern);
		}
		
		public function tumbler():Vector.<Vector.<Boolean>>
		{	
			return patternToMatrix(tumblerPattern);
		}
		
		public function nextPattern():Vector.<Vector.<Boolean>>
		{
			return types[++typeIndex % types.length]();
		}
	}
}