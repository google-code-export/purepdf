package org.purepdf.colors
{

	public class ExtendedColor extends RGBColor
	{
		public static const TYPE_CMYK: int = 2;
		public static const TYPE_GRAY: int = 1;
		public static const TYPE_PATTERN: int = 4;
		public static const TYPE_RGB: int = 0;
		public static const TYPE_SEPARATION: int = 3;
		public static const TYPE_SHADING: int = 5;
		protected var type: int;

		public function ExtendedColor( $type: int )
		{
			super( 0, 0, 0 );
			type = $type;
		}

		public function getType(): int
		{
			return type;
		}

		public static function getType( color: RGBColor ): int
		{
			if ( color is ExtendedColor )
				return ExtendedColor( color ).getType();
			return TYPE_RGB;
		}

		public static function normalize( value: Number ): Number
		{
			if ( value < 0 )
				return 0;

			if ( value > 1 )
				return 1;
			return value;
		}
	}
}