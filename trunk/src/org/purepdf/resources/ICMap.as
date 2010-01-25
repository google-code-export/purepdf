package org.purepdf.resources
{
	import flash.utils.ByteArray;

	public interface ICMap
	{
		function load( b: ByteArray ): void;
		function get chars(): Vector.<int>;
	}
}