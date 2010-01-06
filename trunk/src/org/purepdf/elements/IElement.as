package org.purepdf.elements
{
	public interface IElement
	{
		function type(): int;
		
		function get iscontent(): Boolean;
		
		function isNestable(): Boolean;
		
		function getChunks(): Array;
		
		function toString(): String;
	}
}