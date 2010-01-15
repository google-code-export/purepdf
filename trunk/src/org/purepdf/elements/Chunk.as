package org.purepdf.elements
{
	import it.sephiroth.utils.HashMap;
	import org.purepdf.Font;
	import org.purepdf.utils.StringUtils;

	public class Chunk extends Element
	{
		public static const ACTION: String = "ACTION";
		public static const BACKGROUND: String = "BACKGROUND";
		public static const CHAR_SPACING: String = "CHAR_SPACING";
		public static const COLOR: String = "COLOR";
		public static const ENCODING: String = "ENCODING";
		public static const GENERICTAG: String = "GENERICTAG";
		public static const HSCALE: String = "HSCALE";
		public static const HYPHENATION: String = "HYPHENATION";
		public static const IMAGE: String = "IMAGE";
		public static const LOCALDESTINATION: String = "LOCALDESTINATION";
		public static const LOCALGOTO: String = "LOCALGOTO";
		public static const NEWPAGE: String = "NEWPAGE";
		public static const OBJECT_REPLACEMENT_CHARACTER: String = "\ufffc";
		public static const PDFANNOTATION: String = "PDFANNOTATION";
		public static const REMOTEGOTO: String = "REMOTEGOTO";
		public static const SEPARATOR: String = "SEPARATOR";
		public static const SKEW: String = "SKEW";
		public static const SPLITCHARACTER: String = "SPLITCHARACTER";
		public static const SUBSUPSCRIPT: String = "SUBSUPSCRIPT";
		public static const TAB: String = "TAB";
		public static const TEXTRENDERMODE: String = "TEXTRENDERMODE";
		public static const UNDERLINE: String = "UNDERLINE";
		protected var _attributes: HashMap = null;

		protected var _content: String;
		protected var _font: Font;

		public function Chunk( content: String, font: Font )
		{
			super();
			_content = content;
			_font = font;
		}

		public function append( value: String ): void
		{
			_content += value;
		}

		public function get attributes(): HashMap
		{
			return _attributes;
		}


		public function set attributes( value: HashMap ): void
		{
			_attributes = value;
		}

		public function get content(): String
		{
			return _content;
		}

		public function get font(): Font
		{
			return _font;
		}

		public function get hasAttributes(): Boolean
		{
			return _attributes != null;
		}

		public function get isEmpty(): Boolean
		{
			return ( StringUtils.trim( _content.toString() ).length == 0 ) && ( _content.toString().indexOf( "\n" ) == -1 ) && ( _attributes
				== null );
		}

		override public function process( listener: IElementListener ): Boolean
		{
			try
			{
				return listener.add( this );
			}
			catch ( de: Error )
			{
				//return false;
				throw de;
			}
			return false;
		}

		public function setAttribute( name: String, obj: Object ): Chunk
		{
			if ( _attributes == null )
				_attributes = new HashMap();
			_attributes.put( name, obj );
			return this;
		}

		override public function toString(): String
		{
			return content;
		}

		override public function get type(): int
		{
			return CHUNK;
		}
	}
}