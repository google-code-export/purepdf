package org.purepdf.utils
{
	import flash.utils.ByteArray;
	
	import it.sephiroth.utils.HashMap;
	import it.sephiroth.utils.KeySet;
	
	import org.purepdf.io.LineReader;

	public class Properties implements IProperties
	{
		private var map: HashMap;

		public function Properties()
		{
			map = new HashMap();
		}

		public function getProperty( name: String ): String
		{
			return map.getValue( name ) as String;
		}
		
		public function hasProperty( name: String ): Boolean
		{
			return map.containsKey( name );
		}

		public function get keys(): KeySet
		{
			return map.keySet();
		}

		public function load( b: ByteArray ): void
		{
			var lr: LineReader = new LineReader( b );
			var line: String;
			var tok: StringTokenizer;

			while ( ( line = lr.readLine() ) != null )
			{
				tok = new StringTokenizer( line, /=/g );

				if ( tok.hasMoreTokens() )
				{
					var key: String = tok.nextToken();
					var value: String = tok.nextToken();
					if( value && value.length > 0 )
						map.put( key, value );
				}
			}
		}

		public function remove( name: String ): void
		{
			map.remove( name );
		}
	}
}