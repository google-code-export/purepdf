package org.purepdf.pdf
{
	import org.purepdf.IOutputStream;

	public class PdfTrailer extends PdfDictionary
	{
		private var offset: int;
		
		public function PdfTrailer( $size: int, $offset: int, $root: PdfIndirectReference, $info: PdfIndirectReference,
				$encryption: PdfIndirectReference, $fileID: PdfObject, $prevxref: int )
		{
			offset = $offset;
			put( PdfName.SIZE, new PdfNumber( $size ) );
			put( PdfName.ROOT, $root );
			
			if( $info != null )
				put( PdfName.INFO, $info );
			
			if( $encryption != null )
				put( PdfName.ENCRYPT, $encryption );
			
			if( $fileID != null )
				put( PdfName.ID, $fileID );
			
			if( $prevxref > 0 )
				put( PdfName.PREV, new PdfNumber( $prevxref ) );
		}
		
		override public function toPdf( writer: PdfWriter, os: IOutputStream ): void
		{
			os.writeBytes( PdfWriter.getISOBytes("trailer\n") );
			super.toPdf( null, os );
			os.writeBytes( PdfWriter.getISOBytes("\nstartxref\n") );
			os.writeBytes( PdfWriter.getISOBytes( offset.toString() ) );
			os.writeBytes( PdfWriter.getISOBytes("\n%EOF\n") );
		}
	}
}