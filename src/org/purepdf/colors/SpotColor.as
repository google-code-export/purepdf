package org.purepdf.colors
{
	import it.sephiroth.utils.ObjectHash;
	
	import org.purepdf.pdf.PdfSpotColor;
	import org.purepdf.utils.FloatUtils;

	public class SpotColor extends ExtendedColor
	{
		private static const serialVersionUID: Number = -6257004582113248079;
		private var _spot: PdfSpotColor;
		private var _tint: Number;

		public function SpotColor( $spot: PdfSpotColor, $tint: Number ) 
		{
			super( TYPE_SEPARATION );
			
			var r: Number = normalize( ( Number( $spot.alternativeCS.red ) / 255 - 1 ) * $tint + 1 );
			var g: Number = normalize( ( Number( $spot.alternativeCS.green ) / 255 - 1 ) * $tint + 1 );
			var b: Number = normalize( ( Number( $spot.alternativeCS.blue ) / 255 - 1 ) * $tint + 1 );
			
			setValue( r*255, g*255, b*255 );
			
			_spot = $spot;
			_tint = $tint;
		}

		public function get pdfSpotColor():PdfSpotColor {
			return _spot;
		}
		
		public function get tint():Number
		{
			return _tint;
		}
		
		override public function equals( obj: Object ):Boolean
		{
			return this == obj;
		}
		
		override public function hashCode():int
		{
			return _spot.hashCode() ^ FloatUtils.floatToIntBits( _tint );
		}
	}
}