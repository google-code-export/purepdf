package org.purepdf.colors
{
	import org.purepdf.ObjectHash;
	import org.purepdf.utils.FloatUtils;

	public class CMYKColor extends ExtendedColor
	{
		private static const serialVersionID: Number = 5940378778276468452;
		private var _cyan: Number;
		private var _magenta: Number;
		private var _yellow: Number;
		private var _black: Number;
		
		/**
		 * Construct a CMYK Color.
		 * @param floatCyan
		 * @param floatMagenta
		 * @param floatYellow
		 * @param floatBlack
		 */
		public function CMYKColor( floatCyan: Number,  floatMagenta: Number,  floatYellow: Number,  floatBlack: Number )
		{
			super( TYPE_CMYK );
			
			setValue( (1 - floatCyan)*255, ( 1 - floatMagenta )*255, (1-floatYellow-floatBlack)*255 );
			
			_cyan = normalize( floatCyan );
			_magenta = normalize( floatMagenta );
			_yellow = normalize( floatYellow );
			_black = normalize( floatBlack );
		}
		
		public function get black():Number
		{
			return _black;
		}

		public function get yellow():Number
		{
			return _yellow;
		}

		public function get magenta():Number
		{
			return _magenta;
		}

		public function get cyan():Number
		{
			return _cyan;
		}

		override public function equals( obj: ObjectHash ): Boolean
		{
			if (!(obj is CMYKColor))
				return false;
			var c2: CMYKColor = CMYKColor(obj);
			return (cyan == c2.cyan && magenta == c2.magenta && yellow == c2.yellow && black == c2.black);
		}
		
		override public function hashCode(): int
		{
			return FloatUtils.floatToIntBits(_cyan) ^ FloatUtils.floatToIntBits(_magenta) ^ FloatUtils.floatToIntBits(_yellow) ^ FloatUtils.floatToIntBits(_black); 
		}
	}
}