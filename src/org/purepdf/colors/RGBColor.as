package org.purepdf.colors
{
	import org.purepdf.utils.assertTrue;

	public class RGBColor
	{
		public static const BLACK: RGBColor =       new RGBColor( 0, 0, 0 );
		public static const BLUE: RGBColor =        new RGBColor( 0, 0, 255 );
		public static const CYAN: RGBColor =        new RGBColor( 0, 255, 255 );
		public static const DARK_GRAY: RGBColor =   new RGBColor( 64, 64, 64 );
		public static const GRAY: RGBColor =        new RGBColor( 128, 128, 128 );
		public static const GREEN: RGBColor =       new RGBColor( 0, 255, 0 );
		public static const LIGHT_GRAY: RGBColor =  new RGBColor( 192, 192, 192 );
		public static const MAGENTA: RGBColor =     new RGBColor( 255, 0, 255 );
		public static const ORANGE: RGBColor =      new RGBColor( 255, 200, 0 );
		public static const PINK: RGBColor =        new RGBColor( 255, 175, 175 );
		public static const RED: RGBColor =         new RGBColor( 255, 0, 0 );
		public static const WHITE: RGBColor =       new RGBColor( 255, 255, 255 );
		public static const YELLOW: RGBColor =      new RGBColor( 255, 255, 0 );
		private var value: int;

		public function RGBColor( red: int=0, green: int=0, blue: int=0, alpha: int=255 )
		{
			setValue( red, green, blue, alpha );
		}

		public function get alpha(): int
		{
			return ( value >> 24 ) & 0xFF;
		}

		public function get blue(): int
		{
			return ( value >> 0 ) & 0xFF;
		}

		public function equals( obj: Object ): Boolean
		{
			return obj is RGBColor && ( obj as RGBColor ).rgb == rgb;
		}

		public function get green(): int
		{
			return ( value >> 8 ) & 0xFF;
		}

		public function get red(): int
		{
			return ( value >> 16 ) & 0xFF;
		}

		public function get rgb(): int
		{
			return value;
		}

		public function setValue( red: int=0, green: int=0, blue: int=0, alpha: int=255 ): void
		{
			validate( red );
			validate( green );
			validate( blue );
			validate( alpha );
			value = ( ( alpha & 0xFF ) << 24 ) | ( ( red & 0xFF ) << 16 ) | ( ( green & 0xFF ) << 8 ) | ( ( blue & 0xFF ) << 0 );
		}

		public function validate( color: int ): void
		{
			assertTrue( color >= 0 && color <= 255, "Color outside range 0 < 255" );
		}

		public static function fromARGB( value: int ): RGBColor
		{
			var c: RGBColor = new RGBColor();
			c.value = value;
			return c;
		}
	}
}