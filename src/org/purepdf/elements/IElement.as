package org.purepdf.elements
{

	public interface IElement
	{
		function process( listener: IElementListener ): Boolean;
		function getChunks(): Vector.<Object>;
		function get isNestable(): Boolean;
		function get isContent(): Boolean;
		function toString(): String;
		function get type(): int;
	}
}