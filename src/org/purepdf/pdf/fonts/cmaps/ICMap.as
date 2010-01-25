package org.purepdf.pdf.fonts.cmaps
{
	import flash.utils.ByteArray;

	public interface ICMap
	{
		function load( b: ByteArray ): void;
		function get chars(): Vector.<int>;
	}
}