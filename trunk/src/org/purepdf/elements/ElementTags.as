package org.purepdf.elements
{

	public class ElementTags {
		
		/** the root tag. */
		public static const ITEXT: String = "itext";
		
		/** attribute of the root and annotation tag (also a special tag within a chapter or section) */
		public static const TITLE: String = "title";
		
		/** attribute of the root tag */
		public static const SUBJECT: String = "subject";
		
		/** attribute of the root tag */
		public static const KEYWORDS: String = "keywords";
		
		/** attribute of the root tag */
		public static const AUTHOR: String = "author";
		
		/** attribute of the root tag */
		public static const CREATIONDATE: String = "creationdate";
		
		/** attribute of the root tag */
		public static const PRODUCER: String = "producer";
		
		// Chapters and Sections
		
		/** the chapter tag */
		public static const CHAPTER: String = "chapter";
		
		/** the section tag */
		public static const SECTION: String = "section";
		
		/** attribute of section/chapter tag */
		public static const NUMBERDEPTH: String = "numberdepth";
		
		/** attribute of section/chapter tag */
		public static const DEPTH: String = "depth";
		
		/** attribute of section/chapter tag */
		public static const NUMBER: String = "number";
		
		/** attribute of section/chapter tag */
		public static const INDENT: String = "indent";
		
		/** attribute of chapter/section/paragraph/table/cell tag */
		public static const LEFT: String = "left";
		
		/** attribute of chapter/section/paragraph/table/cell tag */
		public static const RIGHT: String = "right";
		
		// Phrases, Anchors, Lists and Paragraphs
		
		/** the phrase tag */
		public static const PHRASE: String = "phrase";
		
		/** the anchor tag */
		public static const ANCHOR: String = "anchor";
		
		/** the list tag */
		public static const LIST: String = "list";
		
		/** the listitem tag */
		public static const LISTITEM: String = "listitem";
		
		/** the paragraph tag */
		public static const PARAGRAPH: String = "paragraph";
		
		/** attribute of phrase/paragraph/cell tag */
		public static const LEADING: String = "leading";
		
		/** attribute of paragraph/image/table tag */
		public static const ALIGN: String = "align";
		
		/** attribute of paragraph */
		public static const KEEPTOGETHER: String = "keeptogether";
		
		/** attribute of anchor tag */
		public static const NAME: String = "name";
		
		/** attribute of anchor tag */
		public static const REFERENCE: String = "reference";
		
		/** attribute of list tag */
		public static const LISTSYMBOL: String = "listsymbol";
		
		/** attribute of list tag */
		public static const NUMBERED: String = "numbered";
		
		/** attribute of the list tag */
		public static const LETTERED: String = "lettered";
		
		/** attribute of list tag */
		public static const FIRST: String = "first";
		
		/** attribute of list tag */
		public static const SYMBOLINDENT: String = "symbolindent";
		
		/** attribute of list tag */
		public static const INDENTATIONLEFT: String = "indentationleft";
		
		/** attribute of list tag */
		public static const INDENTATIONRIGHT: String = "indentationright";
		
		// Chunks
		
		/** the chunk tag */
		public static const IGNORE: String = "ignore";
		
		/** the chunk tag */
		public static const ENTITY: String = "entity";
		
		/** the chunk tag */
		public static const ID: String = "id";
		
		/** the chunk tag */
		public static const CHUNK: String = "chunk";
		
		/** attribute of the chunk tag */
		public static const ENCODING: String = "encoding";
		
		/** attribute of the chunk tag */
		public static const EMBEDDED: String = "embedded";
		
		/** attribute of the chunk/table/cell tag */
		public static const COLOR: String = "color";
		
		/** attribute of the chunk/table/cell tag */
		public static const RED: String = "red";
		
		/** attribute of the chunk/table/cell tag */
		public static const GREEN: String = "green";
		
		/** attribute of the chunk/table/cell tag */
		public static const BLUE: String = "blue";
		
		/** attribute of the chunk tag */
		public static const SUBSUPSCRIPT: String = Chunk.SUBSUPSCRIPT.toLowerCase();
		
		/** attribute of the chunk tag */
		public static const LOCALGOTO: String = Chunk.LOCALGOTO.toLowerCase();
		
		/** attribute of the chunk tag */
		public static const REMOTEGOTO: String = Chunk.REMOTEGOTO.toLowerCase();
		
		/** attribute of the chunk tag */
		public static const LOCALDESTINATION: String = Chunk.LOCALDESTINATION.toLowerCase();
		
		/** attribute of the chunk tag */
		public static const GENERICTAG: String = Chunk.GENERICTAG.toLowerCase();
		
		// tables/cells
		
		/** the table tag */
		public static const TABLE: String = "table";
		
		/** the cell tag */
		public static const ROW: String = "row";
		
		/** the cell tag */
		public static const CELL: String = "cell";
		
		/** attribute of the table tag */
		public static const COLUMNS: String = "columns";
		
		/** attribute of the table tag */
		public static const LASTHEADERROW: String = "lastHeaderRow";
		
		/** attribute of the table tag */
		public static const CELLPADDING: String = "cellpadding";
		
		/** attribute of the table tag */
		public static const CELLSPACING: String = "cellspacing";
		
		/** attribute of the table tag */
		public static const OFFSET: String = "offset";
		
		/** attribute of the table tag */
		public static const WIDTHS: String = "widths";
		
		/** attribute of the table tag */
		public static const TABLEFITSPAGE: String = "tablefitspage";
		
		/** attribute of the table tag */
		public static const CELLSFITPAGE: String = "cellsfitpage";
		
		/** attribute of the table tag */
		public static const CONVERT2PDFP: String = "convert2pdfp";
		
		/** attribute of the cell tag */
		public static const HORIZONTALALIGN: String = "horizontalalign";
		
		/** attribute of the cell tag */
		public static const VERTICALALIGN: String = "verticalalign";
		
		/** attribute of the cell tag */
		public static const COLSPAN: String = "colspan";
		
		/** attribute of the cell tag */
		public static const ROWSPAN: String = "rowspan";
		
		/** attribute of the cell tag */
		public static const HEADER: String = "header";
		
		/** attribute of the cell tag */
		public static const NOWRAP: String = "nowrap";
		
		/** attribute of the table/cell tag */
		public static const BORDERWIDTH: String = "borderwidth";
		
		/** attribute of the table/cell tag */
		public static const TOP: String = "top";
		
		/** attribute of the table/cell tag */
		public static const BOTTOM: String = "bottom";
		
		/** attribute of the table/cell tag */
		public static const WIDTH: String = "width";
		
		/** attribute of the table/cell tag */
		public static const BORDERCOLOR: String = "bordercolor";
		
		/** attribute of the table/cell tag */
		public static const BACKGROUNDCOLOR: String = "backgroundcolor";
		
		/** attribute of the table/cell tag */
		public static const BGRED: String = "bgred";
		
		/** attribute of the table/cell tag */
		public static const BGGREEN: String = "bggreen";
		
		/** attribute of the table/cell tag */
		public static const BGBLUE: String = "bgblue";
		
		/** attribute of the table/cell tag */
		public static const GRAYFILL: String = "grayfill";
		
		// Misc
		
		/** the image tag */
		public static const IMAGE: String = "image";
		
		/** attribute of the image and annotation tag */
		public static const URL: String = "url";
		
		/** attribute of the image tag */
		public static const UNDERLYING: String = "underlying";
		
		/** attribute of the image tag */
		public static const TEXTWRAP: String = "textwrap";
		
		/** attribute of the image tag */
		public static const ALT: String = "alt";
		
		/** attribute of the image tag */
		public static const ABSOLUTEX: String = "absolutex";
		
		/** attribute of the image tag */
		public static const ABSOLUTEY: String = "absolutey";
		
		/** attribute of the image tag */
		public static const PLAINWIDTH: String = "plainwidth";
		
		/** attribute of the image tag */
		public static const PLAINHEIGHT: String = "plainheight";
		
		/** attribute of the image tag */
		public static const SCALEDWIDTH: String = "scaledwidth";
		
		/** attribute of the image tag */
		public static const SCALEDHEIGHT: String = "scaledheight";
		
		/** attribute of the image tag */
		public static const ROTATION: String = "rotation";
		
		/** the newpage tag */
		public static const NEWPAGE: String = "newpage";
		
		/** the newpage tag */
		public static const NEWLINE: String = "newline";
		
		/** the annotation tag */
		public static const ANNOTATION: String = "annotation";
		
		/** attribute of the annotation tag */
		public static const FILE: String = "file";
		
		/** attribute of the annotation tag */
		public static const DESTINATION: String = "destination";
		
		/** attribute of the annotation tag */
		public static const PAGE: String = "page";
		
		/** attribute of the annotation tag */
		public static const NAMED: String = "named";
		
		/** attribute of the annotation tag */
		public static const APPLICATION: String = "application";
		
		/** attribute of the annotation tag */
		public static const PARAMETERS: String = "parameters";
		
		/** attribute of the annotation tag */
		public static const OPERATION: String = "operation";
		
		/** attribute of the annotation tag */
		public static const DEFAULTDIR: String = "defaultdir";
		
		/** attribute of the annotation tag */
		public static const LLX: String = "llx";
		
		/** attribute of the annotation tag */
		public static const LLY: String = "lly";
		
		/** attribute of the annotation tag */
		public static const URX: String = "urx";
		
		/** attribute of the annotation tag */
		public static const URY: String = "ury";
		
		/** attribute of the annotation tag */
		public static const CONTENT: String = "content";
		
		// alignment attribute values
		
		/** the possible value of an alignment attribute */
		public static const ALIGN_LEFT: String = "Left";
		
		/** the possible value of an alignment attribute */
		public static const ALIGN_CENTER: String = "Center";
		
		/** the possible value of an alignment attribute */
		public static const ALIGN_RIGHT: String = "Right";
		
		/** the possible value of an alignment attribute */
		public static const ALIGN_JUSTIFIED: String = "Justify";
		
		/** the possible value of an alignment attribute */
		public static const ALIGN_JUSTIFIED_ALL: String = "JustifyAll";
		
		/** the possible value of an alignment attribute */
		public static const ALIGN_TOP: String = "Top";
		
		/** the possible value of an alignment attribute */
		public static const ALIGN_MIDDLE: String = "Middle";
		
		/** the possible value of an alignment attribute */
		public static const ALIGN_BOTTOM: String = "Bottom";
		
		/** the possible value of an alignment attribute */
		public static const ALIGN_BASELINE: String = "Baseline";
		
		/** the possible value of an alignment attribute */
		public static const DEFAULT: String = "Default";
		
		/** the possible value of an alignment attribute */
		public static const UNKNOWN: String = "unknown";
		
		/** the possible value of an alignment attribute */
		public static const FONT: String = "font";
		
		/** the possible value of an alignment attribute */
		public static const SIZE: String = "size";
		
		/** the possible value of an alignment attribute */
		public static const STYLE: String = "fontstyle";
		
		/** the possible value of a tag */
		public static const HORIZONTALRULE: String = "horizontalrule";
		
		/** the possible value of a tag */
		public static const PAGE_SIZE: String  = "pagesize";
		
		/** the possible value of a tag */
		public static const ORIENTATION: String  = "orientation";
		
		/** a possible list attribute */
		public static const ALIGN_INDENTATION_ITEMS: String = "alignindent";
		
		/** a possible list attribute */
		public static const AUTO_INDENT_ITEMS: String = "autoindent";
		
		/** a possible list attribute */
		public static const LOWERCASE: String = "lowercase";
		/**
		 * a possible list attribute
		 * @since 2.1.3
		 */
		public static const FACE: String = "face";
		
		/** attribute of the image or iframe tag
		 * @since 2.1.3
		 */
		public static const SRC: String = "src";
		
		
		// methods
		
		/**
		 * Translates the alignment value to a String value.
		 *
		 * @param   alignment   the alignment value
		 * @return  the translated value
		 */
		public static function getAlignment( alignment: int ): String
		{
			switch( alignment )
			{
				case Element.ALIGN_LEFT:
					return ALIGN_LEFT;
				case Element.ALIGN_CENTER:
					return ALIGN_CENTER;
				case Element.ALIGN_RIGHT:
					return ALIGN_RIGHT;
				case Element.ALIGN_JUSTIFIED:
				case Element.ALIGN_JUSTIFIED_ALL:
					return ALIGN_JUSTIFIED;
				case Element.ALIGN_TOP:
					return ALIGN_TOP;
				case Element.ALIGN_MIDDLE:
					return ALIGN_MIDDLE;
				case Element.ALIGN_BOTTOM:
					return ALIGN_BOTTOM;
				case Element.ALIGN_BASELINE:
					return ALIGN_BASELINE;
				default:
					return DEFAULT;
			}
		}
		
		/**
		 * Translates a String value to an alignment value.
		 * (written by Norman Richards, integrated into iText by Bruno)
		 * @param	alignment a String (one of the ALIGN_ constants of this class)
		 * @return	an alignment value (one of the ALIGN_ constants of the Element interface) 
		 */
		public static function alignmentValue( alignment: String ): int
		{
			if (alignment == null) return Element.ALIGN_UNDEFINED;
			
			if (ALIGN_CENTER.toLowerCase() == alignment.toLowerCase() )
				return Element.ALIGN_CENTER;
			
			if (ALIGN_LEFT.toLowerCase() == alignment.toLowerCase())
				return Element.ALIGN_LEFT;
			
			if (ALIGN_RIGHT.toLowerCase() == alignment.toLowerCase())
				return Element.ALIGN_RIGHT;
			
			if (ALIGN_JUSTIFIED.toLowerCase() == alignment.toLowerCase())
				return Element.ALIGN_JUSTIFIED;
			
			if (ALIGN_JUSTIFIED_ALL.toLowerCase() == alignment.toLowerCase())
				return Element.ALIGN_JUSTIFIED_ALL;
			
			if (ALIGN_TOP.toLowerCase() == alignment.toLowerCase())
				return Element.ALIGN_TOP;
			
			if (ALIGN_MIDDLE.toLowerCase() == alignment.toLowerCase())
				return Element.ALIGN_MIDDLE;
			
			if (ALIGN_BOTTOM.toLowerCase() == alignment.toLowerCase())
				return Element.ALIGN_BOTTOM;
			
			if (ALIGN_BASELINE.toLowerCase() == alignment.toLowerCase())
				return Element.ALIGN_BASELINE;
			
			return Element.ALIGN_UNDEFINED;
		}
	}
}