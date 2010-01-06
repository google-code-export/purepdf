package org.purepdf
{
	import flash.utils.ByteArray;
	
	import org.purepdf.utils.Bytes;

	public interface IOutputStream
	{
		function writeBytes( value: Bytes, off: int = 0, len: int = 0 ): void;
		function writeByteArray( value: ByteArray, off: int = 0, len: int = 0 ): void;
		function writeInt( value: int ): void;
	}
}