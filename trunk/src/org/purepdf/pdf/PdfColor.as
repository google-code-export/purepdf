package org.purepdf.pdf
{
	import org.purepdf.colors.RGBColor;

	public class PdfColor extends PdfArray
	{
		public function PdfColor( red: int, green: int, blue: int )
		{
			super( new PdfNumber((red & 0xFF) / 0xFF) );
			add( new PdfNumber((green & 0xFF) / 0xFF) );
			add( new PdfNumber((blue & 0xFF) / 0xFF) );
		}
		
		public static function create( color: RGBColor ): PdfColor
		{
			return new PdfColor( color.red, color.green, color.blue );
		}
	}
}