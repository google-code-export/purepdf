package org.purepdf.resources
{
	import flash.utils.ByteArray;

	public class CMap implements ICMap
	{
		[Embed(source="cmaps/Adobe-CNS1-UCS2.cmap", mimeType="application/octet-stream")] 
		public static var Adobe_CNS1_UCS2: Class;
		
		[Embed(source="cmaps/Adobe-GB1-UCS2.cmap", mimeType="application/octet-stream")] 
		public static var Adobe_GB1_UCS2: Class;
		
		[Embed(source="cmaps/Adobe-Japan1-UCS2.cmap", mimeType="application/octet-stream")] 
		public static var Adobe_Japan1_UCS2: Class;
		
		[Embed(source="cmaps/Adobe-Korea1-UCS2.cmap", mimeType="application/octet-stream")] 
		public static var Adobe_Korea1_UCS2: Class;
		
		[Embed(source="cmaps/UniCNS-UCS2-H.cmap", mimeType="application/octet-stream")] 
		public static var UniCNS_UCS2_H: Class;
		
		[Embed(source="cmaps/UniCNS-UCS2-V.cmap", mimeType="application/octet-stream")] 
		public static var UniCNS_UCS2_V: Class;
		
		[Embed(source="cmaps/UniGB-UCS2-H.cmap", mimeType="application/octet-stream")] 
		public static var UniGB_UCS2_H: Class;
		
		[Embed(source="cmaps/UniGB-UCS2-V.cmap", mimeType="application/octet-stream")] 
		public static var UniGB_UCS2_V: Class;
		
		[Embed(source="cmaps/UniJIS-UCS2-H.cmap", mimeType="application/octet-stream")] 
		public static var UniJIS_UCS2_H: Class;
		
		[Embed(source="cmaps/UniJIS-UCS2-HW-H.cmap", mimeType="application/octet-stream")] 
		public static var UniJIS_UCS2_HW_H: Class;
		
		[Embed(source="cmaps/UniJIS-UCS2-V.cmap", mimeType="application/octet-stream")] 
		public static var UniJIS_UCS2_V: Class;
		
		[Embed(source="cmaps/UniKS-UCS2-H.cmap", mimeType="application/octet-stream")] 
		public static var UniKS_UCS2_H: Class;
		
		[Embed(source="cmaps/UniKS-UCS2-V.cmap", mimeType="application/octet-stream")] 
		public static var UniKS_UCS2_V: Class;
		
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