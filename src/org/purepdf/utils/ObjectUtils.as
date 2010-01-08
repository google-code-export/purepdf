package org.purepdf.utils
{
	import flash.utils.getQualifiedClassName;

	public class ObjectUtils
	{
		public static function hashCode( clazz: Object ): int
		{
			var i: Number = new Date().getTime() + ( Math.random() * 1000 );
			var cls: String = getQualifiedClassName( clazz );
			for( var k: int = 0; k < cls.length; k++ )
			{
				i += Math.random() * cls.charCodeAt(k);
			}
			
			return i;
		}
	}
}