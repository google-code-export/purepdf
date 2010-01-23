package org.purepdf.pdf
{
	import it.sephiroth.utils.ObjectHash;
	
	public class PdfTextArray extends ObjectHash
	{
		protected var list: Vector.<Object> = new Vector.<Object>();
		private var lastStr: String = null;
		private var lastNum: Number = Number.NaN;
		
		public function PdfTextArray( str: String = null )
		{
			super();
			
			if( str && str.length > 0 )
				addString( str );
		}
		
		public function get arrayList(): Vector.<Object>
		{
			return list;
		}
		
		private function replaceLast( obj: Object ): void
		{
			list[ list.length - 1 ] = obj;
		}
		
		/**
		 * Add a string to the array
		 */
		public function addString( str: String ): void
		{
			if( str.length > 0 )
			{
				if( lastStr != null )
				{
					lastStr = lastStr + str;
					replaceLast( lastStr );
				} else 
				{
					lastStr = str;
					list.push( lastStr );
				}
				lastNum = Number.NaN;
			}
		}
		
		/**
		 * Adds a Number to the PdfArray
		 * @param number
		 */
		public function addNumber( number: Number ): void
		{
			if( number != 0 )
			{
				if( !isNaN( lastNum ) )
				{
					lastNum = number + lastNum;
					if( lastNum != 0) {
						replaceLast( lastNum );
					} else 
					{
						list.splice( list.length - 1, 1 );
					}
				} else 
				{
					lastNum = number;
					list.push( lastNum );
				}
				lastStr = null;
			}
		}
		
		
		
	}
}