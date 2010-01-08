package org.purepdf.pdf
{
	import org.purepdf.ObjectHash;
	import org.purepdf.elements.RectangleElement;

	public class PageSize extends ObjectHash
	{
		public static const A0: RectangleElement = new RectangleElement( 0, 0, 2384, 3370 );
		public static const A1: RectangleElement = new RectangleElement( 0, 0, 1684, 2384 );
		public static const A10: RectangleElement = new RectangleElement( 0, 0, 73, 105 );
		public static const A2: RectangleElement = new RectangleElement( 0, 0, 1191, 1684 );
		public static const A3: RectangleElement = new RectangleElement( 0, 0, 842, 1191 );
		public static const A4: RectangleElement = new RectangleElement( 0, 0, 595, 842 );
		public static const A5: RectangleElement = new RectangleElement( 0, 0, 420, 595 );
		public static const A6: RectangleElement = new RectangleElement( 0, 0, 297, 420 );
		public static const A7: RectangleElement = new RectangleElement( 0, 0, 210, 297 );
		public static const A8: RectangleElement = new RectangleElement( 0, 0, 148, 210 );
		public static const A9: RectangleElement = new RectangleElement( 0, 0, 105, 148 );
		public static const ARCH_A: RectangleElement = new RectangleElement( 0, 0, 648, 864 );
		public static const ARCH_B: RectangleElement = new RectangleElement( 0, 0, 864, 1296 );
		public static const ARCH_C: RectangleElement = new RectangleElement( 0, 0, 1296, 1728 );
		public static const ARCH_D: RectangleElement = new RectangleElement( 0, 0, 1728, 2592 );
		public static const ARCH_E: RectangleElement = new RectangleElement( 0, 0, 2592, 3456 );
		public static const B0: RectangleElement = new RectangleElement( 0, 0, 2834, 4008 );
		public static const B1: RectangleElement = new RectangleElement( 0, 0, 2004, 2834 );
		public static const B10: RectangleElement = new RectangleElement( 0, 0, 87, 124 );
		public static const B2: RectangleElement = new RectangleElement( 0, 0, 1417, 2004 );
		public static const B3: RectangleElement = new RectangleElement( 0, 0, 1000, 1417 );
		public static const B4: RectangleElement = new RectangleElement( 0, 0, 708, 1000 );
		public static const B5: RectangleElement = new RectangleElement( 0, 0, 498, 708 );
		public static const B6: RectangleElement = new RectangleElement( 0, 0, 354, 498 );
		public static const B7: RectangleElement = new RectangleElement( 0, 0, 249, 354 );
		public static const B8: RectangleElement = new RectangleElement( 0, 0, 175, 249 );
		public static const B9: RectangleElement = new RectangleElement( 0, 0, 124, 175 );
		public static const CROWN_OCTAVO: RectangleElement = new RectangleElement( 0, 0, 348, 527 );
		public static const CROWN_QUARTO: RectangleElement = new RectangleElement( 0, 0, 535, 697 );
		public static const DEMY_OCTAVO: RectangleElement = new RectangleElement( 0, 0, 391, 612 );
		public static const DEMY_QUARTO: RectangleElement = new RectangleElement( 0, 0, 620, 782 );
		public static const FLSA: RectangleElement = new RectangleElement( 0, 0, 612, 936 );
		public static const FLSE: RectangleElement = new RectangleElement( 0, 0, 648, 936 );
		public static const HALFLETTER: RectangleElement = new RectangleElement( 0, 0, 396, 612 );
		public static const ID_1: RectangleElement = new RectangleElement( 0, 0, 242.65, 153 );
		public static const ID_2: RectangleElement = new RectangleElement( 0, 0, 297, 210 );
		public static const ID_3: RectangleElement = new RectangleElement( 0, 0, 354, 249 );
		public static const LARGE_CROWN_OCTAVO: RectangleElement = new RectangleElement( 0, 0, 365, 561 );
		public static const LARGE_CROWN_QUARTO: RectangleElement = new RectangleElement( 0, 0, 569, 731 );
		public static const LEDGER: RectangleElement = new RectangleElement( 0, 0, 1224, 792 );
		public static const LETTER: RectangleElement = new RectangleElement( 0, 0, 612, 792 );
		public static const PENGUIN_LARGE_PAPERBACK: RectangleElement = new RectangleElement( 0, 0, 365, 561 );
		public static const PENGUIN_SMALL_PAPERBACK: RectangleElement = new RectangleElement( 0, 0, 314, 513 );
		public static const ROYAL_OCTAVO: RectangleElement = new RectangleElement( 0, 0, 442, 663 );
		public static const ROYAL_QUARTO: RectangleElement = new RectangleElement( 0, 0, 671, 884 );
		public static const SMALL_PAPERBACK: RectangleElement = new RectangleElement( 0, 0, 314, 504 );
		public static const _11X17: RectangleElement = new RectangleElement( 0, 0, 792, 1224 );

		public static function create( pixelsw: int, pixelsh: int ): RectangleElement
		{
			return new RectangleElement( 0, 0, pixelsw, pixelsh );
		}
	}
}