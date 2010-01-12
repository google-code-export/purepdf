package org.purepdf.elements
{
	import it.sephiroth.utils.collections.iterators.Iterator;
	
	import org.purepdf.Font;
	import org.purepdf.utils.iterators.VectorIterator;

	public class Phrase extends TextElementaryArray
	{
		private static const serialVersionUID: Number = 2643594602455068231;
		protected var _array: Vector.<Object> = new Vector.<Object>();
		protected var _font: Font;
		protected var _leading: Number = Number.NaN;

		public function Phrase()
		{
			super();
		}

		override public function getChunks(): Vector.<Object>
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
		public function hasLeading(): Boolean
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

		override public function get isContent(): Boolean
		{
			return true;
		}

		public function isEmpty(): Boolean
		{
			switch ( _array.length )
			{
				case 0:
					return true;

				case 1:
					var element: Element = Element( _array[ 0 ] );
					if ( element.type() == Element.CHUNK && Chunk( element ).isEmpty() )
						return true;
					return false;

				default:
					return false;
			}
		}
		
		override public function process( listener: IElementListener ): Boolean
		{
			try 
			{
				for( var i: Iterator = new VectorIterator( _array ); i.hasNext(); ) 
				{
					listener.add( Element(i.next()) );
				}
				return true;
			}
			catch( de: Error )
			{
				return false;
			}
			return false;
		}

		override public function get isNestable(): Boolean
		{
			return true;
		}
		
		public function get font(): Font
		{
			return _font;
		}

		public function get leading(): Number
		{
			if ( isNaN( _leading ) && _font != null )
				return font.getCalculatedLeading( 1.5 );

			return _leading;
		}

		override public function type(): int
		{
			return PHRASE;
		}
	}
}