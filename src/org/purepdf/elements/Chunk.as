package org.purepdf.elements
{
	import it.sephiroth.utils.HashMap;
	
	import org.purepdf.Font;
	import org.purepdf.pdf.PdfAction;
	import org.purepdf.utils.StringUtils;

	public class Chunk implements IElement
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
		public static const NEWLINE: Chunk = new Chunk( "\n", new Font() );
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
		public static var _NEXTPAGE: Chunk;

		protected var _attributes: HashMap = null;
		protected var _content: String;
		protected var _font: Font;

		public function Chunk( content: String, font: Font=null )
		{
			super();
			_content = content;
			_font = font != null ? font : new Font();
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

		public function set font( value: Font ): void
		{
			_font = value;
		}

		public function getChunks(): Vector.<Object>
		{
			var tmp: Vector.<Object> = new Vector.<Object>();
			tmp.push( this );
			return tmp;
		}

		public function get hasAttributes(): Boolean
		{
			return _attributes != null;
		}

		public function get isContent(): Boolean
		{
			return true;
		}

		public function get isEmpty(): Boolean
		{
			return ( StringUtils.trim( _content.toString() ).length == 0 ) && ( _content.toString().indexOf( "\n" ) == -1 ) && ( _attributes
				== null );
		}

		public function get isNestable(): Boolean
		{
			return true;
		}

		public function process( listener: IElementListener ): Boolean
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
		
		public function setLocalDestination( name: String ): Chunk
		{
			return setAttribute( LOCALDESTINATION, name );
		}
		
		public function setLocalGoto( name: String ): Chunk
		{
			return setAttribute( LOCALGOTO, name );
		}
		
		public function setAnchor( url: String ): Chunk
		{
			return setAttribute( ACTION, new PdfAction( url ) );
		}

		public function setNewPage(): Chunk
		{
			return setAttribute( NEWPAGE, null );
		}

		public function toString(): String
		{
			return content;
		}

		public function get type(): int
		{
			return Element.CHUNK;
		}

		public static function get NEXTPAGE(): Chunk
		{
			if ( _NEXTPAGE == null )
			{
				_NEXTPAGE = new Chunk( "" );
				_NEXTPAGE.setNewPage();
			}
			return _NEXTPAGE;
		}
	}
}