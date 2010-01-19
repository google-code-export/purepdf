package org.purepdf.factories
{

	public class RomanAlphabetFactory
	{

		public static function getLowerCaseString( index: int ): String
		{
			return _getString( index );
		}

		/**
		 * Translates a positive integer (not equal to zero)
		 * into a String using the letters 'a' to 'z'
		 * (a = 1, b = 2, ..., z = 26, aa = 27, ab = 28,...).
		 */
		public static function getString( index: int, lowercase: Boolean ): String
		{
			if ( lowercase )
			{
				return getLowerCaseString( index );
			}
			else
			{
				return getUpperCaseString( index );
			}
		}

		public static function getUpperCaseString( index: int ): String
		{
			return _getString( index ).toUpperCase();
		}

		private static function _getString( index: int ): String
		{
			if ( index < 1 )
				throw new Error( "Can't translate a negative number" );

			index--;
			var bytes: int = 1;
			var start: int = 0;
			var symbols: int = 26;

			while ( index >= symbols + start )
			{
				bytes++;
				start += symbols;
				symbols *= 26;
			}

			var c: int = index - start;
			var value: Vector.<String> = new Vector.<String>( bytes, true );

			while ( bytes > 0 )
			{
				value[ --bytes ] = String.fromCharCode( 97 + ( c % 26 ) );
				c /= 26;
			}

			return value.join( "" );
		}
	}
}