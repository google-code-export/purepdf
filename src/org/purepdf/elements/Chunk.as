package org.purepdf.elements
{
	import it.sephiroth.utils.HashMap;
	
	import org.purepdf.Font;
	import org.purepdf.utils.StringUtils;

	public class Chunk extends Element
	{
		public static const GENERICTAG: String = "GENERICTAG";
		public static const LOCALDESTINATION: String = "LOCALDESTINATION";
		public static const LOCALGOTO: String = "LOCALGOTO";
		public static const REMOTEGOTO: String = "REMOTEGOTO";
		public static const SUBSUPSCRIPT: String = "SUBSUPSCRIPT";
		public static const ACTION: String = "ACTION";
		public static const NEWPAGE: String = "NEWPAGE";
		public static const PDFANNOTATION: String = "PDFANNOTATION";
		public static const COLOR: String = "COLOR";
		public static const ENCODING: String = "ENCODING";
		public static const CHAR_SPACING: String = "CHAR_SPACING";
		public static const OBJECT_REPLACEMENT_CHARACTER: String = "\ufffc";
		public static const SEPARATOR: String = "SEPARATOR";
		public static const TAB: String = "TAB";
		public static const HSCALE: String = "HSCALE";
		public static const UNDERLINE: String = "UNDERLINE";
		public static const SKEW: String = "SKEW";
		public static const BACKGROUND: String = "BACKGROUND";
		public static const TEXTRENDERMODE: String = "TEXTRENDERMODE";
		public static const SPLITCHARACTER: String = "SPLITCHARACTER";
		public static const HYPHENATION: String = "HYPHENATION";
		public static const IMAGE: String = "IMAGE";
		
		protected var _content: String;
		protected var _font: Font;
		protected var _attributes: HashMap = null;
		
		public function Chunk( content: String, font: Font )
		{
			super();
			_content = content;
			_font = font;
		}
		
		override public function process( listener: IElementListener ): Boolean
		{
			try 
			{
				return listener.add( this );
			} catch ( de: Error )
			{
				return false;
			}
			return false;
		}
		
		public function hashAttributes(): Boolean
		{
			return _attributes != null;
		}
		
		public function get attributes(): HashMap
		{
			return _attributes;
		}
		
		override public function toString(): String
		{
			return content;
		}
		
		public function get content(): String
		{
			return _content;
		}
		
		public function get font(): Font
		{
			return _font;
		}
			
		
		public function set attributes( value: HashMap ): void
		{
			_attributes = value;
		}
		
		public function setAttribute( name: String, obj: Object ): Chunk
		{
			if( _attributes == null )
				_attributes = new HashMap();
			_attributes.put( name, obj );
			return this;
		}
		
		public function isEmpty(): Boolean
		{
			return ( StringUtils.trim( _content.toString() ).length == 0 ) && ( _content.toString().indexOf("\n") == -1) && ( _attributes == null);
		}
	}
}