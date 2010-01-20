package org.purepdf.elements
{
	import it.sephiroth.utils.HashMap;
	
	import org.purepdf.errors.DocumentError;
	import org.purepdf.pdf.PdfName;

	public class Annotation implements IElement
	{
		public static const APPLICATION: String = "application";
		public static const CONTENT: String = "content";
		public static const DEFAULTDIR: String = "defaultdir";
		public static const DESTINATION: String = "destination";
		public static const FILE: String = "file";
		public static const FILE_DEST: int = 3;
		public static const FILE_PAGE: int = 4;
		public static const LAUNCH: int = 6;
		public static const LLX: String = "llx";
		public static const LLY: String = "lly";
		public static const MIMETYPE: String = "mime";
		public static const NAMED: String = "named";
		public static const NAMED_DEST: int = 5;
		public static const OPERATION: String = "operation";
		public static const PAGE: String = "page";
		public static const PARAMETERS: String = "parameters";
		public static const SCREEN: int = 7;
		public static const TEXT: int = 0;
		public static const TITLE: String = "title";
		public static const URL: String = "url";
		public static const URL_AS_STRING: int = 2;
		public static const URL_NET: int = 1;
		public static const URX: String = "urx";
		public static const URY: String = "ury";
		protected var _annotationAttributes: HashMap = new HashMap();
		protected var _annotationtype: int;
		protected var _llx: Number = NaN;
		protected var _lly: Number = NaN;
		protected var _urx: Number = NaN;
		protected var _ury: Number = NaN;

		public function Annotation( ... rest: Array )
		{
			super();

			if ( rest && rest.length > 0 )
			{
				if ( rest[ 0 ] is Annotation )
				{
					var an: Annotation = Annotation( rest[ 0 ] );
					_annotationtype = an._annotationtype;
					_annotationAttributes = an._annotationAttributes;
					_llx = an.llx;
					_lly = an.lly;
					_urx = an.urx;
					_ury = an.ury;
				}
				else if ( rest[ 0 ] is Number )
				{
					_llx = rest[ 0 ];
					_lly = rest[ 1 ];
					_urx = rest[ 2 ];
					_ury = rest[ 3 ];
				}
				else if ( rest[ 0 ] is String )
				{
					_annotationtype = TEXT;
					_annotationAttributes.put( PdfName.TITLE, rest[ 0 ] );
					_annotationAttributes.put( PdfName.CONTENT, rest[ 1 ] );
				}
			}
		}
		
		public function process( listener: IElementListener ): Boolean
		{
			try 
			{
				return listener.addElement( this );
			} catch ( de: DocumentError )
			{}
			return false;
		}

		
		public function get isNestable(): Boolean
		{
			return true;
		}
		
		public function get isContent(): Boolean
		{
			return true;
		}
		
		public function toString(): String
		{
			return "[Annotation]";
		}
		
		public function get type(): int
		{
			return Element.ANNOTATION;
		}
		
		public function getChunks(): Vector.<Object>
		{
			return new Vector.<Object>();
		}

		public function get annotationtype(): int
		{
			return _annotationtype;
		}

		public function get attributes(): HashMap
		{
			return _annotationAttributes;
		}

		public function get llx(): Number
		{
			return _llx;
		}

		public function get lly(): Number
		{
			return _lly;
		}

		public function setDimensions( $llx: Number, $lly: Number, $urx: Number, $ury: Number ): void
		{
			_llx = $llx;
			_lly = $lly;
			_urx = $urx;
			_ury = $ury;
		}

		public function get urx(): Number
		{
			return _urx;
		}

		public function get ury(): Number
		{
			return _ury;
		}
	}
}