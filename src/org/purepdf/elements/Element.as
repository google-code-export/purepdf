package org.purepdf.elements
{
	import it.sephiroth.utils.ObjectHash;
	
	import org.purepdf.errors.NonImplementatioError;

	[Abstract]
	public class Element extends ObjectHash implements IElement
	{
		public static const ALIGN_BASELINE: int = 7;
		public static const ALIGN_BOTTOM: int = 6;
		public static const ALIGN_CENTER: int = 1;
		public static const ALIGN_JUSTIFIED: int = 3;
		public static const ALIGN_JUSTIFIED_ALL: int = 8;
		public static const ALIGN_LEFT: int = 0;
		public static const ALIGN_MIDDLE: int = 5;
		public static const ALIGN_RIGHT: int = 2;
		public static const ALIGN_TOP: int = 4;
		public static const ALIGN_UNDEFINED: int = -1;
		public static const ANCHOR: int = 17;
		public static const ANNOTATION: int = 29;
		public static const AUTHOR: int = 4;
		public static const CCITTG3_1D: int = 0x101;
		public static const CCITTG3_2D: int = 0x102;
		public static const CCITTG4: int = 0x100;
		public static const CCITT_BLACKIS1: int = 1;
		public static const CCITT_ENCODEDBYTEALIGN: int = 2;
		public static const CCITT_ENDOFBLOCK: int = 8;
		public static const CCITT_ENDOFLINE: int = 4;
		public static const CHAPTER: int = 16;
		public static const CHUNK: int = 10;
		public static const CREATIONDATE: int = 6;
		public static const CREATOR: int = 7;
		public static const HEADER: int = 0;
		public static const IMGRAW: int = 34;
		public static const IMGTEMPLATE: int = 35;
		public static const JBIG2: int = 36;
		public static const JPEG: int = 32;
		public static const JPEG2000: int = 33;
		public static const KEYWORDS: int = 3;
		public static const LIST: int = 14;
		public static const LISTITEM: int = 15;
		public static const MARKED: int = 50;
		public static const MULTI_COLUMN_TEXT: int = 40;
		public static const PARAGRAPH: int = 12;
		public static const PHRASE: int = 11;
		public static const PRODUCER: int = 5;
		public static const PTABLE: int = 23;
		public static const RECTANGLE: int = 30;
		public static const SECTION: int = 13;
		public static const SUBJECT: int = 2;
		public static const TITLE: int = 1;
		public static const YMARK: int = 55;
		public static const TABLE: int = 22;

		public function Element()
		{
		}
		
		[Abstract]
		public function process( listener: IElementListener ): Boolean
		{
			throw new NonImplementatioError();
		}

		[Abstract]
		public function getChunks(): Vector.<Object>
		{
			throw new NonImplementatioError();
		}

		[Abstract]
		public function get isNestable(): Boolean
		{
			throw new NonImplementatioError();
		}

		[Abstract]
		public function get isContent(): Boolean
		{
			throw new NonImplementatioError();
		}

		[Abstract]
		public function toString(): String
		{
			throw new NonImplementatioError();
		}

		[Abstract]
		public function get type(): int
		{
			throw new NonImplementatioError();
		}
	}
}