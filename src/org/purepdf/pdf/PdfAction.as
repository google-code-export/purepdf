package org.purepdf.pdf
{

	/**
	 * A PdfAction defines an action that can be triggered
	 */
	public class PdfAction extends PdfDictionary
	{
		public function PdfAction( url: String, isMap: Boolean = false )
		{
			put( PdfName.S, PdfName.URI );
			put( PdfName.URI, new PdfString( url ) );

			if ( isMap )
				put( PdfName.ISMAP, PdfBoolean.PDF_TRUE );
		}
	}
}