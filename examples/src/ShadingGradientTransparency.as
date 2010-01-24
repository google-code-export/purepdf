package
{
	import flash.events.Event;
	
	import org.purepdf.colors.GrayColor;
	import org.purepdf.colors.RGBColor;
	import org.purepdf.pdf.PageSize;
	import org.purepdf.pdf.PdfContentByte;
	import org.purepdf.pdf.PdfDictionary;
	import org.purepdf.pdf.PdfGState;
	import org.purepdf.pdf.PdfName;
	import org.purepdf.pdf.PdfShading;
	import org.purepdf.pdf.PdfShadingPattern;
	import org.purepdf.pdf.PdfTemplate;
	import org.purepdf.pdf.PdfTransparencyGroup;

	public class ShadingGradientTransparency extends DefaultBasicExample
	{
		public function ShadingGradientTransparency(d_list:Array=null)
		{
			super(["This example will show how to create a gradient","box with transparent colors"] );
		}
		
		override protected function execute(event:Event=null) : void
		{
			super.execute();
			
			createDocument();
			document.open();
			
			var cb: PdfContentByte = document.getDirectContent();
			
			cb.setColorFill( RGBColor.RED );
			cb.circle( 110, PageSize.A4.height/2, 100 );
			cb.fill();
			cb.resetFill();
			
			drawTransparentGradient( cb, 100, 100, 100, PageSize.A4.height - 200 );
			
			document.close();
			save();
		}
		
		public function drawTransparentGradient( cb: PdfContentByte, x: Number, y: Number, width: Number, height: Number ): void
		{
			var shading: PdfShading;
			var template: PdfTemplate;
			var gState: PdfGState;
			
			cb.moveTo(x, y);
			cb.lineTo(x + width, y);
			cb.lineTo(x + width, y + height);
			cb.lineTo(x, y + height);
			
			// Create template
			template = cb.createTemplate(x+width, y+height);
			
			// Prepare transparent group
			var transGroup: PdfTransparencyGroup = new PdfTransparencyGroup();
			transGroup.put(PdfName.CS, PdfName.DEVICERGB);
			transGroup.isolated = true;
			transGroup.knockout = false;
			template.group = transGroup;
			
			// Prepare graphic state
			gState = new PdfGState();
			var maskDict: PdfDictionary = new PdfDictionary();
			maskDict.put(PdfName.TYPE, PdfName.MASK);
			maskDict.put(PdfName.S, new PdfName("Luminosity"));
			maskDict.put(new PdfName("G"), template.indirectReference );
			gState.put(PdfName.SMASK, maskDict);
			cb.setGState(gState);
			
			shading = PdfShading.complexAxial( 
				writer, 0, y, 0, height, 
				Vector.<RGBColor>([ new GrayColor(1), new GrayColor(0), new GrayColor(.5), new GrayColor(1), new GrayColor(1), new GrayColor(0.2), new GrayColor(1) ]),
				null
			);
			template.paintShading(shading);
			
			// Draw the actual colour under the mask
			shading = PdfShading.complexAxial( 
				writer, 0, y, 0, height,
				Vector.<RGBColor>([ RGBColor.YELLOW, RGBColor.BLACK, RGBColor.CYAN, RGBColor.GREEN, RGBColor.BLUE, RGBColor.ORANGE , RGBColor.MAGENTA ]),
				null
			);
			
			var axialPattern: PdfShadingPattern = new PdfShadingPattern( shading );
			
			cb.setShadingFill( axialPattern );
			cb.fill();
		}

	}
}