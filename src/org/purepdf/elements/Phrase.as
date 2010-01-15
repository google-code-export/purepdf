package org.purepdf.elements
{
	import it.sephiroth.utils.collections.iterators.Iterator;
	import org.purepdf.Font;
	import org.purepdf.errors.CastTypeError;
	import org.purepdf.errors.DocumentError;
	import org.purepdf.utils.StringUtils;
	import org.purepdf.utils.iterators.VectorIterator;

	public class Phrase implements ITextElementaryArray
	{
		private static const serialVersionUID: Number = 2643594602455068231;
		protected var _array: Vector.<Object> = new Vector.<Object>();
		protected var _font: Font;
		protected var _leading: Number = Number.NaN;

		public function Phrase()
		{
			super();
		}

		/**
		 * Adds a Chunk, Ancor or another Phrase
		 * @throws	CastTypeError	allowed elements are: Chunk, Anchor and Phrase
		 */
		public function add( o: Object ): Boolean
		{
			if ( o == null )
				return false;

			if ( o is String )
			{
				_array.push( new Chunk( String( o ), font ) );
				return true;
			}

			try
			{
				var element: Element = Element( o );

				switch ( element.type )
				{
					case Element.CHUNK:
						return addChunk( Chunk( o ) );

					case Element.PHRASE:
					case Element.PARAGRAPH:
						var phrase: Phrase = Phrase( o );
						var success: int = 1;
						var e: Element;
						for ( var i: Iterator = phrase.iterator(); i.hasNext();  )
						{
							e = Element( i.next() );

							if ( e is Chunk )
							{
								success &= addChunk( Chunk( e ) ) ? 1 : 0;
							}
							else
							{
								success &= add( e ) ? 1 : 0;
							}
						}
						return success == 1;

					case Element.MARKED:
					case Element.ANCHOR:
					case Element.ANNOTATION:
					case Element.TABLE:
					case Element.PTABLE:
					case Element.LIST:
					case Element.YMARK:
						_array.push( o );
						return true;

					default:
						throw new CastTypeError( element.type.toString() );
				}
			}
			catch ( cce: CastTypeError )
			{
				throw new CastTypeError( "illegal element. " + cce.message );
			}
			return false;
		}

		public function get font(): Font
		{
			return _font;
		}

		public function getChunks(): Vector.<Object>
		{
			var tmp: Vector.<Object> = new Vector.<Object>();

			for ( var i: Iterator = new VectorIterator( _array ); i.hasNext();  )
			{
				var chunks: Vector.<Object> = Element( i.next() ).getChunks();

				for ( var k: int = 0; k < chunks.length; ++k )
				{
					_array.push( chunks[ k ] );
				}

			}
			return tmp;
		}

		/**
		 * Checks you if the leading of this phrase is defined.
		 *
		 * @return	true if the leading is defined
		 */
		public function get hasLeading(): Boolean
		{
			if ( isNaN( _leading ) )
			{
				return false;
			}
			return true;
		}

		public function init( leading: Number, string: String, font: Font=null ): void
		{
			if ( font == null )
				font = new Font();
			this._leading = leading;
			this._font = font;

			if ( string != null && string.length > 0 )
			{
				_array.push( new Chunk( string, font ) );
			}
		}

		public function get isContent(): Boolean
		{
			return true;
		}

		public function get isEmpty(): Boolean
		{
			switch ( _array.length )
			{
				case 0:
					return true;

				case 1:
					var element: Element = Element( _array[ 0 ] );
					if ( element.type == Element.CHUNK && Chunk( element ).isEmpty )
						return true;
					return false;

				default:
					return false;
			}
		}

		public function get isNestable(): Boolean
		{
			return true;
		}

		public function iterator(): VectorIterator
		{
			return new VectorIterator( _array );
		}

		public function get leading(): Number
		{
			if ( isNaN( _leading ) && _font != null )
				return _font.getCalculatedLeading( 1.5 );

			return _leading;
		}

		public function process( listener: IElementListener ): Boolean
		{
			try
			{
				for ( var i: Iterator = iterator(); i.hasNext();  )
				{
					listener.add( Element( i.next() ) );
				}
				return true;
			}
			catch ( de: DocumentError )
			{
				return false;
			}
			return false;
		}

		public function get size(): uint
		{
			return _array.length;
		}

		public function toString(): String
		{
			return "[Phrase]";
		}

		public function get type(): int
		{
			return Element.PHRASE;
		}

		/**
		 * Adds a Chunk.
		 * <p>
		 * This method is a hack to solve a problem I had with phrases that were split between chunks
		 * in the wrong place.
		 * @param chunk a Chunk to add to the Phrase
		 * @return true if adding the Chunk succeeded
		 */
		protected function addChunk( chunk: Chunk ): Boolean
		{
			var f: Font = chunk.font;
			var c: String = chunk.content;

			if ( font != null && !font.isStandardFont )
				f = font.difference( chunk.font );

			if ( size > 0 && !chunk.hasAttributes )
			{
				try
				{
					var previous: Chunk = _array[ size - 1 ] as Chunk;

					if ( !previous.hasAttributes && ( f == null || f.compareTo( previous.font ) == 0 ) && !( "" == StringUtils.trim( previous
						.content ) ) && !( "" == StringUtils.trim( c ) ) )
					{
						previous.append( c );
						return true;
					}
				}
				catch ( cce: CastTypeError )
				{
				}
			}

			var newChunk: Chunk = new Chunk( c, f );
			newChunk.attributes = chunk.attributes;

			_array.push( newChunk );
			return true;
		}
	}
}