package org.purepdf.pdf
{

	public class PdfFormXObject extends PdfStream
	{
		public static const MATRIX: PdfLiteral = new PdfLiteral( "[1 0 0 1 0 0]" );
		public static const ONE: PdfNumber = new PdfNumber( 1 );
		public static const ZERO: PdfNumber = new PdfNumber( 0 );

		public function PdfFormXObject( template: PdfTemplate, compressionLevel: int )
		{
			super();
			put( PdfName.TYPE, PdfName.XOBJECT );
			put( PdfName.SUBTYPE, PdfName.FORM );
			put( PdfName.RESOURCES, template.resources );
			put( PdfName.BBOX, PdfRectangle.createFromRectangle( template.boundingBox ) );
			put( PdfName.FORMTYPE, ONE );

			if ( template.layer != null )
				put( PdfName.OC, template.layer.getRef() );

			if ( template.group != null )
				put( PdfName.GROUP, template.group );
			var matrix: PdfArray = template.getMatrix();

			if ( matrix == null )
				put( PdfName.MATRIX, MATRIX );
			else
				put( PdfName.MATRIX, matrix );
			bytes = template.toPdf( null );
			put( PdfName.LENGTH, new PdfNumber( bytes.length ) );
			flateCompress( compressionLevel );
		}
	}
}