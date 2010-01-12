package org.purepdf.pdf
{
	import it.sephiroth.utils.ObjectHash;
	
	import org.purepdf.colors.CMYKColor;
	import org.purepdf.colors.ExtendedColor;
	import org.purepdf.colors.GrayColor;
	import org.purepdf.colors.RGBColor;
	import org.purepdf.errors.RuntimeError;

	/**
	 * A PdfSpotColor defines a ColorSpace
	 */
	public class PdfSpotColor extends ObjectHash
	{
		public var altcs: RGBColor;
		public var name: PdfName;

		public function PdfSpotColor( color_name: String, alternate_cs: RGBColor )
		{
			name = new PdfName( color_name );
			altcs = alternate_cs;
		}

		/**
		 * @return the alternative colorspace
		 */
		public function get alternativeCS(): RGBColor
		{
			return altcs;
		}

		internal function getSpotObject( writer: PdfWriter ): PdfObject
		{
			var array: PdfArray = new PdfArray( PdfName.SEPARATION );
			array.add( name );
			var func: PdfFunction = null;

			if ( altcs is ExtendedColor )
			{
				var type: int = ExtendedColor( altcs ).type;

				switch ( type )
				{
					case ExtendedColor.TYPE_GRAY:
						array.add( PdfName.DEVICEGRAY );
						func = PdfFunction.type2( writer, Vector.<Number>( [ 0, 1 ] ), null, Vector.<Number>( [ 0 ] ), Vector.<Number>( [ GrayColor( altcs )
							.gray ] ), 1 );
						break;

					case ExtendedColor.TYPE_CMYK:
						array.add( PdfName.DEVICECMYK );
						var cmyk: CMYKColor = CMYKColor( altcs );
						func = PdfFunction.type2( writer, Vector.<Number>( [ 0, 1 ] ), null, Vector.<Number>( [ 0, 0, 0, 0 ] ), Vector
							.<Number>( [ cmyk.cyan, cmyk.magenta, cmyk.yellow, cmyk.black ] ), 1 );
						break;

					default:
						throw new RuntimeError( "only rgb and cmyk are supported" );
				}
			}
			else
			{
				array.add( PdfName.DEVICERGB );
				func = PdfFunction.type2( writer, Vector.<Number>( [ 0, 1 ] ), null, Vector.<Number>( [ 1, 1, 1 ] ), Vector.<Number>( [ Number( altcs
					.red ) / 255, Number( altcs.green ) / 255, Number( altcs.blue ) / 255 ] ), 1 );
			}
			array.add( func.reference );
			return array;
		}
	}
}