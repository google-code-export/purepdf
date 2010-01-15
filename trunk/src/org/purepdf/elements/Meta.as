package org.purepdf.elements
{
	import org.purepdf.errors.DocumentError;

	public class Meta implements IElement
	{
		private var _content: String;
		private var _type: int;

		public function Meta( $type: int, $content: String )
		{
			super();
			_type = $type;
			_content = $content;
		}
		
		public function toString(): String
		{
			return "[Meta: " + _content + "]";
		}
		
		public function process( element: IElementListener ): Boolean
		{
			try
			{
				return element.add( this );
			} catch( e: DocumentError )
			{
				return false;
			}
			return false;
		}

		public function append( value: String ): String
		{
			_content += value;
			return _content;
		}

		public function getChunks(): Vector.<Object>
		{
			return new Vector.<Object>();
		}

		public function getContent(): String
		{
			return _content;
		}

		public function getName(): String
		{
			switch ( _type )
			{
				case Element.SUBJECT:
					return ElementTags.SUBJECT;
				case Element.KEYWORDS:
					return ElementTags.KEYWORDS;
				case Element.AUTHOR:
					return ElementTags.AUTHOR;
				case Element.TITLE:
					return ElementTags.TITLE;
				case Element.PRODUCER:
					return ElementTags.PRODUCER;
				case Element.CREATIONDATE:
					return ElementTags.CREATIONDATE;
				default:
					return ElementTags.UNKNOWN;
			}
		}

		public function get isNestable(): Boolean
		{
			return false;
		}

		public function get isContent(): Boolean
		{
			return false;
		}

		public function get type(): int
		{
			return _type;
		}

		/**
		 * Returns the name of the meta information.
		 *
		 * @return	the Element value corresponding with the given tag
		 */
		public static function getType( tag: String ): int
		{
			if ( ElementTags.SUBJECT == tag )
				return Element.SUBJECT;

			if ( ElementTags.KEYWORDS == tag )
				return Element.KEYWORDS;

			if ( ElementTags.AUTHOR == tag )
				return Element.AUTHOR;

			if ( ElementTags.TITLE == tag )
				return Element.TITLE;

			if ( ElementTags.PRODUCER == tag )
				return Element.PRODUCER;

			if ( ElementTags.CREATIONDATE == tag )
				return Element.CREATIONDATE;
			return Element.HEADER;
		}
	}
}