package org.purepdf.pdf
{
	import org.purepdf.IOutputStream;
	import org.purepdf.utils.Bytes;

	public class PdfString extends PdfObject
	{
		protected var encoding: String = TEXT_PDFDOCENCODING;
		protected var originalValue: String = null;
		protected var value: String = NOTHING;

		public function PdfString( $value: *, $encoding: String = TEXT_PDFDOCENCODING )
		{
			super( STRING );
			encoding = $encoding;

			if ( $value is String )
			{
				value = $value;
			} else if ( $value is Bytes )
			{
				value = PdfEncodings.convertToString( $value, null );
				encoding = NOTHING;
			} else {
				throw new Error( "only string and bytes supported" );
			}
		}

		override public function getBytes(): Bytes
		{
			if ( bytes == null )
			{
				if ( encoding != null && encoding == TEXT_UNICODE && PdfEncodings.isPdfDocEncoding( value ) )
					bytes = PdfEncodings.convertToBytes( value, TEXT_PDFDOCENCODING );
				else
					bytes = PdfEncodings.convertToBytes( value, encoding );
			}
			return bytes;
		}

		public function setEncoding( enc: String ): void
		{
			encoding = enc;
		}

		override public function toPdf( writer: PdfWriter, os: IOutputStream ): void
		{
			os.writeBytes( PdfContentByte.escapeByteArray( getBytes() ) );
		}

		override public function toString(): String
		{
			return "[PDFString: " + value + "]";
		}
	}
}