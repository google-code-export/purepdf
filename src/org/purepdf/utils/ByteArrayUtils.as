package org.purepdf.utils
{
	import flash.utils.ByteArray;

	public class ByteArrayUtils
	{
		/**
		 * clone a bytearray and return a new one
		 * 
		 */
		public static function clone( buffer: ByteArray, off: int = 0, len: int = 0 ): ByteArray
		{
			if( len == 0 ) len = buffer.length;
			
			var b: ByteArray = new ByteArray();
			b.writeBytes( buffer, off, len );
			return b;
		}
		
		public static function toVector( buffer: ByteArray ): Vector.<int>
		{
			var b: Bytes = new Bytes();
			b.buffer = buffer;
			return b.toVector();
		}
	}
}