package org.purepdf.pdf
{
	import flash.utils.ByteArray;
	
	import org.purepdf.IOutputStream;
	import org.purepdf.utils.Bytes;
	
	public class OutputStreamCounter implements IOutputStream
	{
		protected var out: ByteArray;
		protected var counter: int = 0;
		protected var str: String;
		
		public function OutputStreamCounter( $out: ByteArray )
		{
			out = $out;
			str = "";
		}
		
		public function getCounter(): int
		{
			return counter;
		}
		
		public function resetCounter(): void
		{
			counter = 0;
		}
		
		public function getInternalBuffer(): ByteArray
		{
			return out;
		}
		
		public function writeByteArray( value: ByteArray, off: int = 0, len: int = 0 ): void
		{
			if( value == null ) 
				throw new Error('NullPointerException');
			
			if( len == 0 ) len = value.length;
			
			if( (off < 0) || (off > value.length) || (len < 0) || ((off + len) > value.length) || ((off + len) < 0) )
				throw new Error('IndexOutOfBoundsException');
			else if( len == 0 )
				return;
			
			counter += len;
			out.writeBytes( value, off, len );
			
			value.position = off;
			while( value.position < (off+len) )
			{
				str += String.fromCharCode( uint(value.readByte()) );
			}
		}
		
		public function toString(): String
		{
			return str;
		}
		
		public function toBytes(): Bytes
		{
			var b: Bytes = new Bytes();
			b.buffer.writeBytes( this.out );
			return b;
		}
		
		public function writeBytes( value: Bytes, off: int = 0, len: int = 0 ): void
		{
			writeByteArray( value.buffer, off, len );
		}
		
		public function writeInt( value: int ): void
		{
			++counter;
			out[out.position++] = value;
			str += String.fromCharCode( value );
		}
		
	}
}