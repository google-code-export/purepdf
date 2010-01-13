package org.purepdf.pdf
{
	import it.sephiroth.utils.ObjectHash;
	
	import org.purepdf.IComparable;
	import org.purepdf.elements.images.ImageElement;
	import org.purepdf.pdf.fonts.BaseFont;

	public class PdfFont extends ObjectHash implements IComparable
	{
		private var _font: BaseFont;
		private var _hScale: Number = 1;
		private var _image: ImageElement;
		private var _size: Number;

		public function PdfFont( $bf: BaseFont, $size: Number )
		{
			super();
			_size = $size;
			_font = $bf;
		}

		public function compareTo( o: Object ): int
		{
			if ( _image != null )
				return 0;

			if ( o == null )
				return -1;

			var pdfFont: PdfFont;

			try
			{
				pdfFont = PdfFont( o );
				if ( _font != pdfFont.font )
					return 1;

				if ( size != pdfFont.size )
					return 2;

				return 0;
			}
			catch ( cce: Error )
			{
				return -2;
			}

			return -2;
		}

		public function get font(): BaseFont
		{
			return _font;
		}

		/**
		 * @param char. Possible values are int, String
		 */
		public function getWidth( char: Object = 32 ): Number
		{
			if ( _image == null )
				return font.getWidthPoint( char, _size ) * _hScale;
			return _image.scaledWidth;
		}

		public function set image( value: ImageElement ): void
		{
			_image = value;
		}

		public function get size(): Number
		{
			if ( _image == null )
				return _size;
			return _image.scaledHeight;
		}

		internal function set horizontalScaling( value: Number ): void
		{
			_hScale = value;
		}

		private static function getDefaultFont(): PdfFont
		{
			var bf: BaseFont = BaseFont.createFont( BaseFont.HELVETICA, BaseFont.WINANSI, false );
			return new PdfFont( bf, 12 );
		}
	}
}