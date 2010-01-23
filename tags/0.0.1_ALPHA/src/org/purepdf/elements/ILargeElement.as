package org.purepdf.elements
{

	public interface ILargeElement extends IElement
	{
		function flushContent(): void;
		function get complete(): Boolean;
		function set complete( value: Boolean ): void;
	}
}