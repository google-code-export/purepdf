package org.purepdf.elements
{
	import org.purepdf.Font;
	import org.purepdf.factories.FontFactory;
	import org.purepdf.factories.GreekAlphabetFactory;
	import org.purepdf.pdf.fonts.BaseFont;

	public class GreekList extends List
	{
		public function GreekList( $symbolIndent: Number = 0 )
		{
			super( true, $symbolIndent );
			setGreekFont();
		}

		override public function add( o: Object ): Boolean
		{
			if ( o is ListItem )
			{
				var item: ListItem = ListItem( o );
				var chunk: Chunk = new Chunk( preSymbol, symbol.font );
				chunk.append( GreekAlphabetFactory.getString( first + list.length, lowercase ) );
				chunk.append( postSymbol );
				item.listSymbol = chunk;
				item.setIndentationLeft( symbolIndent, autoindent );
				item.indentationRight = 0;
				list.push( item );
				return true;
			} else if ( o is List )
			{
				var nested: List = List( o );
				nested.indentationLeft = nested.indentationLeft + symbolIndent;
				first--;
				list.push( nested );
				return true;
			} else if ( o is String )
			{
				return add( new ListItem( String( o ) ) );
			}
			return false;
		}

		protected function setGreekFont(): void
		{
			var fontsize: Number = symbol.font.size;
			symbol.font = FontFactory.getFont( BaseFont.SYMBOL, BaseFont.WINANSI, BaseFont.NOT_EMBEDDED, fontsize, Font.NORMAL );
		}
	}
}