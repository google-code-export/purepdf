package org.purepdf.utils
{
	import flash.utils.ByteArray;
	
	import it.sephiroth.utils.KeySet;

	public interface IProperties
	{
		function hasProperty( name: String ): Boolean;
		function getProperty( name: String ): String;
		function load( b: ByteArray ): void;
		function remove( name: String ): void;
		function get keys(): KeySet;
	}
}