package
{
	import flash.events.Event;
	
	import org.purepdf.pdf.PdfContentByte;
	import org.purepdf.pdf.fonts.BaseFont;
	import org.purepdf.pdf.fonts.FontsResourceFactory;

	public class HelloUnicode extends DefaultBasicExample
	{
		[Embed(source="assets/fonts/Arial Unicode.ttf", mimeType="application/octet-stream")] private var arialu: Class;
		
		public function HelloUnicode()
		{
			super(null);
			registerDefaultFont();
		}
		
		override protected function execute(event:Event=null) : void
		{
			super.execute();
			createDocument();
			document.open();
			
			FontsResourceFactory.getInstance().registerFont("ArialUnicode.ttf", arialu );
			
			var bf: BaseFont = BaseFont.createFont( "ArialUnicode.ttf", BaseFont.IDENTITY_H, false, true );
			var cb: PdfContentByte = document.getDirectContent();
			cb.beginText();
			cb.setFontAndSize( bf, 12 );
			cb.moveText( 36, 800 );
			cb.showText( "\u7121\u540d" );
			cb.endText();
			
			document.close();
			save();
		}
	}
}