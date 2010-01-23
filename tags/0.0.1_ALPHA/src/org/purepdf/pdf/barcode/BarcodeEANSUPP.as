package org.purepdf.pdf.barcode
{
	import org.purepdf.colors.RGBColor;
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.pdf.PdfContentByte;
	import org.purepdf.pdf.fonts.BaseFont;

	public class BarcodeEANSUPP extends Barcode
	{
		protected var ean: Barcode;
		protected var supp: Barcode;
		
		public function BarcodeEANSUPP( $ean: Barcode, $supp: Barcode )
		{
			super();
			n = 8;
			ean = $ean;
			supp = $supp;
		}
		
		override public function getBarcodeSize(): RectangleElement
		{
			var rect: RectangleElement = ean.getBarcodeSize();
			rect.setRight( rect.width + supp.getBarcodeSize().width + n );
			return rect;
		}
		
		override public function placeBarcode(cb:PdfContentByte, barColor:RGBColor, textColor:RGBColor):RectangleElement
		{
			if( supp.font != null)
				supp.barHeight = ean.barHeight + supp.baseline - supp.font.getFontDescriptor(BaseFont.CAPHEIGHT, supp.size);
			else
				supp.barHeight = ean.barHeight;
			
			var eanR: RectangleElement = ean.getBarcodeSize();
			cb.saveState();
			ean.placeBarcode(cb, barColor, textColor);
			cb.restoreState();
			cb.saveState();
			cb.concatCTM( 1, 0, 0, 1, eanR.width + n, eanR.height - ean.barHeight );
			supp.placeBarcode(cb, barColor, textColor);
			cb.restoreState();
			return getBarcodeSize();
		}
	}
}