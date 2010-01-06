package org.purepdf.elements
{

	public interface ILargeElement extends IElement
	{
		function set iscomplete( value: Boolean ): void;
		function get iscomplete(): Boolean;
		function flushContent(): void;
	}
}