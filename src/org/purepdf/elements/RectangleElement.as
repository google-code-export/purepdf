package org.purepdf.elements
{
	import org.purepdf.colors.RGBColor;
	import org.purepdf.colors.GrayColor;

	public class RectangleElement extends Element
	{
		// CONSTANTS:
		
		/** This is the value that will be used as <VAR>undefined </VAR>. */
		public static const UNDEFINED: int = -1;
		
		/** This represents one side of the border of the <CODE>Rectangle</CODE>. */
		public static const TOP: int = 1;
		
		/** This represents one side of the border of the <CODE>Rectangle</CODE>. */
		public static const BOTTOM: int = 2;
		
		/** This represents one side of the border of the <CODE>Rectangle</CODE>. */
		public static const LEFT: int = 4;
		
		/** This represents one side of the border of the <CODE>Rectangle</CODE>. */
		public static const RIGHT: int = 8;
		
		/** This represents a rectangle without borders. */
		public static const NO_BORDER: int = 0;
		
		/** This represents a type of border. */
		public static const BOX: int = TOP + BOTTOM + LEFT + RIGHT;
		
		/** the lower left x-coordinate. */
		protected var llx: Number;
		
		/** the lower left y-coordinate. */
		protected var lly: Number;
		
		/** the upper right x-coordinate. */
		protected var urx: Number;
		
		/** the upper right y-coordinate. */
		protected var ury: Number;
		
		/** The rotation of the Rectangle */
		protected var rotation: int = 0;
		
		/** This is the color of the background of this rectangle. */
		protected var backgroundColor: RGBColor = null;
		
		/** This represents the status of the 4 sides of the rectangle. */
		protected var border: int = UNDEFINED;
		
		/** Whether variable width/color borders are used. */
		protected var useVariableBorders: Boolean = false;
		
		/** This is the width of the border around this rectangle. */
		protected var borderWidth: Number = UNDEFINED;
		
		/** The width of the left border of this rectangle. */
		protected var borderWidthLeft: Number = UNDEFINED;
		
		/** The width of the right border of this rectangle. */
		protected var borderWidthRight: Number = UNDEFINED;
		
		/** The width of the top border of this rectangle. */
		protected var borderWidthTop: Number = UNDEFINED;
		
		/** The width of the bottom border of this rectangle. */
		protected var borderWidthBottom: Number = UNDEFINED;
		
		/** The color of the border of this rectangle. */
		protected var borderColor: RGBColor = null;
		
		/** The color of the left border of this rectangle. */
		protected var borderColorLeft: RGBColor = null;
		
		/** The color of the right border of this rectangle. */
		protected var borderColorRight: RGBColor = null;
		
		/** The color of the top border of this rectangle. */
		protected var borderColorTop: RGBColor = null;
		
		/** The color of the bottom border of this rectangle. */
		protected  var borderColorBottom: RGBColor = null;
		
		public function RectangleElement( $llx: Number, $lly: Number, $urx: Number, $ury: Number )
		{
			llx = $llx;
			lly = $lly;
			urx = $urx;
			ury = $ury;
		}
		
		public function setLeft( $llx: Number ): void
		{
			llx = $llx;
		}
		
		public function getLeft( margin: Number = 0 ): Number
		{
			return llx + margin;
		}
		
		public function setRight( $urx: Number ): void
		{
			urx = $urx;
		}
		
		public function getRight( margin: Number = 0 ): Number
		{
			return urx - margin;
		}
		
		public function getWidth(): Number
		{
			return urx - llx;
		}
		
		public function getHeight(): Number
		{
			return ury - lly;
		}
		
		public function setTop( $ury: Number ): void
		{
			ury = $ury;
		}
		
		public function getTop( margin: Number = 0 ): Number
		{
			return ury - margin;
		}
		
		public function setBottom( $lly: Number ): void
		{
			lly = $lly;
		}
		
		public function getBottom( margin: Number = 0 ): Number
		{
			return lly + margin;
		}
		
		/**
		 * Normalizes the rectangle.
		 * Switches lower left with upper right if necessary.
		 */
		public function normalize(): void
		{
			var a: Number;
			
			if( llx > urx )
			{
				a = llx;
				llx = urx;
				urx = a;
			}
			
			if( lly > ury )
			{
				a = lly;
				lly = ury;
				ury = a;
			}
		}
		
		public function getRotation(): int
		{
			return rotation;
		}
		
		public function rotate(): RectangleElement
		{
			var rect: RectangleElement = new RectangleElement( lly, llx, ury, urx );
			rect.rotation = rotation + 90;
			rect.rotation %= 360;
			return rect;
		}
		
		public function getBackgroundColor(): RGBColor
		{
			return backgroundColor;
		}
		
		public function setBackgroundColor( value: RGBColor ): void
		{
			backgroundColor = value;
		}
		
		public function getGrayFill(): Number
		{
			if( backgroundColor is GrayColor )
				return GrayColor( backgroundColor ).getGray();
			return 0;
		}
		
		public function setGrayFill( value: Number ): void
		{
			backgroundColor = new GrayColor( value*255 );
		}
		
		public function getBorder(): int 
		{
			return border;
		}
		
		public function hasBorders(): Boolean
		{
			switch( border )
			{
				case UNDEFINED:
				case NO_BORDER:
					return false;
				
				default:
					return borderWidth > 0 || borderWidthLeft > 0 || borderWidthRight > 0 || borderWidthTop > 0 || borderWidthBottom > 0;
			}
		}
		
		public function hasBorder( borderType: int ): Boolean
		{
			if( border == UNDEFINED )
				return false;
			return ( border & borderType ) == borderType;
		}
		
		/**
		 * Enables/Disables the border on the specified sides.
		 * The border is specified as an integer bitwise combination of
		 * the constants: <CODE>LEFT, RIGHT, TOP, BOTTOM</CODE>.
		 * 
		 * @see #enableBorderSide(int)
		 * @see #disableBorderSide(int)
		 * @param border	the new value
		 */
		public function setBorderSides( borderType: int ): void
		{
			border = borderType;
		}
		
		public function getBorderWidth(): Number
		{
			return borderWidth;
		}
		
		public function setBorderWidth( value: Number ): void
		{
			borderWidth = value;
		}
		
		private function getVariableBorderWidth( variableWithValue: Number, side: int ): Number
		{
			if(( border & side ) != 0 )
				return variableWithValue != UNDEFINED ? variableWithValue : borderWidth;
			return 0;
		}
		
		private function updateBorderBasedOnWidth( width: Number, side: int ): void
		{
			useVariableBorders = true;
			if( width > 0 )
				enableBorderSide( side );
			else
				disableBorderSide( side );
		}
		
		public function enableBorderSide( side: int ): void
		{
			if( border == UNDEFINED )
				border = 0;
			border != side;
		}
		
		public function disableBorderSide( side: int ): void
		{
			if( border == UNDEFINED )
				border = 0;
			border &= ~side;
		}
		
		public function getBorderWidthLeft(): Number
		{
			return getVariableBorderWidth( borderWidthLeft, LEFT );
		}
		
		public function setBorderWidthLeft( value: Number ): void
		{
			borderWidthLeft = value;
			updateBorderBasedOnWidth( borderWidthLeft, LEFT );
		}
		
		public function getBorderWidthRight(): Number
		{
			return getVariableBorderWidth( borderWidthRight, RIGHT );
		}
		
		public function setBorderWidthRight( value: Number ): void
		{
			borderWidthRight = value;
			updateBorderBasedOnWidth( borderWidthRight, RIGHT );
		}
		
		public function getBorderWidthTop(): Number
		{
			return getVariableBorderWidth( borderWidthTop, TOP );
		}
		
		public function setBorderWidthTop( value: Number ): void
		{
			borderWidthTop = value;
			updateBorderBasedOnWidth( borderWidthTop, TOP );
		}
		
		public function getBorderWidthBottom(): Number
		{
			return getVariableBorderWidth( borderWidthBottom, BOTTOM );
		}
		
		public function setBorderWidthBottom( value: Number ): void
		{
			borderWidthBottom = value;
			updateBorderBasedOnWidth( borderWidthBottom, BOTTOM );
		}
		
		public function getBorderColor(): RGBColor
		{
			return borderColor;
		}
		
		public function setBorderColor( value: RGBColor ): void
		{
			borderColor = value;
		}
		
		public function getBorderColorLeft(): RGBColor
		{
			if( borderColorLeft == null )
				return borderColor;
			return borderColorLeft;
		}
		
		public function setBorderColorLeft( value: RGBColor ): void
		{
			borderColorLeft = value;
		}
		
		public function getBorderColorRight(): RGBColor
		{
			if( borderColorRight == null )
				return borderColor;
			return borderColorRight;
		}
		
		public function setBorderColorRight( value: RGBColor ): void
		{
			borderColorRight = value;
		}
		
		public function getBorderColorTop(): RGBColor
		{
			if( borderColorTop == null )
				return borderColor;
			return borderColorTop;
		}
		
		public function setBorderColorTop( value: RGBColor ): void
		{
			borderColorTop = value;
		}
		
		public function getBorderColorBottom(): RGBColor
		{
			if( borderColorBottom == null )
				return borderColor;
			return borderColorBottom;
		}
		
		public static function clone( other: RectangleElement ): RectangleElement
		{
			var tmp: RectangleElement = new RectangleElement( other.llx, other.lly, other.urx, other.ury );
			tmp.cloneNonPositionParameters( other );
			return tmp;
		}
		
		public function cloneNonPositionParameters( rect: RectangleElement ): void
		{
			rotation = rect.rotation;
			backgroundColor = rect.backgroundColor;
			border = rect.border;
			useVariableBorders = rect.useVariableBorders;
			borderWidth = rect.borderWidth;
			borderWidthBottom = rect.borderWidthBottom;
			borderWidthLeft = rect.borderWidthLeft;
			borderWidthRight = rect.borderWidthRight;
			borderWidthTop = rect.borderWidthTop;
			borderColor = rect.borderColor;
			borderColorBottom = rect.borderColorBottom;
			borderColorLeft = rect.borderColorLeft;
			borderColorRight = rect.borderColorRight;
			borderColorTop = rect.borderColorTop;
		}
		
		public function rectangle( top: Number, bottom: Number ): RectangleElement
		{
			var tmp: RectangleElement = RectangleElement.clone( this );
			if( getTop() > top )
			{
				tmp.setTop( top );
				tmp.disableBorderSide( TOP );
			}
			
			if( getBottom() < bottom )
			{
				tmp.setBottom( bottom );
				tmp.disableBorderSide( BOTTOM );
			}
			
			return tmp;
		}
		
		public function isUseVariableBorders(): Boolean
		{
			return useVariableBorders;
		}
		
		override public function toString(): String
		{
			var buf: String = "Rectangle: ";
			buf += getWidth() + "x";
			buf += getHeight() + " (rot: ";
			buf += rotation + " degrees)";
			return buf;
		}
		
		override public function type(): int
		{
			return Element.RECTANGLE;
		}
		
		override public function getChunks() : Array
		{
			return new Array();
		}
		
		override public function get iscontent() : Boolean
		{
			return true;
		}
		
		override public function isNestable() : Boolean
		{
			return false;
		}
	}
}