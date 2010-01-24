package org.purepdf.pdf
{
	import org.purepdf.IOutputStream;

	public class PdfLiteral extends PdfObject
	{
		private var _position: int;
		
		
		public function PdfLiteral( text: String = null )
		{
			super( 0 );
			
			if( text )
				bytes = PdfEncodings.convertToBytes( text, null );
		}
		
		public function get position():int
		{
			return _position;
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
		
		override public function toPdf(writer:PdfWriter, os:IOutputStream) : void
		{
			if( os is OutputStreamCounter )
				_position = OutputStreamCounter(os).getCounter();
			super.toPdf( writer, os );
		}
	}
}