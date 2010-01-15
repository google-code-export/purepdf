package org.purepdf.pdf
{
	public class PdfBorderArray extends PdfArray
	{
		public function PdfBorderArray( hRadius: Number, vRadius: Number, width: Number, dash: PdfDashPattern=null )
		{
			super( new PdfNumber( hRadius ) );
			add( new PdfNumber( vRadius ) );
			add( new PdfNumber( width ) );

			if ( dash != null )
				add( dash );
		}
	}
}