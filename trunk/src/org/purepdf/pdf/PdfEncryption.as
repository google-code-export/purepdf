package org.purepdf.pdf
{
	import com.adobe.crypto.MD5;
	
	import flash.system.System;
	
	import org.purepdf.ObjectHash;
	import org.purepdf.utils.Bytes;

	public class PdfEncryption extends ObjectHash
	{
		private static var seq: Number = new Date().getTime();
		
		public function PdfEncryption()
		{
		}
		
		public static function createInfoId( id: Bytes ): PdfObject
		{
			var buf: ByteBuffer = new ByteBuffer();
			var k: int;
			
			buf.append_char('[').append_char('<');
			
			for( k = 0; k < 16; ++k )
				buf.appendHex( id[k] );
			
			buf.append_char('>').append_char('<');
			id = createDocumentId();
			
			for( k = 0; k < 16; ++k )
				buf.appendHex( id[k] );
			
			buf.append_char('>').append_char(']');
			
			return new PdfLiteral( buf.toString() );
		}
		
		public static function createDocumentId(): Bytes
		{
			var time: Number = new Date().getTime();
			var mem: Number = System.totalMemory;
			var s: String = time + "+" + mem + (seq++);
			return PdfWriter.getISOBytes( MD5.hash( s ) );
		}
	}
}