package org.purepdf.factories
{
	import org.purepdf.lang.SpecialSymbol;

	public class GreekAlphabetFactory
	{
		static public function getLowerCaseString( index: int ): String
		{
			return getStringAtIndex( index );
		}

		static public function getString( index: int, lowercase: Boolean ): String
		{
			if ( index < 1 )
				return "";
			index--;
			var bytes: int = 1;
			var start: int = 0;
			var symbols: int = 24;

			while ( index >= symbols + start )
			{
				bytes++;
				start += symbols;
				symbols *= 24;
			}
			var c: int = index - start;
			var value: Vector.<String> = new Vector.<String>( bytes, true );
			var tmp: int;

			while ( bytes > 0 )
			{
				bytes--;
				
				tmp = c % 24;
				if( tmp > 16 )
					tmp++;
				tmp += lowercase ? 945 : 913;
				value[bytes] = SpecialSymbol.getCorrespondingSymbol( tmp );				
				c /= 24;
			}
			return value.join( "" );
		}

		static public function getStringAtIndex( index: int ): String
		{
			return getString( index, true );
		}

		static public function getUpperCaseString( index: int ): String
		{
			return getStringAtIndex( index ).toUpperCase();
		}
	}
}