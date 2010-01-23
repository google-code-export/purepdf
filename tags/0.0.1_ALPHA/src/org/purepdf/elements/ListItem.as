package org.purepdf.elements
{
	import org.purepdf.Font;

	public class ListItem extends Paragraph
	{
		protected var _symbol: Chunk;
		
		public function ListItem( text: String, font: Font=null )
		{
			super( text, font );
		}
		
		public function set listSymbol( value: Chunk ): void
		{
			if( _symbol == null )
			{
				_symbol = value;
				if( _symbol.font.isStandardFont )
					_symbol.font = font;
			}
		}
		
		public function get listSymbol(): Chunk
		{
			return _symbol;
		}
		
		public function setIndentationLeft( indentation: Number, autoindent: Boolean ): void
		{
			if( autoindent )
				indentationLeft = listSymbol.getWidthPoint();
			else
				indentationLeft = indentation;
		}
		
		
		public static function fromPhrase( phrase: Phrase ): ListItem
		{
			var result: ListItem = new ListItem( null );
			result.initFromPhrase( phrase );
			return result;
		}
		
		override public function get type() : int
		{
			return Element.LISTITEM;
		}
	}
}