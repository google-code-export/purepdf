package 
{
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.utils.getQualifiedClassName;
	
	import org.purepdf.colors.GrayColor;
	import org.purepdf.colors.RGBColor;
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.pdf.PageSize;
	import org.purepdf.pdf.PdfContentByte;
	import org.purepdf.pdf.PdfDocument;
	import org.purepdf.pdf.PdfWriter;
	
	public class DrawingPaths extends DefaultBasicExample
	{	
		override protected function execute( event: Event = null ): void
		{
			super.execute( event );
			
			var rect: RectangleElement = PageSize.A4;
			rect.setBorderWidth( 50 );
			rect.setBorderSides( RectangleElement.ALL );
			rect.setBorderColor( new GrayColor( 0.4 ) );
			rect.setBackgroundColor( new GrayColor( 0.7 ) );

			createDocument( "Page borders example", rect );
			document.open();
			
			var cb: PdfContentByte = document.getDirectContent();
			cb.setTransform( new Matrix( 1, 0, 0, -1, 0, document.pageSize.getHeight() ) );
			
			cb.saveState();
			cb.setFillColor( new RGBColor( 255, 0, 0 ) );
			cb.moveTo( 110, 110 );
			cb.lineTo( 310, 110 );
			cb.lineTo( 310, 310 );
			cb.lineTo( 110, 310 );
			cb.restoreState();
			
			cb.saveState();
			cb.setFillColor( new GrayColor( 0.8 ) );
			cb.arc( 250, 330, 370, 410, 45, 270 );
			cb.restoreState();
			
			document.close();
			save();
		}
	}
}