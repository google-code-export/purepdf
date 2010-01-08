package org.purepdf.pdf
{
	import org.purepdf.ObjectHash;
	import org.purepdf.elements.RectangleElement;
	
	public class PageSize extends ObjectHash
	{
		public static const A0: RectangleElement = new RectangleElement( 0, 0, 2384, 3370 );
		public static const A1: RectangleElement = new RectangleElement( 0, 0, 1684, 2384 );
		public static const A2: RectangleElement = new RectangleElement( 0, 0, 1191, 1684 );
		public static const A3: RectangleElement = new RectangleElement( 0, 0, 842, 1191 );
		public static const A4: RectangleElement = new RectangleElement( 0, 0, 595, 842 );
		public static const LETTER: RectangleElement = new RectangleElement( 0, 0, 612, 792 );
		
		public static function create( pixelsw: int, pixelsh: int ): RectangleElement
		{
			return new RectangleElement( 0, 0, pixelsw, pixelsh );
		}
	}
}