package org.purepdf.pdf.fonts
{
	import flash.utils.ByteArray;
	
	import it.sephiroth.utils.HashMap;
	import it.sephiroth.utils.ObjectHash;
	
	public class GlyphList extends ObjectHash
	{
		[Embed(source="names2unicode.bytearray", mimeType="application/octet-stream")]
		private static var n2u: Class;
		
		[Embed(source="unicode2names.bytearray", mimeType="application/octet-stream")]
		private static var u2n: Class;
		
		private static var _unicode2names: HashMap;
		private static var _names2unicode: HashMap;
		
		private static function init_names2unicode(): void
		{
			var byte: ByteArray = new n2u() as ByteArray;
			_names2unicode = byte.readObject();
		}
		
		private static function init_unicode2names(): void
		{
			var byte: ByteArray = new u2n() as ByteArray;
			_unicode2names = byte.readObject();
		}
		
		public static function name2unicode( name: String ): Vector.<int>
		{
			if( _names2unicode == null )
				init_names2unicode();
			
			return Vector.<int>( _names2unicode.getValue( name ) );
		}
		
		public static function unicode2name( num: int ): String
		{
			if( _unicode2names == null )
				init_unicode2names();
			
			return _unicode2names.getValue( num ) as String;
		}
		
	}
}