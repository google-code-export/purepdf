package org.purepdf.elements
{

	public interface IElement
	{
		function getChunks(): Vector.<Object>;
		function get isNestable(): Boolean;
		function get isContent(): Boolean;
		function toString(): String;
		function type(): int;
	}
}