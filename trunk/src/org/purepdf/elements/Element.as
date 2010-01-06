package org.purepdf.elements
{
	import org.purepdf.errors.NonImplementatioError;

	public class Element implements IElement
	{
		/** This is a possible type of <CODE>Element</CODE>. */
		public static const HEADER: int = 0;
		
		/** This is a possible type of <CODE>Element</CODE>. */
		public static const TITLE: int = 1;
		
		/** This is a possible type of <CODE>Element</CODE>. */
		public static const SUBJECT: int = 2;
		
		/** This is a possible type of <CODE>Element</CODE>. */
		public static const KEYWORDS: int = 3;
		
		/** This is a possible type of <CODE>Element </CIDE>. */
		public static const AUTHOR: int = 4;
		
		/** This is a possible type of <CODE>Element </CIDE>. */
		public static const PRODUCER: int = 5;
		
		/** This is a possible type of <CODE>Element </CIDE>. */
		public static const CREATIONDATE: int = 6;
		
		/** This is a possible type of <CODE>Element </CIDE>. */
		public static const CREATOR: int = 7;
		
		/** This is a possible type of <CODE>Element</CODE>. */
		public static const CHUNK: int = 10;
		
		/** This is a possible type of <CODE>Element</CODE>. */
		public static const PHRASE: int = 11;
		
		/** This is a possible type of <CODE>Element</CODE>. */
		public static const PARAGRAPH: int = 12;
		
		/** This is a possible type of <CODE>Element</CODE> */
		public static const SECTION: int = 13;
		
		/** This is a possible type of <CODE>Element</CODE> */
		public static const LIST: int = 14;
		
		/** This is a possible type of <CODE>Element</CODE> */
		public static const LISTITEM: int = 15;
		
		/** This is a possible type of <CODE>Element</CODE> */
		public static const CHAPTER: int = 16;
		
		/** This is a possible type of <CODE>Element</CODE> */
		public static const ANCHOR: int = 17;
		
		// static membervariables (tables)
		
		/** This is a possible type of <CODE>Element</CODE>. */
		public static const PTABLE: int = 23;
		
		/** This is a possible type of <CODE>Element</CODE>. */
		public static const ANNOTATION: int = 29;
		
		/** This is a possible type of <CODE>Element</CODE>. */
		public static const RECTANGLE: int = 30;
		
		/** This is a possible type of <CODE>Element</CODE>. */
		public static const JPEG: int = 32;
		
		/** This is a possible type of <CODE>Element</CODE>. */
		public static const JPEG2000: int = 33;
		
		/** This is a possible type of <CODE>Element</CODE>. */
		public static const IMGRAW: int = 34;
		
		/** This is a possible type of <CODE>Element</CODE>. */
		public static const IMGTEMPLATE: int = 35;
		
		/**
		 * This is a possible type of <CODE>Element</CODE>.
		 * @since	2.1.5
		 */
		public static const JBIG2: int = 36;
		
		/** This is a possible type of <CODE>Element</CODE>. */
		public static const MULTI_COLUMN_TEXT: int = 40;
		
		/** This is a possible type of <CODE>Element</CODE>. */
		public static const MARKED: int = 50;
		
		/** This is a possible type of <CODE>Element</CODE>.
		 * @since 2.1.2
		 */
		public static const YMARK: int = 55;
		
		/**
		 * A possible value for paragraph alignment. This specifies that the text is
		 * aligned to the left indent and extra whitespace should be placed on the
		 * right.
		 */
		public static const ALIGN_UNDEFINED: int = -1;
		
		/**
		 * A possible value for paragraph alignment. This specifies that the text is
		 * aligned to the left indent and extra whitespace should be placed on the
		 * right.
		 */
		public static const ALIGN_LEFT: int = 0;
		
		/**
		 * A possible value for paragraph alignment. This specifies that the text is
		 * aligned to the center and extra whitespace should be placed equally on
		 * the left and right.
		 */
		public static const ALIGN_CENTER: int = 1;
		
		/**
		 * A possible value for paragraph alignment. This specifies that the text is
		 * aligned to the right indent and extra whitespace should be placed on the
		 * left.
		 */
		public static const ALIGN_RIGHT: int = 2;
		
		/**
		 * A possible value for paragraph alignment. This specifies that extra
		 * whitespace should be spread out through the rows of the paragraph with
		 * the text lined up with the left and right indent except on the last line
		 * which should be aligned to the left.
		 */
		public static const ALIGN_JUSTIFIED: int = 3;
		
		/**
		 * A possible value for vertical alignment.
		 */
		
		public static const ALIGN_TOP: int = 4;
		
		/**
		 * A possible value for vertical alignment.
		 */
		
		public static const ALIGN_MIDDLE: int = 5;
		
		/**
		 * A possible value for vertical alignment.
		 */
		
		public static const ALIGN_BOTTOM: int = 6;
		
		/**
		 * A possible value for vertical alignment.
		 */
		public static const ALIGN_BASELINE: int = 7;
		
		/**
		 * Does the same as ALIGN_JUSTIFIED but the last line is also spread out.
		 */
		public static const ALIGN_JUSTIFIED_ALL: int = 8;
		
		/**
		 * Pure two-dimensional encoding (Group 4)
		 */
		public static const CCITTG4: int = 0x100;
		
		/**
		 * Pure one-dimensional encoding (Group 3, 1-D)
		 */
		public static const CCITTG3_1D: int = 0x101;
		
		/**
		 * Mixed one- and two-dimensional encoding (Group 3, 2-D)
		 */
		public static const CCITTG3_2D: int = 0x102;
		
		/**
		 * A flag indicating whether 1-bits are to be interpreted as black pixels
		 * and 0-bits as white pixels,
		 */
		public static const CCITT_BLACKIS1: int = 1;
		
		/**
		 * A flag indicating whether the filter expects extra 0-bits before each
		 * encoded line so that the line begins on a byte boundary.
		 */
		public static const CCITT_ENCODEDBYTEALIGN: int = 2;
		
		/**
		 * A flag indicating whether end-of-line bit patterns are required to be
		 * present in the encoding.
		 */
		public static const CCITT_ENDOFLINE: int = 4;
		
		/**
		 * A flag indicating whether the filter expects the encoded data to be
		 * terminated by an end-of-block pattern, overriding the Rows parameter. The
		 * use of this flag will set the key /EndOfBlock to false.
		 */
		public static const CCITT_ENDOFBLOCK: int = 8;
		
		public function Element()
		{
		}
		
		public function type(): int
		{
			throw new NonImplementatioError();
		}
		
		public function get iscontent(): Boolean
		{
			throw new NonImplementatioError();
		}
		
		public function isNestable(): Boolean
		{
			throw new NonImplementatioError();
		}
		
		public function getChunks(): Array
		{
			throw new NonImplementatioError();
		}
		
		public function toString(): String
		{
			throw new NonImplementatioError();
		}
	}
}