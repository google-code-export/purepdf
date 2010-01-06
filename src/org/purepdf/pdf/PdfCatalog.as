package org.purepdf.pdf
{
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	
	public class PdfCatalog extends PdfDictionary
	{
		private var writer: PdfWriter;
		private static var logger: ILogger = LoggerFactory.getClassLogger( PdfCatalog );
		
		public function PdfCatalog( $pages: PdfIndirectReference, $writer: PdfWriter )
		{
			super( CATALOG );
			writer = $writer;
			put( PdfName.PAGES, $pages );
		}
		
		public function addNames( localDestinations, documentLevelJS, documentFileAttachment, writer: PdfWriter ): void 
		{
			logger.warn('addNames. to be implemented');
		}
	}
}