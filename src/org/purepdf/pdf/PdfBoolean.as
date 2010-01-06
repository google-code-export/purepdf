package org.purepdf.pdf
{
	public class PdfBoolean extends PdfObject
	{
		public static const PDF_TRUE: PdfBoolean = new PdfBoolean( true );
		public static const PDF_FALSE: PdfBoolean = new PdfBoolean( false );
		
		public static const TRUE: String = "true";
		public static const FALSE: String = "false";
		
		private var value: Boolean;
		
		public function PdfBoolean( val: Boolean )
		{
			super( BOOLEAN );
			setContent( val ? TRUE : FALSE );
			value = val;
		}
		
		public function get booleanValue(): Boolean
		{
			return value;
		}
		
		override public function toString(): String
		{
			return value ? TRUE : FALSE;
		}
	}
}