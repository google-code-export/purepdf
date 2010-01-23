package org.purepdf.pdf
{
	public class PdfBorderDictionary extends PdfDictionary
	{
		public static const STYLE_SOLID: int = 0;
		public static const STYLE_DASHED: int = 1;
		public static const STYLE_BEVELED: int = 2;
		public static const STYLE_INSET: int = 3;
		public static const STYLE_UNDERLINE: int = 4;
		
		public function PdfBorderDictionary($type:PdfName=null)
		{
			super($type);
		}
	}
}