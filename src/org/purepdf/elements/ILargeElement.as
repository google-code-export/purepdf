package org.purepdf.elements
{

	public interface ILargeElement extends IElement
	{
		function flushContent(): void;
		function get iscomplete(): Boolean;
		function set iscomplete( value: Boolean ): void;
	}
}