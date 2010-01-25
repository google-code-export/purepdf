package
{
	import flash.events.Event;
	
	import org.purepdf.Font;
	import org.purepdf.elements.Chunk;
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.pdf.PdfAnnotation;
	import org.purepdf.pdf.fonts.BaseFont;
	import org.purepdf.resources.BuiltinFonts;
	import org.purepdf.pdf.fonts.FontsResourceFactory;

	public class AnnotatedChunk extends DefaultBasicExample
	{
		public function AnnotatedChunk()
		{
			super(["Simple example with a single chunk","with an annotation assigned to it"]);
			registerDefaultFont();
		}
		
		override protected function execute(event:Event=null) : void
		{
			super.execute();
			
			createDocument();
			document.open();
			
			var font: Font = new Font( Font.HELVETICA, 14, Font.NORMAL );
			var chunk: Chunk = new Chunk("Test chunk annotation", font );
			chunk.setAnnotation( PdfAnnotation.createText( new RectangleElement( 200, 150, 300, 350 ), "Hello Annotation", "Some fake contents inside...", true, "Comment" ) );
			
			document.add( chunk );
			
			document.close();
			save();
		}
	}
}