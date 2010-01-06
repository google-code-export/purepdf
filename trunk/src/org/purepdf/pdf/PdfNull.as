package org.purepdf.pdf
{

	public class PdfNull extends PdfObject
	{
		public static const PDFNULL: PdfNull = new PdfNull();
		private static const CONTENT: String = "null";
		
		public function PdfNull()
		{
			super( NULL );
			setContent( CONTENT );
		}
		
		override public function toString(): String
		{
			return "null";
		}
	}
}