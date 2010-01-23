package org.purepdf.io
{
	import flash.utils.ByteArray;

	public interface InputStream
	{
		function readUnsignedByte(): int;
		function readBytes( b: ByteArray, off: int, len: int ): int;
		function size(): int;
	}
}