package org.purepdf.elements
{

	public interface IElement
	{
		function getChunks(): Array;
		function isNestable(): Boolean;
		function get iscontent(): Boolean;
		function toString(): String;
		function type(): int;
	}
}