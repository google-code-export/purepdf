package org.purepdf.pdf
{
	import org.purepdf.utils.Bytes;

	public class PdfLiteral extends PdfObject
	{
		private var position: int;
		
		
		public function PdfLiteral( text: String = null )
		{
			super( 0 );
			
			if( text )
				bytes = PdfEncodings.convertToBytes( text, null );
		}
		
		override public function toString(): String
		{
			var res: String = "";
			for( var a: int = 0; a < bytes.length; a++ )
			{
				res += String.fromCharCode( bytes[a] );
			}
			return res;
		}
	}
}