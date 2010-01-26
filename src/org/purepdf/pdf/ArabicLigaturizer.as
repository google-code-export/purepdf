package org.purepdf.pdf
{
	import org.purepdf.errors.NonImplementatioError;

	public class ArabicLigaturizer
	{
		public static const DIGITS_MASK: int = 0xe0;
		public static const DIGIT_TYPE_MASK: int = 0x0100; // 0x3f00?
		public static const DIGITS_EN2AN: int = 0x20;
		public static const DIGITS_AN2EN: int = 0x40;
		public static const DIGITS_EN2AN_INIT_LR: int = 0x60;
		public static const DIGITS_EN2AN_INIT_AL: int = 0x80;
		public static const DIGIT_TYPE_AN: int = 0;
		public static const DIGIT_TYPE_AN_EXTENDED: int = 0x100;

		public function ArabicLigaturizer()
		{
		}

		static public function processNumbers( text: Vector.<int>, offset: int, length: int, options: int ): void
		{
			var limit: int = offset + length;
			var i: int;
			var ch: int;
			var digitTop: int;
			var digitDelta: int;
			var digitBase: int;

			if ( ( options & DIGITS_MASK ) != 0 )
			{
				digitBase = 48; // European digits

				switch ( options & DIGIT_TYPE_MASK )
				{
					case DIGIT_TYPE_AN:
						digitBase = 1632; // Arabic-Indic digits
						break;
					case DIGIT_TYPE_AN_EXTENDED:
						digitBase = 1776; // Eastern Arabic-Indic digits (Persian and Urdu)
						break;
					default:
						break;
				}

				switch ( options & DIGITS_MASK )
				{
					case DIGITS_EN2AN:
						digitDelta = digitBase - 48;
						for ( i = offset; i < limit; ++i )
						{
							ch = text[i];
							if ( ch <= 57 && ch >= 48 )
								text[i] += digitDelta;
						}
						break;
					
					case DIGITS_AN2EN:
						digitTop = ( digitBase + 9 );
						digitDelta = 48 - digitBase;

						for ( i = offset; i < limit; ++i )
						{
							ch = text[i];
							if ( ch <= digitTop && ch >= digitBase )
								text[i] += digitDelta;
						}
						break;
					
					case DIGITS_EN2AN_INIT_LR:
						throw new NonImplementatioError("DIGITS_EN2AN_INIT_LR not yet implemented");
						break;
					case DIGITS_EN2AN_INIT_AL:
						throw new NonImplementatioError("DIGITS_EN2AN_INIT_AL not yet implemented");
						break;
					default:
						break;
				}
			}
		}
	}
}