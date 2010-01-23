package org.purepdf.factories
{
	import org.purepdf.Font;
	import org.purepdf.FontFactoryImp;
	import org.purepdf.colors.RGBColor;

	public final class FontFactory
	{

		private static var fontImp: FontFactoryImp = new FontFactoryImp();

		/**
		 * Constructs a Font object.
		 *
		 * @param	fontname    the name of the font
		 * @param	encoding    the encoding of the font
		 * @param   embedded    true if the font is to be embedded in the PDF
		 * @param	size
		 * @param	style
		 * @param	color	    the <CODE>RGBColor</CODE> of this font.
		 */
		static public function getFont(fontname: String, encoding: String = 'Cp1252', embedded: Boolean = false,
						size: Number = 14, style: int = -1, color: RGBColor = null): Font
		{
			return fontImp.getFont(fontname, encoding, embedded, size, style, color);
		}
	}
}