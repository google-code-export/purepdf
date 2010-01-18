package org.purepdf.elements
{
	import it.sephiroth.utils.collections.iterators.Iterator;
	
	import org.purepdf.Font;
	import org.purepdf.IIterable;
	import org.purepdf.errors.CastTypeError;
	import org.purepdf.errors.DocumentError;
	import org.purepdf.utils.StringUtils;
	import org.purepdf.utils.iterators.VectorIterator;

	public class Phrase implements ITextElementaryArray, IIterable
	{
		protected var _array: Vector.<Object> = new Vector.<Object>();
		protected var _font: Font;
		protected var _leading: Number = Number.NaN;

		public function Phrase( phrase: Phrase=null )
		{
			super();

			if ( phrase != null )
			{
				addAll( phrase );
				_leading = phrase.leading;
				_font = phrase.font;
			}
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
				var element: IElement = IElement( o );

				switch ( element.type )
				{
					case Element.CHUNK:
						return addChunk( Chunk( o ) );

					case Element.PHRASE:
					case Element.PARAGRAPH:
						var phrase: Phrase = Phrase( o );
						var success: int = 1;
						var e: IElement;
						for ( var i: Iterator = phrase.iterator(); i.hasNext();  )
						{
							e = IElement( i.next() );

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

		public function addAll( collection: IIterable ): Boolean
		{
			for ( var i: Iterator = collection.iterator(); i.hasNext();  )
			{
				add( i.next() );
			}
			return true;
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
				var chunks: Vector.<Object> = IElement( i.next() ).getChunks();
				for ( var k: int = 0; k < chunks.length; ++k )
					tmp.push( chunks[ k ] );

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

		public function insert( index: int, o: Object ): void
		{
			if ( o == null )
				return;

			try
			{
				var element: IElement = IElement( o );

				if ( element.type == Element.CHUNK )
				{
					var chunk: Chunk = Chunk( element );

					if ( !font.isStandardFont )
					{
						chunk.font = font.difference( chunk.font );
					}

					_array.splice( index, 0, chunk );
				}
				else if ( element.type == Element.PHRASE || element.type == Element.ANCHOR || element.type == Element.ANNOTATION || element
					.type == Element.TABLE || element.type == Element.YMARK || element.type == Element.MARKED )
				{
					_array.splice( index, 0, element );
				}
				else
				{
					throw new CastTypeError();
				}
			}
			catch ( cce: CastTypeError )
			{
				throw new CastTypeError( "insertion of illegal element" );
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
					var element: IElement = IElement( _array[ 0 ] );
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

		public function iterator(): Iterator
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
					listener.add( IElement( i.next() ) );
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
		 * </p>
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

		protected function addSpecial( o: Object ): void
		{
			_array.push( o );
		}
	}
}