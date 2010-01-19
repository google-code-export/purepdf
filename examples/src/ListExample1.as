package
{
	import flash.events.Event;
	
	import org.purepdf.elements.Chunk;
	import org.purepdf.elements.List;
	import org.purepdf.elements.ListItem;
	import org.purepdf.elements.Phrase;
	import org.purepdf.pdf.fonts.BaseFont;
	import org.purepdf.pdf.fonts.BuiltinFonts;
	import org.purepdf.pdf.fonts.FontsResourceFactory;

	public class ListExample1 extends DefaultBasicExample
	{
		public function ListExample1( d_list: Array=null )
		{
			super( d_list );
		}

		override protected function execute( event: Event=null ): void
		{
			super.execute();

			FontsResourceFactory.getInstance().registerFont( BaseFont.HELVETICA, BuiltinFonts.HELVETICA );

			createDocument( "List example" );
			document.open();

			var phrase: Phrase = new Phrase( "Quick brown fox jumps over", null );
			document.addElement( phrase );

			var list1: List = new List( List.ORDERED, 20 );
			list1.add( new ListItem( "the lazy dog" ) );
			list1.add( new ListItem( "the lazy cat" ) );
			list1.add( new ListItem( "the fence" ) );
			document.addElement( list1 );

			document.addElement( Chunk.NEWLINE );
			document.addElement( phrase );

			var list2: List = new List( List.UNORDERED, 10 );
			list2.add( "the lazy dog" );
			list2.add( "the lazy cat" );
			list2.add( "the fence" );
			document.addElement( list2 );

			document.addElement( Chunk.NEWLINE );
			document.addElement( phrase );

			var list3: List = new List( List.ORDERED, 20 );
			list3.lettered = List.ALPHABETICAL;
			list3.add( new ListItem( "the lazy dog" ) );
			list3.add( new ListItem( "the lazy cat" ) );
			list3.add( new ListItem( "the fence" ) );
			document.addElement( list3 );

			document.addElement( Chunk.NEWLINE );
			document.addElement( phrase );

			var list4: List = new List( List.UNORDERED, 30 );
			list4.symbol = new Chunk("----->");
			list4.indentationLeft = 10;
			list4.add( "the lazy dog" );
			list4.add( "the lazy cat" );
			list4.add( "the fence" );
			document.addElement( list4 );

			document.addElement( Chunk.NEWLINE );
			document.addElement( phrase );

			var list5: List = new List( List.ORDERED, 20 );
			list5.first = 11;
			list5.add( new ListItem( "the lazy dog" ) );
			list5.add( new ListItem( "the lazy cat" ) );
			list5.add( new ListItem( "the fence" ) );
			document.addElement( list5 );

			document.addElement( Chunk.NEWLINE );

			var list: List = new List( List.UNORDERED, 10 );
			list.symbol = new Chunk( '*' );
			list.add( "Quick brown fox jumps over" );
			list.add( list1 );
			list.add( "Quick brown fox jumps over" );
			list.add( list3 );
			list.add( "Quick brown fox jumps over" );
			list.add( list5 );
			document.addElement( list );

			document.close();
			save();
		}
	}
}