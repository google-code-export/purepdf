package 
{
	import flash.events.Event;
	
	import org.purepdf.colors.GrayColor;
	import org.purepdf.colors.RGBColor;
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.pdf.PageSize;
	import org.purepdf.pdf.PdfContentByte;
	import org.purepdf.pdf.PdfVersion;
	
	public class DrawingPaths extends DefaultBasicExample
	{	
		override protected function execute( event: Event = null ): void
		{
			super.execute( event );
			
			var rect: RectangleElement = RectangleElement.clone( PageSize.getRectangle("A4") );
			rect.setBorderWidth( 50 );
			rect.setBorderSides( RectangleElement.ALL );
			rect.setBorderColor( new GrayColor( 0.4 ) );
			rect.setBackgroundColor( new GrayColor( 0.7 ) );

			createDocument( "Page borders example", rect );
			document.setPdfVersion( PdfVersion.VERSION_1_5 );
			document.open();
			
			var cb: PdfContentByte = document.getDirectContent();
			//cb.setTransform( new Matrix( 1, 0, 0, -1, 0, document.pageSize.getHeight() ) );
			
			cb.saveState();
			cb.setFillColor( new RGBColor( 255, 0, 0 ) );
			cb.moveTo( 110, 110 );
			cb.lineTo( 310, 110 );
			cb.lineTo( 310, 310 );
			cb.lineTo( 110, 310 );
			cb.fillStroke();
			cb.restoreState();
			
			cb.saveState();
			
			var r: RectangleElement = new RectangleElement( 50, 450, 150, 650 );
			r.setBorderSides( RectangleElement.ALL );
			r.setBorderColor( RGBColor.BLACK );
			r.setBackgroundColor( RGBColor.BLUE );
			r.setBorderWidth( 4 );
			
			cb.rectangle( r );
			cb.restoreState();
			
			cb.saveState();
			cb.setFillColor( RGBColor.MAGENTA );
			cb.rectangle( 220, 220, 120, 140 );
			cb.fill();
			cb.restoreState();
			
			cb.saveState();
			cb.setFillColor( new GrayColor( 0.8 ) );
			cb.arc( 250, 330, 370, 410, 45, 270 );
			cb.fill();
			cb.restoreState();
			
			document.close();
			save();
		}
	}
}