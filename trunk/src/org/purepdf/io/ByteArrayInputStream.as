package org.purepdf.io
{
	import flash.utils.ByteArray;
	
	import org.purepdf.errors.IndexOutOfBoundsError;
	import org.purepdf.errors.NullPointerError;

	public class ByteArrayInputStream implements InputStream
	{
		protected var buf: ByteArray;
		protected var count: int;
		protected var mark: int = 0;
		protected var pos: int;

		public function ByteArrayInputStream( ins: ByteArray, offset: int = 0, lenght: int = 0 )
		{
			if ( lenght == 0 )
				lenght = ins.length;
			buf = ins;
			pos = offset;
			count = Math.min( offset + lenght, buf.length );
			mark = offset;
		}
		
		public function size(): int
		{
			return count;
		}

		public function readBytes( b: ByteArray, off: int, len: int ): int
		{
			if ( b == null )
			{
				throw new NullPointerError();
			} else if ( off < 0 || len < 0 || len > b.length - off )
			{
				throw new IndexOutOfBoundsError();
			}

			if ( pos >= count )
			{
				return -1;
			}

			if ( pos + len > count )
			{
				len = count - pos;
			}

			if ( len <= 0 )
			{
				return 0;
			}
			
			buf.position = pos;
			buf.readBytes( b, off, len );
			
			pos += len;
			return len;
		}

		public function readUnsignedByte(): int
		{
			return ( pos < count ) ? ( buf[ pos++ ] & 0xFF ) : -1;
		}

		public function skip( n: Number ): Number
		{
			if ( pos + n > count )
			{
				n = count - pos;
			}

			if ( n < 0 )
			{
				return 0;
			}
			pos += n;
			return n;
		}
	}
}