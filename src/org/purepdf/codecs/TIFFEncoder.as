package org.purepdf.codecs
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class TIFFEncoder
	{
		public function TIFFEncoder()
		{
		}

		public static function encode( bmp: BitmapData ): ByteArray
		{
			var header: ByteArray = new ByteArray();
			var img: ByteArray = new ByteArray();
			var ifd: ByteArray = new ByteArray();
			var picture: ByteArray = new ByteArray();
			var blue: Number = 0;
			var green: Number = 0;
			var pixel: Number = 0;
			var red: Number = 0;
			header.endian = Endian.LITTLE_ENDIAN;
			header.writeByte( 73 );
			header.writeByte( 73 );
			header.writeShort( 42 );
			header.writeInt( 8 );
			ifd.endian = Endian.LITTLE_ENDIAN;
			ifd.writeShort( 12 );
			ifd.writeShort( 256 );
			ifd.writeShort( 3 );
			ifd.writeInt( 1 );
			ifd.writeInt( bmp.width );
			ifd.writeShort( 257 );
			ifd.writeShort( 3 );
			ifd.writeInt( 1 );
			ifd.writeInt( bmp.height );
			ifd.writeShort( 258 );
			ifd.writeShort( 3 );
			ifd.writeInt( 3 );
			ifd.writeInt( 158 );
			ifd.writeShort( 259 );
			ifd.writeShort( 3 );
			ifd.writeInt( 1 );
			ifd.writeInt( 1 );
			ifd.writeShort( 262 );
			ifd.writeShort( 3 );
			ifd.writeInt( 1 );
			ifd.writeInt( 2 );
			ifd.writeShort( 273 );
			ifd.writeShort( 4 );
			ifd.writeInt( 1 );
			ifd.writeInt( 180 );
			ifd.writeShort( 277 );
			ifd.writeShort( 4 );
			ifd.writeInt( 1 );
			ifd.writeInt( 3 );
			ifd.writeShort( 278 );
			ifd.writeShort( 3 );
			ifd.writeInt( 1 );
			ifd.writeInt( bmp.height );
			ifd.writeShort( 279 );
			ifd.writeShort( 4 );
			ifd.writeInt( 1 );
			ifd.writeInt( bmp.width * bmp.height * 3 );
			ifd.writeShort( 282 );
			ifd.writeShort( 5 );
			ifd.writeInt( 1 );
			ifd.writeInt( 164 );
			ifd.writeShort( 283 );
			ifd.writeShort( 5 );
			ifd.writeInt( 1 );
			ifd.writeInt( 172 );
			ifd.writeShort( 296 );
			ifd.writeShort( 3 );
			ifd.writeInt( 1 );
			ifd.writeInt( 2 );
			ifd.writeInt( 0 );
			ifd.writeShort( 8 );
			ifd.writeShort( 8 );
			ifd.writeShort( 8 );
			ifd.writeInt( 720000 );
			ifd.writeInt( 10000 );
			ifd.writeInt( 720000 );
			ifd.writeInt( 10000 );

			for ( var h: Number = 0; h < bmp.height; h++ )
			{
				for ( var w: Number = 0; w < bmp.width; w++ )
				{
					pixel = bmp.getPixel( w, h );
					red = ( pixel & 0xFF0000 ) >>> 16;
					green = ( pixel & 0x00FF00 ) >>> 8;
					blue = pixel & 0x0000FF;
					picture.writeByte( red );
					picture.writeByte( green );
					picture.writeByte( blue );
				}
			}
			img.writeBytes( header );
			img.writeBytes( ifd );
			img.writeBytes( picture );
			return img;
		}
	}
}