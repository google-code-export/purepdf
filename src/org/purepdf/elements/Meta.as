package org.purepdf.elements
{

	public class Meta extends Element
	{
		private var _type: int;
		private var _content: String;
		
		public function Meta( $type: int, $content: String )
		{
			super();
			_type = $type;
			_content = $content;
		}
		
		override public function type() : int
		{
			return _type;
		}
		
		override public function getChunks() : Array
		{
			return new Array();
		}
		
		override public function get iscontent() : Boolean
		{
			return false;
		}
		
		override public function isNestable() : Boolean
		{
			return false;
		}
		
		public function append( value: String ): String
		{
			_content += value;
			return _content;
		}
		
		public function getContent(): String
		{
			return _content;
		}
		
		public function getName(): String
		{
			switch( _type )
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
		
		/**
		 * Returns the name of the meta information.
		 * 
		 * @param tag iText tag for meta information
		 * @return	the Element value corresponding with the given tag
		 */
		public static function getType( tag: String ): int
		{
			if( ElementTags.SUBJECT == tag )
				return Element.SUBJECT;
			
			if (ElementTags.KEYWORDS == tag )
				return Element.KEYWORDS;
			
			if (ElementTags.AUTHOR == tag )
				return Element.AUTHOR;
			
			if (ElementTags.TITLE == tag )
				return Element.TITLE;
			
			if (ElementTags.PRODUCER == tag )
				return Element.PRODUCER;
			
			if (ElementTags.CREATIONDATE == tag )
				return Element.CREATIONDATE;
			
			return Element.HEADER;
		}
	}
}