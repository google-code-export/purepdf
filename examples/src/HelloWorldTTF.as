package
{
	import flash.events.Event;
	
	import org.purepdf.Font;
	import org.purepdf.elements.Chunk;
	import org.purepdf.elements.Paragraph;
	import org.purepdf.pdf.fonts.BaseFont;
	import org.purepdf.pdf.fonts.FontsResourceFactory;

	public class HelloWorldTTF extends DefaultBasicExample
	{
		[Embed(source="/Users/alessandro/Library/Fonts/CarolinaLTStd.otf", mimeType="application/octet-stream")] private var cls1: Class;
		[Embed(source="/Library/Fonts/Herculanum.ttf", mimeType="application/octet-stream")] private var cls2: Class;
		
		public function HelloWorldTTF()
		{
			super(["This example shows how to load and use .otf and  .ttf font files","and embed them to the output pdf document"]);
		}
		
		override protected function execute(event:Event=null) : void
		{
			super.execute();

			// register the 2 fonts
			FontsResourceFactory.getInstance().registerFont("CarolinaLTStd.otf", cls1);
			FontsResourceFactory.getInstance().registerFont("Herculanum.ttf", cls2);
			
			createDocument("Hello World Embedded fonts");
			document.open();
			
			// First font
			var bf: BaseFont = BaseFont.createFont("CarolinaLTStd.otf", BaseFont.CP1252, BaseFont.EMBEDDED );
			var font: Font = new Font( -1, 18, -1, null, bf );
			
			document.addElement( Paragraph.create("Font: " + bf.getFamilyFontName().join(","), font ) );
			document.addElement( Chunk.NEWLINE );
			document.addElement( Paragraph.create("Encoding: " + bf.encoding, font ) );
			document.addElement( Chunk.NEWLINE );
			
			document.addElement( Paragraph.create("qwertyuiopasdfghjklzxcvbnm", font ) );
			document.addElement( Paragraph.create("QWERTYUIOPASDFGHJKLZXCVBNM", font ) );
			document.addElement( Paragraph.create("1234567890", font ) );
			document.addElement( Paragraph.create("!\"£$%&/()=", font ) );
			document.addElement( Paragraph.create("|\\?^'ìè+é*òàùç°§,.-;:_<>", font ) );
			document.addElement( Paragraph.create("@#¶][", font ) );
			
			document.addElement( Chunk.NEWLINE );
			document.addElement( Chunk.NEWLINE );
			
			// Second Font
			bf = BaseFont.createFont("Herculanum.ttf", BaseFont.CP1252, BaseFont.EMBEDDED );
			font = new Font( -1, 18, -1, null, bf );
			
			document.addElement( Paragraph.create("Font: " + bf.getFamilyFontName().join(","), font ) );
			document.addElement( Chunk.NEWLINE );
			document.addElement( Paragraph.create("Encoding: " + bf.encoding, font ) );
			document.addElement( Chunk.NEWLINE );
			
			document.addElement( Paragraph.create("qwertyuiopasdfghjklzxcvbnm", font ) );
			document.addElement( Paragraph.create("QWERTYUIOPASDFGHJKLZXCVBNM", font ) );
			document.addElement( Paragraph.create("1234567890", font ) );
			document.addElement( Paragraph.create("!\"£$%&/()=", font ) );
			document.addElement( Paragraph.create("|\\?^'ìè+é*òàùç°§,.-;:_<>", font ) );
			document.addElement( Paragraph.create("@#¶][", font ) );
			
			
			
			document.close();
			save();
			
			
		}
	}
}