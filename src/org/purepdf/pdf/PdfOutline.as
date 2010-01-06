package org.purepdf.pdf
{
	import org.purepdf.colors.RGBColor;

	public class PdfOutline extends PdfDictionary
	{
		private var reference: PdfIndirectReference;
		private var count: int = 0;
		private var parent: PdfOutline;
		private var kids: Array = new Array();
		private var tag: String;
		private var open: Boolean;
		private var color: RGBColor;
		private var style: int = 0;
		
		protected var writer: PdfWriter;
		
		public function PdfOutline( $writer: PdfWriter )
		{
			super( OUTLINES );
			open = true;
			parent = null;
			writer = $writer;
		}
	}
}