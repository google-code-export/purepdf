package org.purepdf.pdf
{
	import it.sephiroth.utils.ObjectHash;
	import it.sephiroth.utils.collections.iterators.Iterator;
	
	import org.purepdf.elements.Chunk;
	import org.purepdf.elements.Element;
	import org.purepdf.utils.iterators.VectorIterator;

	public class PdfLine extends ObjectHash
	{
		protected var _alignment: int = 0;
		protected var _height: Number = 0;
		protected var _left: Number = 0;
		protected var _listSymbol: Chunk = null;
		protected var _right: Number = 0;
		protected var _width: Number = 0;
		protected var isRTL: Boolean = false;
		protected var line: Vector.<PdfChunk>;
		protected var newlineSplit: Boolean = false;
		protected var originalWidth: Number = 0;
		protected var symbolIndent: Number = 0;

		public function PdfLine( $left: Number, $right: Number, $alignment: int, $height: Number )
		{
			_left = $left;
			_width = $right - $left;
			originalWidth = _width;
			_alignment = $alignment;
			_height = $height;
			line = new Vector.<PdfChunk>();
		}
		
		public function iterator(): Iterator
		{
			return new VectorIterator( Vector.<Object>( line ) );
		}

		
		/**
		 * Gets the index of the last <CODE>PdfChunk</CODE> with metric attributes
		 */
		public function get lastStrokeChunk(): int
		{
			var lastIdx: int = line.length - 1;
			for (; lastIdx >= 0; --lastIdx)
			{
				if( line[lastIdx].isStroked())
					break;
			}
			return lastIdx;
		}
		
		
		public function get alignment(): int
		{
			return _alignment;
		}


		public function hasToBeJustified(): Boolean
		{
			return ( ( _alignment == Element.ALIGN_JUSTIFIED || _alignment == Element.ALIGN_JUSTIFIED_ALL ) && _width != 0 );
		}

		public function get height(): Number
		{
			return _height;
		}

		public function isNewlineSplit(): Boolean
		{
			return newlineSplit && ( alignment != Element.ALIGN_JUSTIFIED_ALL );
		}

		public function get left(): Number
		{
			return _left;
		}


		/**
		 * Returns the length of a line in UTF32 characters
		 */
		public function get lengthUtf32(): int
		{
			var total: int = 0;

			for ( var i: Iterator = new VectorIterator( Vector.<Object>( line ) ); i.hasNext();  )
			{
				total += PdfChunk( i.next() ).lengthUtf32;
			}
			return total;
		}

		public function get listSymbol(): Chunk
		{
			return _listSymbol;
		}

		public function get right(): Number
		{
			return _right;
		}

		public function size(): int
		{
			return line.length;
		}

		public function toString(): String
		{
			var tmp: String = "";

			for ( var i: int = 0; i < line.length; ++i )
				tmp += line[ i ].toString();

			return tmp;
		}

		public function get widthLeft(): Number
		{
			return _width;
		}

		internal function add( chunk: PdfChunk ): PdfChunk
		{
			if ( chunk == null || chunk.toString() == "" )
			{
				return null;
			}

			// we split the chunk to be added
			var overflow: PdfChunk = chunk.split( _width );
			newlineSplit = ( chunk.isNewlineSplit() || overflow == null );

			if ( chunk.isTab() )
			{
				var tab: Vector.<Object> = chunk.getAttribute( Chunk.TAB ) as Vector.<Object>;
				var tabPosition: Number = Number( tab[ 1 ] );
				var newline: Boolean = tab[ 2 ];

				if ( newline && tabPosition < originalWidth - _width )
					return chunk;

				_width = originalWidth - tabPosition;
				chunk.adjustLeft( _left );
				addToLine( chunk );
			}
			else if ( chunk.length > 0 || chunk.isImage() )
			{
				if ( overflow != null )
					chunk.trimLastSpace();
				_width -= chunk.width;
				addToLine( chunk );
			}
			else if ( line.length < 1 )
			{
				chunk = overflow;
				overflow = chunk.truncate( _width );
				_width -= chunk.width;

				if ( chunk.length > 0 )
				{
					addToLine( chunk );
					return overflow;
				}
				else
				{
					if ( overflow != null )
						addToLine( overflow );
					return null;
				}
			}
			else
			{
				_width += ( line[ line.length - 1 ] ).trimLastSpace();
			}
			return overflow;
		}

		internal function set extraIndent( extra: Number ): void
		{
			_left += extra;
			_width -= extra;
		}

		/**
		 * Gets the number of separators in the line.
		 */
		internal function getSeparatorCount(): int
		{
			var s: int = 0;
			var ck: PdfChunk;

			for ( var i: Iterator = new VectorIterator( Vector.<Object>( line ) ); i.hasNext();  )
			{
				ck = PdfChunk( i.next() );

				if ( ck.isTab() )
					return 0;

				if ( ck.isHorizontalSeparator() )
				{
					s++;
				}
			}
			return s;
		}

		internal function get indentLeft(): Number
		{
			if ( isRTL )
			{
				switch ( alignment )
				{
					case Element.ALIGN_LEFT:
						return _left + _width;
					case Element.ALIGN_CENTER:
						return _left + ( _width / 2 );
					default:
						return _left;
				}
			}
			else if ( getSeparatorCount() == 0 )
			{
				switch ( alignment )
				{
					case Element.ALIGN_RIGHT:
						return _left + _width;
					case Element.ALIGN_CENTER:
						return _left + ( _width / 2 );
				}
			}
			return _left;
		}

		internal function get numberOfSpaces(): int
		{
			var string: String = toString();
			var length: int = string.length;
			var nSpaces: int = 0;
			var re: Array = string.match( / /g );

			if ( re )
				nSpaces = re.length;

			return nSpaces;
		}


		/**
		 * Gets the number of separators in the line
		 */
		internal function get separatorCount(): int
		{
			var s: int = 0;
			var ck: PdfChunk;

			for ( var i: Iterator = new VectorIterator( Vector.<Object>( line ) ); i.hasNext();  )
			{
				ck = i.next();

				if ( ck.isTab() )
					return 0;

				if ( ck.isHorizontalSeparator() )
				{
					s++;
				}
			}
			return s;
		}

		private function addToLine( chunk: PdfChunk ): void
		{
			if ( chunk.changeLeading && chunk.isImage() )
			{
				var f: Number = chunk.image.scaledHeight + chunk.imageOffsetY + chunk.image.borderWidthTop;

				if ( f > _height )
					_height = f;
			}
			line.push( chunk );
		}
	}
}