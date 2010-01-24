package
{
	import flash.events.Event;
	
	import org.purepdf.colors.RGBColor;
	import org.purepdf.pdf.PageSize;
	import org.purepdf.pdf.PdfContentByte;
	import org.purepdf.pdf.PdfShading;

	public class ShadingMultipleColors extends DefaultBasicExample
	{
		public function ShadingMultipleColors(d_list:Array=null)
		{
			super(d_list);
		}
		
		override protected function execute( event: Event = null ) : void
		{
			super.execute();
			
			createDocument("Shading Patterns", PageSize.A6 );
			document.open();
			
			var cb: PdfContentByte = document.getDirectContent();
			var axial: PdfShading = PdfShading.complexAxial( 
						writer, 0, 0, 297, 420, 
						Vector.<RGBColor>([ RGBColor.BLACK, RGBColor.BLUE, RGBColor.CYAN, RGBColor.DARK_GRAY, RGBColor.GRAY, RGBColor.GREEN, RGBColor.LIGHT_GRAY, RGBColor.MAGENTA, RGBColor.ORANGE, RGBColor.PINK, RGBColor.RED, RGBColor.WHITE, RGBColor.YELLOW ]),
						null
			);
			
			cb.paintShading( axial );
			
			document.close();
			save();
		}
	}
}