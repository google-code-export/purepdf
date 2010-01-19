package org.purepdf.lang
{
	public class Character
	{
		public static const MIN_CODE_POINT: int		= 0;
		public static const FAST_PATH_MAX: int		= 255;
		public static const LOWERCASE_LETTER: int	= 2;
		
		/**
		 * Determines if the specified character is white space
		 * 
		 */
		public static function isWhitespace( code: int ): Boolean 
		{
			var ws: Boolean = false;
			if( code >= MIN_CODE_POINT && code <= FAST_PATH_MAX ) 
			{
				ws =  CharacterDataLatin1.isWhitespace( code );
			} else
			{
				return false;	// not yet implemented
			}
			return ws;
		}
	}
}