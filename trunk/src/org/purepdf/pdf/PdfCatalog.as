package org.purepdf.pdf
{
	
	public class PdfCatalog extends PdfDictionary
	{
		private var writer: PdfWriter;
		
		public function PdfCatalog( $pages: PdfIndirectReference, $writer: PdfWriter )
		{
			super( CATALOG );
			writer = $writer;
			put( PdfName.PAGES, $pages );
		}
		
		public function addNames( localDestinations, documentLevelJS, documentFileAttachment, writer: PdfWriter ): void 
		{
			trace('addNames. to be implemented');
		}
	}
}