package org.purepdf.pdf
{
	public class PdfBorderDictionary extends PdfDictionary
	{
		public static const STYLE_SOLID: int = 0;
		public static const STYLE_DASHED: int = 1;
		public static const STYLE_BEVELED: int = 2;
		public static const STYLE_INSET: int = 3;
		public static const STYLE_UNDERLINE: int = 4;
		
		/**
		 * 
		 * @throws ArgumentError if an invalid border style is passed
		 */
		public function PdfBorderDictionary( borderWidth: Number, borderStyle: int , dashes: PdfDashPattern )
		{
			put( PdfName.W, new PdfNumber( borderWidth ) );
			switch (borderStyle) 
			{
				case STYLE_SOLID:
					put(PdfName.S, PdfName.S);
					break;
				case STYLE_DASHED:
					if (dashes != null)
						put(PdfName.D, dashes);
					put(PdfName.S, PdfName.D);
					break;
				case STYLE_BEVELED:
					put(PdfName.S, PdfName.B);
					break;
				case STYLE_INSET:
					put(PdfName.S, PdfName.I);
					break;
				case STYLE_UNDERLINE:
					put(PdfName.S, PdfName.U);
					break;
				default:
					throw new ArgumentError("invalid border style");
			}
		}
	}
}