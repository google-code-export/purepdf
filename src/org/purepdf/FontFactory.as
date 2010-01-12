package org.purepdf
{
	import org.purepdf.colors.RGBColor;
	import org.purepdf.pdf.fonts.BaseFont;

	public final class FontFactory
	{
		public static const COURIER: String = BaseFont.COURIER;
		public static const COURIER_BOLD: String = BaseFont.COURIER_BOLD;
		public static const COURIER_OBLIQUE: String = BaseFont.COURIER_OBLIQUE;
		public static const COURIER_BOLDOBLIQUE: String = BaseFont.COURIER_BOLDOBLIQUE;
		public static const HELVETICA: String = BaseFont.HELVETICA;
		public static const HELVETICA_BOLD: String = BaseFont.HELVETICA_BOLD;
		public static const HELVETICA_OBLIQUE: String = BaseFont.HELVETICA_OBLIQUE;
		public static const HELVETICA_BOLDOBLIQUE: String = BaseFont.HELVETICA_BOLDOBLIQUE;
		public static const SYMBOL: String = BaseFont.SYMBOL;
		public static const TIMES: String = "Times";
		public static const TIMES_ROMAN: String = BaseFont.TIMES_ROMAN;
		public static const TIMES_BOLD: String = BaseFont.TIMES_BOLD;
		public static const TIMES_ITALIC: String = BaseFont.TIMES_ITALIC;
		public static const TIMES_BOLDITALIC: String = BaseFont.TIMES_BOLDITALIC;
		public static const ZAPFDINGBATS: String = BaseFont.ZAPFDINGBATS;
		
		private static var fontImp: FontFactoryImp = new FontFactoryImp();
		
		public static var  defaultEncoding: String = BaseFont.WINANSI;
		public static var defaultEmbedding: Boolean = BaseFont.NOT_EMBEDDED;
		
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
		
		public static function getFont( fontname: String, encoding: String, embedded: Boolean, size: Number, style: int, color: RGBColor ): Font
		{
			return fontImp.getFont( fontname, encoding, embedded, size, style, color );
		}
	}
}