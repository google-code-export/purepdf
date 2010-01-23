package org.purepdf.pdf
{
	import flash.utils.ByteArray;
	
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.errors.BadPdfFormatError;

	public class PdfContents extends PdfStream
	{
		protected static const SAVESTATE: ByteArray = 	PdfWriter.getISOBytes("q\n").buffer;
		protected static const RESTORESTATE: ByteArray= PdfWriter.getISOBytes("Q\n").buffer;
		protected static const ROTATE90: ByteArray = 	PdfWriter.getISOBytes("0 1 -1 0 ").buffer;
		protected static const ROTATE180: ByteArray = 	PdfWriter.getISOBytes("-1 0 0 -1 ").buffer;
		protected static const ROTATE270: ByteArray = 	PdfWriter.getISOBytes("0 -1 1 0 ").buffer;
		protected static const ROTATEFINAL: ByteArray = PdfWriter.getISOBytes(" cm\n").buffer;
		
		public function PdfContents( under: PdfContentByte, content: PdfContentByte, text: PdfContentByte, secondContent: PdfContentByte, page: RectangleElement )
		{
			super();
			
			try
			{
				var out: ByteArray = null;
				streamBytes = new ByteArray();
				
				out = streamBytes;
				var rotation: int = page.rotation;
				switch( rotation )
				{
					case 90:
						out.writeBytes( ROTATE90 );
						out.writeBytes( PdfWriter.getISOBytes( ByteBuffer.formatDouble( page.getTop() ) ).buffer );
						out.writeInt( ' '.charCodeAt(0) );
						out.writeInt( '0'.charCodeAt(0) );
						out.writeBytes( ROTATEFINAL );
						break;
					
					case 180:
						out.writeBytes( ROTATE180 );
						out.writeBytes( PdfWriter.getISOBytes( ByteBuffer.formatDouble( page.getRight() ) ).buffer );
						out.writeInt( ' '.charCodeAt(0) );
						out.writeBytes( PdfWriter.getISOBytes( ByteBuffer.formatDouble( page.getTop() ) ).buffer );
						out.writeBytes( ROTATEFINAL );
						break;
					
					case 270:
						out.writeBytes( ROTATE270 );
						out.writeByte( '0'.charCodeAt(0) );
						out.writeByte( ' '.charCodeAt(0) );
						out.writeBytes( PdfWriter.getISOBytes( ByteBuffer.formatDouble(page.getRight()) ).buffer );
						out.writeBytes( ROTATEFINAL );
						break;
				}
				
				if( under.size > 0 ){
					out.writeBytes( SAVESTATE );
					under.getInternalBuffer().writeTo( out );
					out.writeBytes( RESTORESTATE );
				}
				
				if( content.size > 0 ){
					out.writeBytes( SAVESTATE );
					content.getInternalBuffer().writeTo( out );
					out.writeBytes( RESTORESTATE );
				}
				
				if( text != null ){
					out.writeBytes( SAVESTATE );
					text.getInternalBuffer().writeTo( out );
					out.writeBytes( RESTORESTATE );
				}
				
				if( secondContent.size > 0 ){
					secondContent.getInternalBuffer().writeTo( out );
				}
				
			} catch( e: Error )
			{
				throw new BadPdfFormatError(e);
			}
			
			put( PdfName.LENGTH, new PdfNumber( streamBytes.length ) );
			
			if( compressed )
				put( PdfName.FILTER, PdfName.FLATEDECODE );
		}
	}
}