package org.purepdf.utils
{
	public class Utilities
	{
		public static function isSurrogateHigh( c: int ): Boolean
		{
			return c >= 55296 /*'\ud800'*/ && c <= 56319 /*'\udbff'*/;
		}
		
		public static function isSurrogateLow( c: int ): Boolean
		{
			return c >= 56320 /*'\udc00'*/ && c <= 57343 /*'\udfff'*/;
		}
	
		public static function isSurrogatePair( text: Vector.<int>, idx: int ): Boolean
		{
			if( idx < 0 || idx > text.length - 2 )
				return false;
			return isSurrogateHigh(text[idx]) && isSurrogateLow(text[idx + 1]);	
		}
		
		public static function isSurrogatePair2( text: String, idx: int ): Boolean
		{
			if (idx < 0 || idx > text.length - 2)
				return false;
			return isSurrogateHigh( text.charCodeAt(idx)) && isSurrogateLow( text.charCodeAt(idx + 1) );
		}
		
		public static function convertToUtf32( highSurrogate: int, lowSurrogate: int ): int
		{
			return (((highSurrogate - 0xd800) * 0x400) + (lowSurrogate - 0xdc00)) + 0x10000;
		}
		
		public static function convertToUtf32_2( text: String, idx: int ): int
		{
			return (((text.charCodeAt(idx) - 0xd800) * 0x400) + (text.charCodeAt(idx + 1) - 0xdc00)) + 0x10000;
		}
		
		public static function convertToUtf32_3( text: Vector.<int>, idx: int ): int
		{
			return (((text[idx] - 0xd800) * 0x400) + (text[idx + 1] - 0xdc00)) + 0x10000;
		}
		
		public static function addToArray( original: Vector.<Vector.<Object>>, item: Vector.<Object> ): Vector.<Vector.<Object>>
		{
			if( original == null )
			{
				original = new Vector.<Vector.<Object>>(1);
				original[0] = item;
				return original;
			} else 
			{
				var original2: Vector.<Vector.<Object>> = original.concat();
				original2.push( item );
				return original2;
			}
		}

	}
}