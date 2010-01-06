package org.purepdf.pdf
{
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.utils.collections.HashMap;

	public class PdfAnnotation extends PdfDictionary
	{
		/** highlight attributename */
		public static const HIGHLIGHT_NONE: PdfName = PdfName.N;
		/** highlight attributename */
		public static const HIGHLIGHT_INVERT: PdfName = PdfName.I;
		/** highlight attributename */
		public static const HIGHLIGHT_OUTLINE: PdfName = PdfName.O;
		/** highlight attributename */
		public static const HIGHLIGHT_PUSH: PdfName = PdfName.P;
		/** highlight attributename */
		public static const HIGHLIGHT_TOGGLE: PdfName = PdfName.T;
		/** flagvalue */
		public static const FLAGS_INVISIBLE: int = 1;
		/** flagvalue */
		public static const FLAGS_HIDDEN: int = 2;
		/** flagvalue */
		public static const FLAGS_PRINT: int = 4;
		/** flagvalue */
		public static const FLAGS_NOZOOM: int = 8;
		/** flagvalue */
		public static const FLAGS_NOROTATE: int = 16;
		/** flagvalue */
		public static const FLAGS_NOVIEW: int = 32;
		/** flagvalue */
		public static const FLAGS_READONLY: int = 64;
		/** flagvalue */
		public static const FLAGS_LOCKED: int = 128;
		/** flagvalue */
		public static const FLAGS_TOGGLENOVIEW: int = 256;
		/** appearance attributename */
		public static const APPEARANCE_NORMAL: PdfName = PdfName.N;
		/** appearance attributename */
		public static const APPEARANCE_ROLLOVER: PdfName = PdfName.R;
		/** appearance attributename */
		public static const APPEARANCE_DOWN: PdfName = PdfName.D;
		/** attributevalue */
		public static const AA_ENTER: PdfName = PdfName.E;
		/** attributevalue */
		public static const AA_EXIT: PdfName = PdfName.X;
		/** attributevalue */
		public static const AA_DOWN: PdfName = PdfName.D;
		/** attributevalue */
		public static const AA_UP: PdfName = PdfName.U;
		/** attributevalue */
		public static const AA_FOCUS: PdfName = PdfName.FO;
		/** attributevalue */
		public static const AA_BLUR: PdfName = PdfName.BL;
		/** attributevalue */
		public static const AA_JS_KEY: PdfName = PdfName.K;
		/** attributevalue */
		public static const AA_JS_FORMAT: PdfName = PdfName.F;
		/** attributevalue */
		public static const AA_JS_CHANGE: PdfName = PdfName.V;
		/** attributevalue */
		public static const AA_JS_OTHER_CHANGE: PdfName = PdfName.C;
		/** attributevalue */
		public static const MARKUP_HIGHLIGHT: int = 0;
		/** attributevalue */
		public static const MARKUP_UNDERLINE: int = 1;
		/** attributevalue */
		public static const MARKUP_STRIKEOUT: int = 2;
		
		public static const MARKUP_SQUIGGLY: int = 3;
		
		protected var _templates: HashMap;
		protected var _placeInPage: int = -1;
		
		protected var writer: PdfWriter;
		protected var reference: PdfIndirectReference;
		protected var form: Boolean = false;
		protected var annotation: Boolean = true;
		protected var used: Boolean = false;
		
		public function PdfAnnotation( $writer: PdfWriter, rect: RectangleElement )
		{
			writer = $writer;
			if( rect != null )
				put( PdfName.RECT, PdfRectangle.createFromRectangle( rect ) );
		}
		
		public function setWriter( $writer: PdfWriter ): void
		{
			writer = $writer;
		}
		
		public function getWriter(): PdfWriter
		{
			return writer;
		}
		
		public function get is_form(): Boolean
		{
			return form;
		}
		
		public function get is_used(): Boolean
		{
			return used;
		}
		
		public function get is_annotation(): Boolean
		{
			return annotation;
		}
		
		public function set is_used( value: Boolean ): void
		{
			used = value;
		}
		
		public function get placeInPage(): int
		{
			return _placeInPage;
		}
		
		public function get templates(): HashMap
		{
			return _templates;
		}
		
		/**
		 * Returns an indirect reference to the annotation
		 * @return the indirect reference
		 */
		public function getIndirectReference(): PdfIndirectReference
		{
			if( reference == null )
			{
				reference = writer.getPdfIndirectReference();
			}
			return reference;
		}
		
		public static function createText( rect: RectangleElement, title: String, contents: String, opened: Boolean, icon: String ): PdfAnnotation
		{
			var annot: PdfAnnotation = new PdfAnnotation( null, rect );
			annot.put( PdfName.SUBTYPE, PdfName.TEXT );
			
			if( title != null )
				annot.put( PdfName.T, new PdfString( title, PdfObject.TEXT_UNICODE ) );
			
			if( contents != null )
				annot.put( PdfName.CONTENTS, new PdfString( contents, PdfObject.TEXT_UNICODE ) );
			
			if( opened )
				annot.put( PdfName.OPEN, PdfBoolean.PDF_TRUE );
			
			if( icon != null )
				annot.put( PdfName.NAME, new PdfName( icon ) );
			
			return annot;
		}
	}
}