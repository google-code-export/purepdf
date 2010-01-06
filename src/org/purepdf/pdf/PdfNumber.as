package org.purepdf.pdf
{
	import org.purepdf.utils.StringUtils;

	public class PdfNumber extends PdfObject
	{
		private var value: Number;
		
		public function PdfNumber( $value: * )
		{
			super( NUMBER );
			
			if( $value is String )
				setStringValue( $value );
			else if( !isNaN( $value ) && $value == Math.round( $value ) )
				setIntValue( $value );
			else
				setFloatValue( $value );
		}
		
		private function setStringValue( v: String ): void
		{
			v = StringUtils.trim( v );
			
			value = parseFloat( v );
			setContent( v );
		}
		
		private function setIntValue( v: int ): void
		{
			value = v;
			setContent( v.toString() );
		}
		
		private function setFloatValue( v: Number ): void
		{
			value = v;
			setContent( ByteBuffer.formatDouble( v ) );
		}
		
		public function intValue(): int
		{
			return int( value );
		}
		
		public function floatValue(): Number
		{
			return value;
		}
		
		public function increment(): void
		{
			value += 1.0;
			setContent( ByteBuffer.formatDouble( value ) );
		}
	}
}