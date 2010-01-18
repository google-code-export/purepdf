package
{
	import flash.events.Event;
	
	import org.purepdf.Font;
	import org.purepdf.pdf.fonts.*;
	import org.purepdf.pdf.*;
	import org.purepdf.elements.*;
	import org.purepdf.colors.*;

	public class HelloWorldInternalAnchor extends DefaultBasicExample
	{
		public function HelloWorldInternalAnchor(d_list:Array=null)
		{
			super(["This example shows how to create","internal links to the same pdf document", "using PdfAnchor"]);
		}
		
		override protected function execute(event:Event=null) : void
		{
			super.execute();
			
			FontsResourceFactory.getInstance().registerFont( BaseFont.HELVETICA, BuiltinFonts.HELVETICA );
			
			createDocument("Hello World internal link");
			document.open();
			
			var defaultFont: Font = new Font( Font.HELVETICA, 18 );
			var font: Font = new Font( Font.HELVETICA, 18 );
			font.style = Font.UNDERLINE;
			font.color = RGBColor.BLUE;
			
			var paragraph: Paragraph = Paragraph.create("Quick brown ", defaultFont );
			var anchor: Anchor = Anchor.create("fox", font );
			anchor.reference = "#fox";
			paragraph.add( anchor );
			paragraph.add(" jumps over the lazy ");
			
			anchor = Anchor.create("dog", font );
			anchor.reference = "#dog";
			paragraph.add( anchor );
			paragraph.add(".");
			
			document.addElement( paragraph );
			document.newPage();
			
			anchor = Anchor.create("This is the FOX anchor", defaultFont );
			anchor.name = "fox";
			document.addElement( anchor );
			document.newPage();
			
			anchor = Anchor.create("This is the DOG anchor", defaultFont );
			anchor.name = "dog";
			document.addElement( anchor );
			
			document.close();
			save();
		}
	}
}