package org.purepdf.elements
{
	import flash.net.URLRequest;
	
	import it.sephiroth.utils.collections.iterators.Iterator;
	
	import org.purepdf.Font;
	import org.purepdf.errors.DocumentError;
	import org.purepdf.utils.StringUtils;
	import org.purepdf.utils.iterators.VectorIterator;

	/**
	 * An Anchor can be a reference or a destination of a reference.<br />
	 * Example:<br />
	 * <pre>
	 * var anchor: Anchor = new Anchor("this is a link");
	 * anchor.name = "LINK";
	 * anchor.reference = "http://code.google.com/p/purepdf";
	 * </pre>
	 *
	 * @see		IElement
	 * @see		Phrase
	 */
	public class Anchor extends Phrase
	{
		protected var _name: String = null;
		protected var _reference: String = null;

		public function Anchor( $text: String, $font: Font = null )
		{
			super( $text, $font, $text == null ? Phrase.DEFAULT_LEADING : Number.NaN );
		}
		
		/**
		 * Create a new Anchor from a starting Phrase or Anchor
		 * 
		 * @param phrase	the starting Phrase or Anchor
		 * @return Anchor
		 * 
		 * @see Phrase
		 */
		public static function fromPhrase( phrase: Phrase = null ): Anchor
		{
			var result: Anchor = new Anchor( null );
			result.initFromPhrase( phrase );
			if (phrase is Anchor)
			{
				var a: Anchor = Anchor( phrase );
				result._name = a.name;
				result._reference = a.reference;
			}
			return result;
		}
		
		public static function fromChunk( chunk: Chunk ): Anchor
		{
			var result: Anchor = new Anchor( null );
			result.add( chunk );
			result._font = chunk.font;
			return result;
		}
		
		override public function process( listener: IElementListener ): Boolean
		{
			try 
			{
				var chunk: Chunk;
				var i: Iterator = new VectorIterator( getChunks() );
				var localDestination: Boolean = ( _reference != null && StringUtils.startsWith( _reference, "#"));
				var notGotoOK: Boolean = true;
				while (i.hasNext() )
				{
					chunk = Chunk( i.next() );
					if( _name != null && notGotoOK && !chunk.isEmpty )
					{
						chunk.setLocalDestination( _name );
						notGotoOK = false;
					}
					if( localDestination )
						chunk.setLocalGoto( _reference.substring(1) );
					
					listener.add( chunk );
				}
				return true;
			}
			catch( de: DocumentError )
			{}
			return false;
		}
		
		override public function getChunks(): Vector.<Object>
		{
			var tmp: Vector.<Object> = new Vector.<Object>();
			var chunk: Chunk;
			var i: Iterator = iterator();
			var localDestination: Boolean = ( _reference != null && StringUtils.startsWith( _reference, "#"));
			var notGotoOK: Boolean = true;
			while (i.hasNext()) 
			{
				chunk = Chunk( i.next() );
				if (_name != null && notGotoOK && !chunk.isEmpty)
				{
					chunk.setLocalDestination( _name );
					notGotoOK = false;
				}
				if( localDestination )
				{
					chunk.setLocalGoto( _reference.substring(1) );
				} else if ( _reference != null )
					chunk.setAnchor( _reference );
				tmp.push( chunk );
			}
			return tmp;
		}
		
		override public function get type(): int
		{
			return Element.ANCHOR;
		}
		
		public function set name( value: String ): void
		{
			_name = value;
		}
		
		public function set reference( value: String ): void
		{
			_reference = value;
		}
		   
		public function get name(): String
		{
			return _name;
		}
		
		public function get reference(): String
		{
			return _reference;
		}
		
		public function get url(): URLRequest
		{
			try 
			{
				return new URLRequest( _reference );
			}
			catch( mue: Error )
			{}
			return null;
		}
	}
}