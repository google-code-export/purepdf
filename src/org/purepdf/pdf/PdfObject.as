package org.purepdf.pdf
{
	import org.purepdf.IOutputStream;
	import org.purepdf.utils.Bytes;

	public class PdfObject extends Object
	{
		public static const BOOLEAN: int = 1;
		public static const NUMBER: int = 2;
		public static const STRING: int = 3;
		public static const NAME: int = 4;
		public static const ARRAY: int = 5;
		public static const DICTIONARY: int = 6;
		public static const STREAM: int = 7;
		public static const NULL: int = 8;
		public static const INDIRECT: int = 10;
		
		public static const NOTHING: String = "";
		public static const TEXT_PDFDOCENCODING: String = "PDF";
		public static const TEXT_UNICODE: String = "UnicodeBig";
		
		protected var bytes: Bytes;
		protected var type: int;
		
		public function PdfObject( $type: int )
		{
			super();
			type = $type;
		}
		
		public function getType(): int
		{
			return type;
		}

		public function getBytes(): Bytes
		{
			return bytes;
		}
		
		public function isNull(): Boolean
		{
			return type == NULL;
		}
		
		public function isBoolean(): Boolean
		{
			return type == BOOLEAN;
		}
		
		public function isNumber(): Boolean
		{
			return type == NUMBER;
		}
		
		public function isString(): Boolean
		{
			return type == STRING;
		}
		
		public function isName(): Boolean
		{
			return type == NAME;
		}

		public function isArray(): Boolean
		{
			return type == ARRAY;
		}
		
		public function isDictionary(): Boolean
		{
			return type == DICTIONARY;
		}
		
		public function toString(): String
		{
			if( bytes == null )
				return "[PDFObject: null]";
			return PdfEncodings.convertToString( bytes, null );
		}
		
		protected function setContent( content: String ): void
		{
			bytes = PdfEncodings.convertToBytes( content, null );
		}
		
		public function toPdf( writer: PdfWriter, os: IOutputStream ): void
		{
			if( bytes != null )
			{
				os.writeBytes( bytes );
			}
		}
		
		/**
		 * Whether this object can be contained in an object stream.
		 * 
		 * PdfObjects of type STREAM OR INDIRECT can not be contained in an
		 * object stream.
		 * 
		 * @return <CODE>true</CODE> if this object can be in an object stream.
		 *   Otherwise <CODE>false</CODE>
		 */
		public function canBeInObjStm(): Boolean
		{
			switch( type )
			{
				case NULL:
				case BOOLEAN:
				case NUMBER:
				case STRING:
				case NAME:
				case ARRAY:
				case DICTIONARY:
					return true;
					
				case STREAM:
				case INDIRECT:
				default:
					return false;
			}
		}
	}
}