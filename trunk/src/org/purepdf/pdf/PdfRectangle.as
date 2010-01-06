package org.purepdf.pdf
{
	import org.purepdf.elements.RectangleElement;
	

	public class PdfRectangle extends PdfArray
	{
		private var llx: Number = 0;
		private var lly: Number = 0;
		private var urx: Number = 0;
		private var ury: Number = 0;
		
		public function PdfRectangle( $llx: Number, $lly: Number, $urx: Number, $ury: Number, rotation: int = 0 )
		{
			super();
			
			if( rotation == 90 || rotation == 270 )
			{
				llx = $lly;
				lly = $llx;
				urx = $ury;
				ury = $urx;
			} else 
			{
				llx = $llx;
				lly = $lly;
				urx = $urx;
				ury = $ury;
			}
			
			super.add( new PdfNumber( llx ) );
			super.add( new PdfNumber( lly ) );
			super.add( new PdfNumber( urx ) );
			super.add( new PdfNumber( ury ) );
		}
		
		public static function createFromRectangle( rect: RectangleElement ): PdfRectangle
		{
			return new PdfRectangle( rect.getLeft(), rect.getBottom(), rect.getRight(), rect.getTop(), 0 );
		}
		
		override public function toString(): String
		{
			return "[" + llx + ", " + lly + ", " + urx + ", " + ury + "]";
		}
		
		public function getRectangle(): RectangleElement
		{
			return new RectangleElement( left, bottom, right, top );
		}
		
		override public function add(object:PdfObject) : uint
		{
			return 0;
		}
		
		public function get left(): Number
		{
			return llx;
		}
		
		public function get right(): Number
		{
			return urx;
		}
		
		public function get top(): Number
		{
			return ury;
		}
		
		public function get bottom(): Number
		{
			return lly;
		}
		
		public function get width(): Number
		{
			return urx - llx;
		}
		
		public function get height(): Number
		{
			return ury - lly;
		}
		
		public function rotate(): PdfRectangle 
		{
			return new PdfRectangle( lly, llx, ury, urx, 0 );
		}
		
		public static function create( rectangle: RectangleElement, rotation: int = 0 ): PdfRectangle
		{
			return new PdfRectangle( rectangle.getLeft(), rectangle.getBottom(), rectangle.getRight(), rectangle.getTop(), rotation );
		}
		
		
	}
}