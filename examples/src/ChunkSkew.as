package
{
	import flash.events.Event;
	
	import org.purepdf.Font;
	import org.purepdf.elements.Chunk;
	import org.purepdf.elements.Paragraph;
	import org.purepdf.pdf.fonts.BaseFont;
	import org.purepdf.pdf.fonts.BuiltinFonts;
	import org.purepdf.pdf.fonts.FontsResourceFactory;

	public class ChunkSkew extends DefaultBasicExample
	{
		public function ChunkSkew(d_list:Array=null)
		{
			super(["Adds chunks and set different skew factors"]);
		}
		
		override protected function execute(event:Event=null) : void
		{
			super.execute();
			
			FontsResourceFactory.getInstance().registerFont( BaseFont.HELVETICA, BuiltinFonts.HELVETICA );
			
			createDocument();
			document.open();
			
			var chunk: Chunk;
			var p: Paragraph = new Paragraph();
			
			chunk = new Chunk("1. Test chunk skew" );
			chunk.setSkew( 15, -30 );
			p.add( chunk );
			
			chunk = new Chunk("2. Test chunk skew" );
			chunk.setSkew( 15, 15 );
			p.add( chunk );
			
			chunk = new Chunk("3. Test chunk skew" );
			chunk.setSkew( -30, 15 );
			p.add( chunk );
			
			document.addElement( p );
			
			p = new Paragraph();
			document.addElement(Chunk.NEWLINE);
			document.addElement(Chunk.NEWLINE);
			document.addElement(Chunk.NEWLINE);
			p = new Paragraph();
			chunk = new Chunk("4. Test chunk skew");
			chunk.setSkew(45, 0);
			p.add(chunk);
			chunk = new Chunk("5. Test chunk skew");
			p.add(chunk);
			chunk = new Chunk("6. Test chunk skew");
			chunk.setSkew(-45, 0);
			p.add(chunk);
			document.addElement(p);
			
			document.addElement(Chunk.NEWLINE);
			document.addElement(Chunk.NEWLINE);
			document.addElement(Chunk.NEWLINE);
			p = new Paragraph();
			chunk = new Chunk("7. Test chunk skew");
			chunk.setSkew(0, 25);
			p.add(chunk);
			chunk = new Chunk("8. Test chunk skew");
			p.add(chunk);
			chunk = new Chunk("9. Test chunk skew");
			chunk.setSkew(0, -25);
			p.add(chunk);
			document.addElement(p);
			
			document.close();
			save();
		}
	}
}