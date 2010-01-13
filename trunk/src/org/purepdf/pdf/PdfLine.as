package org.purepdf.pdf
{
	import it.sephiroth.utils.ObjectHash;
	import it.sephiroth.utils.collections.iterators.Iterator;
	
	import org.purepdf.elements.Chunk;
	import org.purepdf.elements.Element;
	import org.purepdf.utils.iterators.VectorIterator;
	

	public class PdfLine extends ObjectHash
	{
		protected var line: Vector.<PdfChunk>;
		protected var _width: Number;
		protected var _height: Number;
		protected var _left: Number;
		protected var _right: Number;
		protected var _alignment: int;
		protected var originalWidth: Number;
		protected var isRTL: Boolean = false;
		protected var newlineSplit: Boolean = false;
		protected var symbolIndent: Number;
		protected var _listSymbol: Chunk = null;
		
		public function PdfLine( $left: Number, $right: Number, $alignment: int, $height: Number )
		{
			_left = $left;
			_width = $right - $left;
			originalWidth = _width;
			_alignment = $alignment;
			_height = $height;
			line = new Vector.<PdfChunk>();
		}
		
		public function get listSymbol(): Chunk
		{
			return _listSymbol;
		}
		
		/**
		 * Gets the number of separators in the line.
		 */
		internal function getSeparatorCount(): int
		{
			var s: int = 0;
			var ck: PdfChunk;
			for( var i: Iterator = new VectorIterator( Vector.<Object>( line ) ); i.hasNext(); )
			{
				ck = PdfChunk(i.next());
				if (ck.isTab())
					return 0;
				
				if (ck.isHorizontalSeparator() ) {
					s++;
				}
			}
			return s;
		}
		
		internal function get indentLeft(): Number
		{
			if( isRTL )
			{
				switch (alignment)
				{
					case Element.ALIGN_LEFT:
						return left + width;
					case Element.ALIGN_CENTER:
						return left + (width / 2);
					default:
						return left;
				}
			} else if( getSeparatorCount() == 0 ) 
			{
				switch (alignment) 
				{
					case Element.ALIGN_RIGHT:
						return left + width;
					case Element.ALIGN_CENTER:
						return left + (width / 2);
				}
			}
			return left;
		}
		
		public function isNewlineSplit(): Boolean
		{
			return newlineSplit && (alignment != Element.ALIGN_JUSTIFIED_ALL);
		}
		
		internal function add( chunk: PdfChunk ): PdfChunk
		{
			if( chunk == null || chunk.toString() == "" )
			{
				return null;
			}
			
			// we split the chunk to be added
			var overflow: PdfChunk = chunk.split( _width );
			newlineSplit = ( chunk.isNewlineSplit() || overflow == null );

			if (chunk.isTab()) 
			{
				var tab: Vector.<Object> = chunk.getAttribute( Chunk.TAB ) as Vector.<Object>;
				var tabPosition: Number = Number(tab[1]);
				var newline: Boolean = tab[2];
				if( newline && tabPosition < originalWidth - width )
					return chunk;

				_width = originalWidth - tabPosition;
				chunk.adjustLeft( _left );
				addToLine( chunk );
			} else if (chunk.length > 0 || chunk.isImage() )
			{
				if (overflow != null)
					chunk.trimLastSpace();
				_width -= chunk.width;
				addToLine( chunk );
			} else if( line.length < 1 ) 
			{
				chunk = overflow;
				overflow = chunk.truncate( _width );
				_width -= chunk.width;
				if( chunk.length > 0 )
				{
					addToLine( chunk );
					return overflow;
				} else 
				{
					if (overflow != null)
						addToLine( overflow );
					return null;
				}
			} else
			{
				_width += (line[ line.length - 1]).trimLastSpace();
			}
			return overflow;
		}
		
		private function addToLine( chunk: PdfChunk ): void
		{
			if( chunk.changeLeading && chunk.isImage() )
			{
				var f: Number = chunk.image.scaledHeight + chunk.imageOffsetY + chunk.image.borderWidthTop;
				if( f > _height) _height = f;
			}
			line.push( chunk );
		}
				
		internal function set extraIndent( extra: Number ): void
		{
			_left += extra;
			_width -= extra;
		}

		public function get alignment():int
		{
			return _alignment;
		}

		public function get right():Number
		{
			return _right;
		}

		public function get left():Number
		{
			return _left;
		}

		public function get width():Number
		{
			return _width;
		}

		public function get height():Number
		{
			return _height;
		}
		
		public function size(): int
		{
			return line.length;
		}
		

	}
}