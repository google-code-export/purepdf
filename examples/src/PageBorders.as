package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.colors.GrayColor;
	import org.purepdf.colors.RGBColor;
	import org.purepdf.pdf.PageSize;
	import org.purepdf.pdf.PdfContentByte;
	import org.purepdf.pdf.PdfDocument;
	import org.purepdf.pdf.PdfWriter;
	
	public class PageBorders extends DefaultBasicExample
	{	
		override protected function execute( event: Event = null ): void
		{
			super.execute( event );
			
			var rect: RectangleElement = PageSize.A4;
			rect.setBorderWidth( 50 );
			rect.setBorderSides( RectangleElement.LEFT | RectangleElement.TOP | RectangleElement.RIGHT | RectangleElement.BOTTOM );
			rect.setBorderColor( new GrayColor( 0.5 ) );
			rect.setBackgroundColor( new GrayColor( 1 ) );
			
			var document: PdfDocument = PdfWriter.create( buffer, rect );
			
			document.open();
			document.addAuthor( "Alessandro Crugnola" );
			document.addTitle( getQualifiedClassName(this) );
			document.addCreator( "http://purepdf.org" );
			document.addKeywords( "keyword1, keyword2" );
			document.addSubject( "Subject test" );
			
			var cb: PdfContentByte = document.getDirectContent();
			cb.setTransform( new Matrix( 1, 0, 0, -1, 0, document.pageSize.getHeight() ) );
			
			cb.saveState();
			cb.setFillColor( new RGBColor( 255, 0, 0 ) );
			
			cb.moveTo( 110, 110 );
			cb.lineTo( 310, 110 );
			cb.lineTo( 310, 310 );
			cb.lineTo( 110, 310 );
			cb.fill();
			cb.restoreState();
			
			document.close();
			save();
		}
	}
}