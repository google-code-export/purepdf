package org.purepdf.pdf
{
	import flash.utils.ByteArray;
	
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.purepdf.IOutputStream;
	import org.purepdf.errors.NonImplementatioError;
	import org.purepdf.utils.Bytes;
	
	
	public class PdfStream extends PdfDictionary
	{
		public static const NO_COMPRESSION: int = 0;
		public static const BEST_COMPRESSION: int = 9;
		
		protected static const STARTSTREAM: Bytes = PdfWriter.getISOBytes("stream\n");
		protected static const ENDSTREAM: Bytes = 	PdfWriter.getISOBytes("\nendstream");
		protected static const SIZESTREAM: int = STARTSTREAM.length + ENDSTREAM.length;
		
		protected var compressed: Boolean = false;
		protected var compressionLevel: int = NO_COMPRESSION;
		protected var streamBytes: ByteArray = null;
		protected var inputStream: ByteArray;
		protected var ref: PdfIndirectReference;
		protected var inputStreamLength: int = -1;
		protected var writer: PdfWriter;
		protected var rawLength: int;
		
		private static var logger: ILogger = LoggerFactory.getClassLogger( PdfStream );
		
		public function PdfStream( $byte: Bytes = null )
		{
			super();
			type = STREAM;
			
			if( $byte != null )
			{
				bytes = $byte;
				rawLength = bytes.length;
				put( PdfName.LENGTH, new PdfNumber( bytes.length ) );
			}
		}
		
		public function flateCompress( compressionLevel: int ): void
		{
			if( !PdfDocument.compress )
				return;
			
			if( compressed )
				return;
			
			throw new NonImplementatioError();
		}
		
		override public function toPdf( writer: PdfWriter, os: IOutputStream ): void
		{
			if( inputStream != null && compressed )
				put( PdfName.FILTER, PdfName.FLATEDECODE );
			
			var crypto: PdfEncryption = null;
			if( writer != null )
				crypto = writer.getEncryption();
			
			if( crypto != null )
			{
				logger.warn('toPdf. crypto != null, implement this');
			}
			
			var nn: PdfObject = getValue( PdfName.LENGTH );
			if( crypto != null && nn != null && nn.isNumber() )
			{
				
			} else
			{
				superToPdf( writer, os );
			}
			
			os.writeBytes( STARTSTREAM, 0, STARTSTREAM.length );
			
			if( inputStream != null )
			{
				rawLength = 0;
				var fout: IOutputStream = os;
				var counter: int = 0;
				
				var buf: Bytes = new Bytes();
				while( true )
				{
					inputStream.readBytes( buf.buffer, 0, 4192 );
	
					if( buf.length <= 0 )
					{
						break;
					}
					
					fout.writeBytes( buf, 0, buf.length );
					counter += buf.length;
					rawLength += buf.length;
				}
				
				inputStreamLength = counter;
			} else
			{
				logger.warn('toPdf. inputStream implement this');
				
				if( streamBytes != null )
					os.writeByteArray( streamBytes );
				else
					os.writeBytes( bytes, 0, bytes.length );
			}
			
			os.writeBytes( ENDSTREAM, 0, ENDSTREAM.length );
		}
		
		public function getRawLength(): int
		{
			return rawLength;
		}
		
		protected function superToPdf( writer: PdfWriter, os: IOutputStream ): void
		{
			super.toPdf( writer, os );
		}
		
		override public function toString(): String
		{
			if( getValue( PdfName.TYPE ) == null )
				return "stream";
			return "Stream of type: " + getValue( PdfName.TYPE );
		}
	}
}