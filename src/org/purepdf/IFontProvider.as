package org.purepdf
{
	import org.purepdf.colors.RGBColor;

	public interface IFontProvider
	{
		function isRegistered( fontname: String ): Boolean;
		function getFont( fontname: String, encoding: String, embedded: Boolean, size: Number, style: int, color: RGBColor ): Font;
	}
}