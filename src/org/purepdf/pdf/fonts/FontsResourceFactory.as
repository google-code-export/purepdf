package org.purepdf.pdf.fonts
{
	import flash.utils.ByteArray;
	
	import it.sephiroth.utils.HashMap;

	public class FontsResourceFactory
	{
		[Embed(source="Helvetica.afm", mimeType="application/octet-stream")]
		private var helvetica_afm: Class;
		
		private static var instance: FontsResourceFactory;
		private var fontsMap: HashMap;
		
		public function FontsResourceFactory( lock: Lock )
		{
			if( lock == null )
				throw new Error("Cannot instantiate a new FontsResourceFactory. Use getInstance instead");
			
			fontsMap = new HashMap();
			fontsMap.put( BaseFont.HELVETICA + ".afm", helvetica_afm );			
		}
		
		public static function getInstance(): FontsResourceFactory
		{
			if( instance == null )
				instance = new FontsResourceFactory( new Lock() );
			return instance;
		}
		
		public function getFontFile( filename: String ): ByteArray
		{
			if( fontsMap.containsKey( filename ) )
				return new (fontsMap.getValue( filename ))();
			return null;
		}
	}
}

class Lock{}