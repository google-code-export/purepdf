package org.purepdf.elements
{
	import org.purepdf.pdf.PdfName;
	import org.purepdf.utils.collections.HashMap;

	public class AnnotationElement extends Element
	{
		// membervariables
		
		/** This is a possible annotation type. */
		public static const TEXT: int = 0;
		
		/** This is a possible annotation type. */
		public static const URL_NET: int = 1;
		
		/** This is a possible annotation type. */
		public static const URL_AS_STRING: int = 2;
		
		/** This is a possible annotation type. */
		public static const FILE_DEST: int = 3;
		
		/** This is a possible annotation type. */
		public static const FILE_PAGE: int = 4;
		
		/** This is a possible annotation type. */
		public static const NAMED_DEST: int = 5;
		
		/** This is a possible annotation type. */
		public static const LAUNCH: int = 6;
		
		/** This is a possible annotation type. */
		public static const SCREEN: int = 7;
		
		/** This is a possible attribute. */
		public static const TITLE: String = "title";
		
		/** This is a possible attribute. */
		public static const CONTENT: String = "content";
		
		/** This is a possible attribute. */
		public static const URL: String = "url";
		
		/** This is a possible attribute. */
		public static const FILE: String = "file";
		
		/** This is a possible attribute. */
		public static const DESTINATION: String = "destination";
		
		/** This is a possible attribute. */
		public static const PAGE: String = "page";
		
		/** This is a possible attribute. */
		public static const NAMED: String = "named";
		
		/** This is a possible attribute. */
		public static const APPLICATION: String = "application";
		
		/** This is a possible attribute. */
		public static const PARAMETERS: String = "parameters";
		
		/** This is a possible attribute. */
		public static const OPERATION: String = "operation";
		
		/** This is a possible attribute. */
		public static const DEFAULTDIR: String = "defaultdir";
		
		/** This is a possible attribute. */
		public static const LLX: String = "llx";
		
		/** This is a possible attribute. */
		public static const LLY: String = "lly";
		
		/** This is a possible attribute. */
		public static const URX: String = "urx";
		
		/** This is a possible attribute. */
		public static const URY: String = "ury";
		
		/** This is a possible attribute. */
		public static const MIMETYPE: String = "mime";
		
		protected var _annotationtype: int;
		protected var _annotationAttributes: HashMap = new HashMap();
		protected var _llx: Number = NaN;
		protected var _lly: Number = NaN;
		protected var _urx: Number = NaN;
		protected var _ury: Number = NaN;
		
		public function AnnotationElement( ...rest: Array )
		{
			super();
			if( rest && rest.length > 0 )
			{
				if( rest[0] is AnnotationElement )
				{
					var an: AnnotationElement = AnnotationElement( rest[0] );
					_annotationtype = an._annotationtype;
					_annotationAttributes = an._annotationAttributes;
					_llx = an.llx;
					_lly = an.lly;
					_urx = an.urx;
					_ury = an.ury;
				} else if( rest[0] is Number )
				{
					_llx = rest[0];
					_lly = rest[1];
					_urx = rest[2];
					_ury = rest[3];
				} else if( rest[0] is String )
				{
					_annotationtype = TEXT;
					_annotationAttributes.put( PdfName.TITLE, rest[0] );
					_annotationAttributes.put( PdfName.CONTENT, rest[1] );
				}
			}
		}
		
		public function get attributes():HashMap
		{
			return _annotationAttributes;
		}

		public function get annotationtype():int
		{
			return _annotationtype;
		}

		public function get ury():Number
		{
			return _ury;
		}

		public function get urx():Number
		{
			return _urx;
		}

		public function get lly():Number
		{
			return _lly;
		}

		public function get llx(): Number
		{
			return _llx;
		}
		
		public function setDimensions( $llx: Number, $lly: Number, $urx: Number, $ury: Number ): void
		{
			_llx = $llx;
			_lly = $lly;
			_urx = $urx;
			_ury = $ury;
		}
	}
}