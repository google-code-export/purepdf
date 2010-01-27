package org.purepdf.utils
{
	import cmodule.alchemy_utils.CLibInit;

	public class AlchemyUtils
	{
		private static var loader: CLibInit;
		private static var lib: Object;
		
		public static function getLib(): Object
		{
			if( lib == null )
			{
				loader = new CLibInit();
				lib = loader.init();
			}
			
			return lib;
		}
	}
}