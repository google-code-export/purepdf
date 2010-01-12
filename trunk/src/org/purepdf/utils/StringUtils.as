package org.purepdf.utils
{
	public class StringUtils
	{
		private static const EMPTY_CHAR: Vector.<int> = Vector.<int>([ 9, 32, 10, 13 ]);
		
		public static function padLeft( p_string: String, p_padChar: String, p_length: uint ): String
		{
			var s: String = p_string;
			if( p_string.length < p_length )
			{
				while(s.length < p_length) 
					s = p_padChar + s; 
			}
			return s;
		}
		
		public static function startsWith( src: String, value: String ): Boolean
		{
			return src.indexOf( value ) == 0;
		}
		
		public static function endsWith( src: String, value: String ): Boolean
		{
			var index: int = src.lastIndexOf( value );
			if( index > -1 )
				return (index + value.length) == src.length;
			return false;
		}
		
		public static function left_trim( value: String ): String
		{
			if( EMPTY_CHAR.indexOf( value.charCodeAt(0) ) > -1 )
				value = left_trim( value.substr( 1 ) );
			
			return value;
		}
		
		public static function right_trim( value: String ): String
		{
			if( EMPTY_CHAR.indexOf( value.charCodeAt( value.length - 1 ) ) > -1 )
				value = left_trim( value.substr( 0, value.length - 1 ) );
		
			return value;
		}
		
		public static function trim( value: String ): String
		{
			return right_trim( left_trim( value ) );
		}
	}
}