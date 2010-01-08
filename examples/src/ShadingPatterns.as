package
{
	import flash.events.Event;
	
	import org.purepdf.colors.RGBColor;
	import org.purepdf.colors.ShadingColor;
	import org.purepdf.pdf.PageSize;
	import org.purepdf.pdf.PdfContentByte;
	import org.purepdf.pdf.PdfShading;
	import org.purepdf.pdf.PdfShadingPattern;
	import org.purepdf.pdf.PdfViewPreferences;

	public class ShadingPatterns extends DefaultBasicExample
	{
		override protected function createDescription() : void
		{
			description("This Example shows how to draw using","shading patterns (aka gradients)");
		}
		
		override protected function execute(event:Event=null) : void
		{
			super.execute();
			
			createDocument("Shading Patterns example", PageSize.A5 );
			document.setViewerPreferences( PdfViewPreferences.PageLayoutTwoColumnLeft );
			document.open();
			
			var cb: PdfContentByte = document.getDirectContent();
			var axial: PdfShading = PdfShading.simpleAxial( document.getWriter(), 36, 716, 396, 788, RGBColor.ORANGE, RGBColor.BLUE );
			cb.paintShading(axial);
			
			var radial: PdfShading = PdfShading.simpleRadial( document.getWriter(), 200, 500, 50, 300, 500, 100, new RGBColor(255, 247, 148), new RGBColor(247, 138, 107), false, false);
			cb.paintShading(radial);
			document.newPage();
			
			var axialPattern: PdfShadingPattern = new PdfShadingPattern( axial );
			cb.setShadingFill( axialPattern );
			cb.rectangle( 36, 716, 72, 72 );
			cb.rectangle( 144, 716, 72, 72 );
			cb.rectangle( 252, 716, 72, 72 );
			cb.rectangle( 360, 716, 72, 72 );
			cb.fillStroke();
			
			var axialColor: ShadingColor = new ShadingColor( axialPattern );
			cb.setFillColor( axialColor );
			cb.rectangle( 36, 608, 72, 72 );
			cb.rectangle( 144, 608, 72, 72 );
			cb.rectangle( 252, 608, 72, 72 );
			cb.rectangle( 360, 608, 72, 72 );
			cb.fillStroke();
			
			var radialPattern: PdfShadingPattern = new PdfShadingPattern( radial );
			var radialColor: ShadingColor = new ShadingColor( radialPattern );
			cb.setFillColor( radialColor );
			cb.rectangle( 36, 500, 72, 72 );
			cb.rectangle( 144, 500, 72, 72 );
			cb.rectangle( 252, 500, 72, 72 );
			cb.rectangle( 360, 500, 72, 72 );
			cb.fillStroke();
			
			document.close();
			save();
		}
	}
}