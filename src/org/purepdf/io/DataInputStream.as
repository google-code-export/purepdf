package org.purepdf.io
{
	import flash.errors.EOFError;
	import flash.utils.ByteArray;
	import org.purepdf.errors.IndexOutOfBoundsError;
	import org.purepdf.utils.Bytes;

	public class DataInputStream extends FilterInputStream
	{
		private var bytearr: Bytes = new Bytes();
		private var chararr: Vector.<String> = new Vector.<String>( 80 );

		public function DataInputStream( stream: InputStream )
		{
			super( stream );
			bytearr.length = 80;
		}

		public function readFully( b: ByteArray, off: int, len: int ): void
		{
			if ( len < 0 )
				throw new IndexOutOfBoundsError();
			
			input.readBytes( b, off, len );
		}

		override public function readUnsignedByte(): int
		{
			return input.readUnsignedByte();
		}
	}
}