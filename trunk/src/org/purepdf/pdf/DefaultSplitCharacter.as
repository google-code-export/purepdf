package org.purepdf.pdf
{
	import org.purepdf.ISplitCharacter;
	
	public class DefaultSplitCharacter implements ISplitCharacter
	{
		public static const DEFAULT: ISplitCharacter = new DefaultSplitCharacter();
		
		public function DefaultSplitCharacter()
		{
		}
		
		public function isSplitCharacter( start: int, current: int, end: int, cc: Vector.<int>, ck: Vector.<PdfChunk> ): Boolean
		{
			var c: int = getCurrentCharacter( current, cc, ck );
			if (c <= ' '.charCodeAt(0) || c == '-'.charCodeAt(0) || c == 8208 /*'\u2010'*/ )
				return true;
			
			if( c < 0x2002 )
				return false;
			
			return ((c >= 0x2002 && c <= 0x200b)
				|| (c >= 0x2e80 && c < 0xd7a0)
				|| (c >= 0xf900 && c < 0xfb00)
				|| (c >= 0xfe30 && c < 0xfe50)
				|| (c >= 0xff61 && c < 0xffa0));
		}
		
		/**
		 * Returns the current character
		 * @param current current position in the array
		 * @param	cc		the character array that has to be checked
		 * @param ck chunk array
		 * @return	the current character
		 */
		protected function getCurrentCharacter( current: int, cc: Vector.<int>, ck: Vector.<PdfChunk> ): int
		{
			if( ck == null ) 
				return cc[current];
			
			return ck[ Math.min(current, ck.length - 1) ].getUnicodeEquivalent( cc[current] );
		}
	}
}