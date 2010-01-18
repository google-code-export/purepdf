package org.purepdf.elements
{
	import it.sephiroth.utils.HashMap;
	
	import org.purepdf.Font;
	import org.purepdf.ISplitCharacter;
	import org.purepdf.colors.RGBColor;
	import org.purepdf.pdf.PdfAction;
	import org.purepdf.pdf.PdfAnnotation;
	import org.purepdf.utils.StringUtils;
	import org.purepdf.utils.Utilities;

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

		/**
		 * Gets the text displacement relative to the baseline
		 */
		public function getTextRise(): Number
		{
			if ( _attributes != null && _attributes.containsKey( SUBSUPSCRIPT ) )
			{
				var f: Number = Number( _attributes.getValue( SUBSUPSCRIPT ) );
				return f;
			}
			return 0;
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

		public function setAnchor( url: String ): Chunk
		{
			return setAttribute( ACTION, PdfAction.create( url ) );
		}
		
		public function setAction( action: PdfAction ): Chunk
		{
			return setAttribute( ACTION, action );
		}

		public function setAttribute( name: String, obj: Object ): Chunk
		{
			if ( _attributes == null )
				_attributes = new HashMap();
			_attributes.put( name, obj );
			return this;
		}
		
		public function setAnnotation( annotation: PdfAnnotation ): Chunk
		{
			return setAttribute( PDFANNOTATION, annotation );
		}

		/**
		 * Set the color and size of the background color for this
		 * chunk element
		 *
		 */
		public function setBackground( color: RGBColor, extraLeft: Number=0, extraBottom: Number=0, extraRight: Number=0, extraTop: Number
			=0 ): Chunk
		{
			return setAttribute( BACKGROUND, Vector.<Object>( [ color, Vector.<Number>( [ extraLeft, extraBottom, extraRight, extraTop ] ) ] ) );
		}


		public function setLocalDestination( name: String ): Chunk
		{
			return setAttribute( LOCALDESTINATION, name );
		}

		public function setLocalGoto( name: String ): Chunk
		{
			return setAttribute( LOCALGOTO, name );
		}

		public function setNewPage(): Chunk
		{
			return setAttribute( NEWPAGE, null );
		}

		public function setTextRise( rise: Number ): Chunk
		{
			return setAttribute( SUBSUPSCRIPT, rise );
		}

		/**
		 * @param color	the color of the line. null to use text color
		 * @param thickness	the weight of the line
		 * @param thicknessMul	thickness multiplication factor with the font size
		 * @param yPosition	absolute y position relative to the baseline
		 * @param yPositionMul	position multiplication factor with the font size
		 * @param cap	the end line cap. Allowed values are
		 *            PdfContentByte.LINE_CAP_BUTT, PdfContentByte.LINE_CAP_ROUND
		 *            and PdfContentByte.LINE_CAP_PROJECTING_SQUARE
		 *
		 * @see org.purepdf.pdf.PdfContentByte#LINE_CAP_BUTT
		 * @see org.purepdf.pdf.PdfContentByte#LINE_CAP_ROUND
		 * @see org.purepdf.pdf.PdfContentByte#LINE_CAP_PROJECTING_SQUARE
		 */
		public function setUnderline( color: RGBColor=null, thickness: Number=1, thicknessMul: Number=0, yPosition: Number=0, yPositionMul: Number
			=0, cap: int=0 ): Chunk
		{
			if ( _attributes == null )
				_attributes = new HashMap();
			var obj: Vector.<Object> = Vector.<Object>( [ color, Vector.<Number>( [ thickness, thicknessMul, yPosition, yPositionMul, cap ] ) ] );
			var unders: Vector.<Vector.<Object>> = Utilities.addToArray( attributes.getValue( UNDERLINE ) as Vector.<Vector.<Object>>
				, obj );
			return setAttribute( UNDERLINE, unders );
		}
		
		public function setSplitCharacter( value: ISplitCharacter ): Chunk
		{
			return setAttribute( SPLITCHARACTER, value );
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