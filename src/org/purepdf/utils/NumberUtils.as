package org.purepdf.utils
{
	import flash.utils.getQualifiedClassName;

	public class NumberUtils
	{
		public static function is_int( value: * ): Boolean
		{
			var cls: String = getQualifiedClassName( value );
			return cls == "int";
		}
		
		public static function is_number( value: * ): Boolean
		{
			var cls: String = getQualifiedClassName( value );
			return cls == "Number";
		}
	}
}