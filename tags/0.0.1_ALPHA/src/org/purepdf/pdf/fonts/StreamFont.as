package org.purepdf.pdf.fonts
{
	import org.purepdf.errors.DocumentError;
	import org.purepdf.pdf.PdfName;
	import org.purepdf.pdf.PdfNumber;
	import org.purepdf.pdf.PdfStream;
	import org.purepdf.utils.Bytes;

	public class StreamFont extends PdfStream
	{
		
		public function StreamFont( contents: Bytes, len: int )
		{
			bytes = contents;
			put( PdfName.LENGTH, new PdfNumber( len ) );
		}
		/**
		 *
		 * @throws DocumentError
		 */
		public static function create( contents: Bytes, lengths: Vector.<int>, compressionLevel: int ): StreamFont
		{
			var s: StreamFont = new StreamFont( contents, contents.length );
			try
			{
				for ( var k: int = 0; k < lengths.length; ++k )
				{
					s.put( new PdfName( "Length" + ( k + 1 ) ), new PdfNumber( lengths[ k ] ) );
				}

				s.flateCompress( compressionLevel );
			}
			catch ( e: Error )
			{
				throw new DocumentError( e );
			}
			return s;
		}
		
		/**
		 * Generates the PDF stream for a font.
		 * @param contents the content of a stream
		 * @param subType the subtype of the font.
		 * @param compressionLevel	the compression level of the Stream
		 * @throws DocumentError
		 */
		public static function create2( contents: Bytes, subType: String, compressionLevel: int ): StreamFont
		{
			var s: StreamFont = new StreamFont( contents, contents.length );
			try 
			{
				if( subType != null )
					s.put( PdfName.SUBTYPE, new PdfName( subType ) );
				s.flateCompress( compressionLevel );
			}
			catch( e: Error )
			{
				throw new DocumentError( e );
			}
			return s;
		}
	}
}