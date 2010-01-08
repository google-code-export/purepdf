package org.purepdf.pdf
{
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.purepdf.ObjectHash;
	import org.purepdf.utils.Bytes;

	public class PdfVersion extends ObjectHash
	{
		protected const header_version: String = PdfWriter.VERSION_1_4;
		private static var logger: ILogger = LoggerFactory.getClassLogger( PdfVersion );
		
		public static const HEADER: Vector.<Bytes> = Vector.<Bytes>([
			PdfWriter.getISOBytes( "\n" ),
			PdfWriter.getISOBytes( "%PDF-" ),
			PdfWriter.getISOBytes( "\n%\u00e2\u00e3\u00cf\u00d3\n" )
		]);
		
		public function writeHeader( os: OutputStreamCounter ): void
		{
			os.writeBytes( HEADER[1], 0, HEADER[1].length );
			os.writeBytes( getVersionAsByteArray( header_version ) );
			os.writeBytes( HEADER[2], 0, HEADER[2].length );
		}
		
		public function addToCatalog( catalog: PdfDictionary ): void
		{
			logger.warn('addToCatalog. to be implemented');
		}
		
		public function getVersionAsByteArray( version: String ): Bytes
		{
			return PdfWriter.getISOBytes( getVersionAsName( version ).toString().substring( 1 ) );
		}
		
		public function getVersionAsName( version: String ): PdfName
		{
			switch( version )
			{
				case PdfWriter.VERSION_1_4:
					return PdfWriter.PDF_VERSION_1_4;
					
				default:
					return PdfWriter.PDF_VERSION_1_4;
			}
		}
	}
}