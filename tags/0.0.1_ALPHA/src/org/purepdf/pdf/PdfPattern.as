package org.purepdf.pdf
{

	public class PdfPattern extends PdfStream
	{
		public function PdfPattern( painter: PdfPatternPainter, compressionLvl: int = NO_COMPRESSION )
		{
			super();
			var one: PdfNumber = new PdfNumber( 1 );
			var matrix: PdfArray = painter.getMatrix();

			if ( matrix != null )
				put( PdfName.MATRIX, matrix );
			put( PdfName.TYPE, PdfName.PATTERN );
			put( PdfName.BBOX, PdfRectangle.createFromRectangle( painter.boundingBox ) );
			put( PdfName.RESOURCES, painter.resources );
			put( PdfName.TILINGTYPE, one );
			put( PdfName.PATTERNTYPE, one );

			if ( painter.is_stencil )
				put( PdfName.PAINTTYPE, new PdfNumber( 2 ) );
			else
				put( PdfName.PAINTTYPE, one );
			put( PdfName.XSTEP, new PdfNumber( painter.xstep ) );
			put( PdfName.YSTEP, new PdfNumber( painter.ystep ) );

			bytes = painter.toPdf( null );
			put( PdfName.LENGTH, new PdfNumber( bytes.length ) );
			flateCompress( compressionLvl );
		}
	}
}