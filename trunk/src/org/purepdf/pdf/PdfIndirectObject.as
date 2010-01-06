package org.purepdf.pdf
{
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.purepdf.IOutputStream;
	import org.purepdf.utils.Bytes;

	public class PdfIndirectObject
	{
		protected var number: int;
		
		protected var generation: int = 0;
		
		private static const STARTOBJ: Bytes = 	PdfWriter.getISOBytes(" obj\n");
		private static const ENDOBJ: Bytes = 	PdfWriter.getISOBytes("\nendobj\n");
		private static const SIZEOBJ: int = STARTOBJ.length + ENDOBJ.length;
		
		private var object: PdfObject;
		private var writer: PdfWriter;
		
		private static var logger: ILogger = LoggerFactory.getClassLogger( PdfIndirectObject );
		
		/**
		 * Constructs a <CODE>PdfIndirectObject</CODE>.
		 *
		 * @param		number			the object number
		 * @param		generation		the generation number
		 * @param		object			the direct object
		 */
		
		function PdfIndirectObject( $number: int, $generation: int, $object: PdfObject, $writer: PdfWriter )
		{
			writer = $writer;
			number = $number;
			generation = $generation;
			object = $object;
			
			var crypto: PdfEncryption = null;
			if (writer != null)
				crypto = writer.getEncryption();
			
			if (crypto != null)
			{
				logger.warn( 'implement this' );
			}
		}
		
		public function getIndirectReference(): PdfIndirectReference
		{
			return new PdfIndirectReference( 0, number, generation );
		}
		
		/**
		 * Writes efficiently to a stream
		 */
		public function writeTo( os: IOutputStream ): void
		{
			os.writeBytes( PdfWriter.getISOBytes( number.toString() ) );
			os.writeInt( ' '.charCodeAt(0) );
			os.writeBytes( PdfWriter.getISOBytes( generation.toString() ));
			os.writeBytes( STARTOBJ );
			object.toPdf( writer, os );
			os.writeBytes( ENDOBJ );
		}
	}
}