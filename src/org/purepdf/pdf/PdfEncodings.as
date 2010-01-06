package org.purepdf.pdf
{
	import flash.errors.IOError;
	
	import org.purepdf.utils.Bytes;

	public class PdfEncodings
	{
		private static var _pdfEncoding: Object;
		
		private static const pdfEncodingByteToChar: Vector.<int> = Vector.<int>( [
			0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 
			16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 
			32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 
			48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 
			64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 
			80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 
			96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 
			112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 
			0x2022, 0x2020, 0x2021, 0x2026, 0x2014, 0x2013, 0x0192, 0x2044, 0x2039, 0x203a, 0x2212, 0x2030, 0x201e, 0x201c, 0x201d, 0x2018,
			0x2019, 0x201a, 0x2122, 0xfb01, 0xfb02, 0x0141, 0x0152, 0x0160, 0x0178, 0x017d, 0x0131, 0x0142, 0x0153, 0x0161, 0x017e, 65533,
			0x20ac, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 
			176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 
			192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 
			208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 
			224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 
			240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255 ] );
		
		private static function init(): void
		{
			_pdfEncoding = new Object();
			for( var k: int = 128; k < 161; ++k )
			{
				var c: int = pdfEncodingByteToChar[k];
				if( c != 65533 )
					_pdfEncoding[c] = k;
			}
		}
		
		public static function get pdfEncoding(): Object
		{
			if( _pdfEncoding == null )
				init();
			return _pdfEncoding;
		}
		
		public static function convertToBytes( text: String, encoding: String ): Bytes
		{
			var byte: Bytes;
			var len: int;
			var k: int;
			
			if( text == null )
			{
				byte = new Bytes();
				return byte;
			}
			
			if( encoding == null || encoding.length == 0 ){
				len = text.length;
				var b: Bytes = new Bytes();
				for( k = 0; k < len; ++k )
					b[k] = ByteBuffer.intToByte( text.charCodeAt(k) );
				return b;
			}
			
			
			var hash: Object;
			if( encoding == PdfObject.TEXT_PDFDOCENCODING )
				hash = pdfEncoding;
			
			if( hash != null )
			{
				byte = new Bytes();
				len = text.length;
				var ptr: int = 0;
				var c: int = 0;
				var code: Number;
				
				for( k = 0; k < len; ++k )
				{
					code = ByteBuffer.intToByte( text.charCodeAt( k ) );
					if( code < 128 || ( code > 160 && code <= 255 ) )
						c = code;
					else
						c = hash[code];
					if( c != 0 )
					{
						byte[ptr++] = c;
					}
				}
				
				if( ptr == len )
					return byte;
				
				var b2: Bytes = new Bytes();
				b2.writeBytes( byte, 0, ptr );
				return b2;
			}
			return byte;
		}
		
		public static function convertToString( bytes: Bytes, encoding: String ): String
		{
			if( bytes == null )
				return PdfObject.NOTHING;
			
			if( encoding == null || encoding.length == 0 )
			{
				var c: String = "";
				for( var k: int = 0; k < bytes.length; k++ )
				{
					var byte: int = bytes[k];
					c += String.fromCharCode( byte & 0xff );
				}
				return c;
			}
			
			throw new IOError("Invalid encoding");
			return null;
		}
		
		public static function isPdfDocEncoding( text: String ): Boolean
		{
			if( text == null )
				return true;
			
			var len: int = text.length;
			for( var k: int = 0; k < len; k++ )
			{
				var char1: String = text.charAt( k );
				var code1: Number = char1.charCodeAt( 0 );
				
				if( code1 < 128 || ( code1 > 160 && code1 <= 255 ) )
					continue;
				
				if( !pdfEncoding[code1] )
					return false;
			}
			return true;
		}
	}
}