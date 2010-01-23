package org.purepdf.colors
{
	import org.purepdf.utils.FloatUtils;

	public class GrayColor extends ExtendedColor
	{
		public static const GRAYBLACK: GrayColor = new GrayColor(0);
		public static const GRAYWHITE: GrayColor = new GrayColor(1);
		
		private var _gray: Number;

		/**
		 * Example:
		 * <code>
		 * 		var color1: GrayColor = new GrayColor( 1.0 );	// create a white color;
		 * </code>
		 *
		 */
		public function GrayColor( value: Number )
		{
			super( TYPE_GRAY );
			setValue( value * 255, value * 255, value * 255 );
			_gray = normalize( value );
		}

		public function get gray(): Number
		{
			return _gray;
		}
		
		override public function hashCode() : int
		{
			return FloatUtils.floatToIntBits( _gray );
		}
	}
}