package
{
	import flash.events.Event;
	
	import org.purepdf.Font;
	import org.purepdf.colors.RGBColor;
	import org.purepdf.elements.Anchor;
	import org.purepdf.elements.Chunk;
	import org.purepdf.pdf.fonts.BaseFont;
	import org.purepdf.pdf.fonts.FontsResourceFactory;

	public class HelloWorldAnchor extends DefaultBasicExample
	{
		[Embed(source="assets/fonts/Helvetica-Bold.afm", mimeType="application/octet-stream")] private var _font1: Class;
		[Embed(source="assets/fonts/Helvetica-BoldOblique.afm", mimeType="application/octet-stream")] private var _font2: Class;
		[Embed(source="assets/fonts/Helvetica-Oblique.afm", mimeType="application/octet-stream")] private var _font3: Class;
		
		public function HelloWorldAnchor()
		{
			super(["This example shows how to add external links using anchors","and creates links with different styles"]);
		}
		
		override protected function execute(event:Event=null) : void
		{
			super.execute();
			
			FontsResourceFactory.getInstance().registerFont( BaseFont.HELVETICA_BOLD, _font1 );
			FontsResourceFactory.getInstance().registerFont( BaseFont.HELVETICA_BOLDOBLIQUE, _font2 );
			FontsResourceFactory.getInstance().registerFont( BaseFont.HELVETICA_OBLIQUE, _font3 );
			
			createDocument("Hello World Anchor");
			document.open();
			
			var font: Font = new Font( Font.HELVETICA, 18, -1, RGBColor.BLACK );
			var link: Anchor = Anchor.create("http://code.google.com/p/pdfcore", font );
			link.reference = "http://code.google.com/p/purepdf";
			document.addElement( link );
			
			font.style = Font.UNDERLINE;
			font.color = RGBColor.BLUE;
			link = Anchor.create("http://code.google.com/p/pdfcore", font );
			link.reference = "http://code.google.com/p/purepdf";
			document.addElement( link );
			
			font.style = Font.UNDERLINE | Font.STRIKETHRU;
			font.color = RGBColor.RED;
			link = Anchor.create("http://code.google.com/p/pdfcore", font );
			link.reference = "http://code.google.com/p/purepdf";
			document.addElement( link );
			
			font.style = Font.UNDERLINE | Font.STRIKETHRU | Font.BOLD;
			font.color = RGBColor.YELLOW;
			link = Anchor.create("http://code.google.com/p/pdfcore", font );
			link.reference = "http://code.google.com/p/purepdf";
			document.addElement( link );
			
			font.style = Font.UNDERLINE | Font.ITALIC;
			font.color = RGBColor.MAGENTA;
			link = Anchor.create("http://code.google.com/p/pdfcore", font );
			link.reference = "http://code.google.com/p/purepdf";
			document.addElement( link );
			
			font.style = Font.BOLDITALIC;
			font.color = RGBColor.GRAY;
			
			var chunk: Chunk = new Chunk( "http://code.google.com/p/purepdf", font );
			chunk.setBackground( RGBColor.DARK_GRAY, 5, 5, 5, 5 );
			
			link = Anchor.create2( chunk );
			link.reference = "http://code.google.com/p/purepdf";
			document.addElement( link );
			
			
			document.close();
			save();
		}
	}
}