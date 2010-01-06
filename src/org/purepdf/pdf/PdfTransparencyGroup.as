package org.purepdf.pdf
{
	public class PdfTransparencyGroup extends PdfDictionary
	{
		public function PdfTransparencyGroup()
		{
			super();
			put( PdfName.S, PdfName.TRANSPARENCY );
		}
		
		public function set isolated( value: Boolean ): void
		{
			if( value )
				put( PdfName.I, PdfBoolean.PDF_TRUE );
			else
				remove( PdfName.I );
		}
		
		public function set knockout( value: Boolean ): void
		{
			if( value )
				put( PdfName.K, PdfBoolean.PDF_TRUE );
			else
				remove( PdfName.K );
		}
	}
}