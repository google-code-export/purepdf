package org.purepdf.pdf
{
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.pdf.interfaces.IPdfOCG;

	public class PdfTemplate extends PdfContentByte
	{
		public static const TYPE_TEMPLATE: int = 1;
		public static const TYPE_IMPORTED: int = 2;
		public static const TYPE_PATTERN: int = 3;
		
		protected var type: int;
		protected var thisReference: PdfIndirectReference;
		protected var pageResources: PageResources;
		protected var bBox: RectangleElement = new RectangleElement( 0, 0, 0, 0 );
		protected var matrix: PdfArray;
		protected var group: PdfTransparencyGroup;
		protected var layer: IPdfOCG;
		
		public function PdfTemplate()
		{
			super( null );
			type = TYPE_TEMPLATE;
		}
		
		public function get width(): Number
		{
			return bBox.getWidth();
		}
		
		public function get height(): Number
		{
			return bBox.getHeight();
		}
	}
}