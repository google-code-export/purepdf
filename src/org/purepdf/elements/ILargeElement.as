package org.purepdf.elements
{

	public interface ILargeElement extends IElement
	{
		function flushContent(): void;
		function get isComplete(): Boolean;
		function set isComplete( value: Boolean ): void;
	}
}