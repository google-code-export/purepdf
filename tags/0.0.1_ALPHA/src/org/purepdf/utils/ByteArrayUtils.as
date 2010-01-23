package org.purepdf.utils
{
	import flash.errors.EOFError;
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
		
		public static function readChar( buffer: ByteArray ): int
		{
			var ch1: int = read( buffer );
			var ch2: int = read( buffer );
			if ((ch1 | ch2) < 0)
				throw new EOFError();
			return ((ch1 << 8) + ch2);
		}
		
		protected static function read( buffer: ByteArray ): int
		{
			return buffer.readByte() & 0xFF;
		}
	}
}