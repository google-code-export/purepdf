package org.purepdf.pdf.fonts.cmaps
{
	import it.sephiroth.utils.HashMap;
	import org.purepdf.resources.ICMap;

	public class CMapResourceFactory
	{
		private var maps: HashMap;
		private static var instance: CMapResourceFactory;
		
		public function CMapResourceFactory( lock: Lock )
		{
			if ( lock == null )
				throw new Error( "Cannot instantiate a new CMapResourceFactory. Use getInstance instead" );
			
			maps = new HashMap();
		}
		
		public function registerCMap( name: String, value: ICMap ): void
		{
			maps.put( name + ".cmap", value );
		}
		
		public function getCMap( name: String ): ICMap
		{
			return maps.getValue( name ) as ICMap;
		}
		
		public static function getInstance(): CMapResourceFactory
		{
			if ( instance == null )
				instance = new CMapResourceFactory( new Lock() );
			return instance;
		}
	}
}

class Lock{}