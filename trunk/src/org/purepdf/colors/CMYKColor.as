package org.purepdf.colors
{
	import it.sephiroth.utils.ObjectHash;
	import org.purepdf.utils.FloatUtils;

	public class CMYKColor extends ExtendedColor
	{
		private static const serialVersionID: Number = 5940378778276468452;
		private var _black: Number;
		private var _cyan: Number;
		private var _magenta: Number;
		private var _yellow: Number;

		/**
		 * Construct a CMYK Color.
		 * @param floatCyan			Number bewteen 0 and 1
		 * @param floatMagenta		Number bewteen 0 and 1
		 * @param floatYellow		Number bewteen 0 and 1
		 * @param floatBlack		Number bewteen 0 and 1
		 */
		public function CMYKColor( floatCyan: Number, floatMagenta: Number, floatYellow: Number, floatBlack: Number )
		{
			super( TYPE_CMYK );
			setValue( normalize( 1 - floatCyan - floatBlack ) * 255, normalize( 1 - floatMagenta - floatBlack ) * 255, normalize( 1 - floatYellow -
							floatBlack ) * 255 );
			_cyan = normalize( floatCyan );
			_magenta = normalize( floatMagenta );
			_yellow = normalize( floatYellow );
			_black = normalize( floatBlack );
		}

		public function get black(): Number
		{
			return _black;
		}

		public function get cyan(): Number
		{
			return _cyan;
		}

		override public function equals( obj: Object ): Boolean
		{
			if ( !( obj is CMYKColor ) )
				return false;
			var c2: CMYKColor = CMYKColor( obj );
			return ( cyan == c2.cyan && magenta == c2.magenta && yellow == c2.yellow && black == c2.black );
		}

		override public function hashCode(): int
		{
			return FloatUtils.floatToIntBits( _cyan ) ^ FloatUtils.floatToIntBits( _magenta ) ^ FloatUtils.
							floatToIntBits( _yellow ) ^ FloatUtils.floatToIntBits( _black );
		}

		public function get magenta(): Number
		{
			return _magenta;
		}

		public function get yellow(): Number
		{
			return _yellow;
		}
	}
}