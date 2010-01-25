package org.purepdf.pdf.fonts.cmaps
{
	import flash.utils.ByteArray;

	public class CMap implements ICMap
	{
		[Embed(source="UniGB-UCS2-H.cmap", mimeType="application/octet-stream")] public static var Uni_GBUCS2_H: Class;
		
		private var _chars: Vector.<int>
		
		public function CMap( bytes: ByteArray )
		{
			load( bytes );
		}
		
		public function get chars(): Vector.<int>
		{
			return _chars;
		}
		
		public function load( b: ByteArray ): void
		{
			_chars = new Vector.<int>( 0x10000, true );
			for( var k: int = 0; k < 0x10000; ++k )
				_chars[k] = ( ( b.readUnsignedByte() << 8) + b.readUnsignedByte() );
		}
	}
}