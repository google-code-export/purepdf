package
{
	import flash.events.Event;
	
	import org.purepdf.Font;
	import org.purepdf.colors.RGBColor;
	import org.purepdf.elements.Paragraph;
	import org.purepdf.pdf.fonts.BaseFont;
	import org.purepdf.pdf.fonts.FontsResourceFactory;
	
	public class HelloWorld2 extends DefaultBasicExample
	{
		public function HelloWorld2()
		{
			super(["This example shows how to add a simple text to the document","using a new registered font"]);
		}
		
		override protected function execute(event:Event=null) : void
		{
			super.execute();
			
			createDocument( "Hello World" );
			document.open();
			
			var font: Font = new Font( Font.HELVETICA, 18, Font.BOLD );
			document.addElement( Paragraph.create("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent vel lectus lorem. ", font) );
			
			font = new Font( Font.HELVETICA, 18, Font.ITALIC );
			document.addElement( Paragraph.create("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent vel lectus lorem. ", font) );

			font = new Font( Font.TIMES_ROMAN, 18, Font.BOLDITALIC );
			document.addElement( Paragraph.create("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent vel lectus lorem. ", font) );

			font = new Font( Font.COURIER, 18, Font.NORMAL );
			document.addElement( Paragraph.create("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent vel lectus lorem. ", font) );

			font = new Font( Font.ZAPFDINGBATS, 18, Font.NORMAL );
			document.addElement( Paragraph.create("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent vel lectus lorem. ", font) );

			
			document.close();
			save();
		}
	}
}