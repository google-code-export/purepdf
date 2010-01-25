package org.purepdf.pdf.fonts.cmaps
{
	import it.sephiroth.utils.HashMap;
	
	import org.purepdf.utils.IProperties;

	public class CJKFontResourceFactory
	{
		private var properties: HashMap;
		private static var instance: CJKFontResourceFactory;
		
		public function CJKFontResourceFactory( lock: Lock )
		{
			if ( lock == null )
				throw new Error( "Cannot instantiate a new CJKFontResourceFactory. Use getInstance instead" );
			
			properties = new HashMap();
		}
		
		public function registerProperty( name: String, value: IProperties ): void
		{
			properties.put( name, value );
		}
		
		public function getProperty( name: String ): IProperties
		{
			return properties.getValue( name ) as IProperties;
		}
		
		public static function getInstance(): CJKFontResourceFactory
		{
			if ( instance == null )
				instance = new CJKFontResourceFactory( new Lock() );
			return instance;
		}
	}
}

class Lock
{
}