package org.purepdf.pdf
{
	import org.purepdf.IOutputStream;
	

	public class PdfDashPattern extends PdfArray
	{
		private var _dash: Number = -1;
		private var _gap: Number = -1;
		private var _phase: Number = -1;

		public function PdfDashPattern( $dash: Number=-1, $gap: Number=-1, $phase: Number=-1 )
		{
			super( $dash > -1 ? new PdfNumber( $dash ) : null );

			if ( $dash > -1 )
			{
				_dash = $dash;

				if ( $gap > -1 )
				{
					add( new PdfNumber( $gap ) );
					_gap = $gap;
					_phase = $phase;
				}
			}
		}
		
		public function add4( n: Number ): void
		{
			add( new PdfNumber( n ) );
		}
		
		override public function toPdf( writer: PdfWriter, os: IOutputStream ): void
		{
			os.writeInt('['.charCodeAt(0));
			
			if ( _dash >= 0 ) {
				new PdfNumber( _dash ).toPdf(writer, os);
				if (_gap >= 0) {
					os.writeInt( 32 );
					new PdfNumber(_gap).toPdf(writer, os);
				}
			}
			os.writeInt(']'.charCodeAt(0));
			if (_phase >=0) {
				os.writeInt(32);
				new PdfNumber(_phase).toPdf(writer, os);
			}
		}
	}
}