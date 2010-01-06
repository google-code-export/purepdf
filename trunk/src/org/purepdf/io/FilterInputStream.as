package org.purepdf.io
{
	import flash.utils.ByteArray;
	
	import org.purepdf.errors.NonImplementatioError;

	public class FilterInputStream implements InputStream
	{
		protected var input: InputStream;
		
		public function FilterInputStream( stream: InputStream )
		{
			input = stream;
		}
		
		public function getBuffer(): InputStream
		{
			return input;
		}
		
		public function size(): int
		{
			return input.size();
		}
		
		public function readUnsignedByte(): int
		{
			return input.readUnsignedByte();
		}
		
		public function readBytes( b: ByteArray, off: int, len: int ): int
		{
			throw new NonImplementatioError();
		}
	}
}