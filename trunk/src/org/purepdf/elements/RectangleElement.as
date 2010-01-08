package org.purepdf.elements
{
	import org.purepdf.colors.GrayColor;
	import org.purepdf.colors.RGBColor;

	public class RectangleElement extends Element
	{
		public static const BOTTOM: int = 2;
		public static const BOX: int = TOP + BOTTOM + LEFT + RIGHT;
		public static const LEFT: int = 4;
		public static const NO_BORDER: int = 0;
		public static const RIGHT: int = 8;
		public static const TOP: int = 1;
		public static const ALL: int = TOP | BOTTOM | LEFT | RIGHT;
		public static const UNDEFINED: int = -1;
		protected var backgroundColor: RGBColor = null;
		protected var border: int = UNDEFINED;
		protected var borderColor: RGBColor = null;
		protected var borderColorBottom: RGBColor = null;
		protected var borderColorLeft: RGBColor = null;
		protected var borderColorRight: RGBColor = null;
		protected var borderColorTop: RGBColor = null;
		protected var borderWidth: Number = UNDEFINED;
		protected var borderWidthBottom: Number = UNDEFINED;
		protected var borderWidthLeft: Number = UNDEFINED;
		protected var borderWidthRight: Number = UNDEFINED;
		protected var borderWidthTop: Number = UNDEFINED;
		protected var llx: Number;
		protected var lly: Number;
		protected var rotation: int = 0;
		protected var urx: Number;
		protected var ury: Number;
		protected var useVariableBorders: Boolean = false;

		public function RectangleElement( $llx: Number, $lly: Number, $urx: Number, $ury: Number )
		{
			llx = $llx;
			lly = $lly;
			urx = $urx;
			ury = $ury;
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

		public function disableBorderSide( side: int ): void
		{
			if ( border == UNDEFINED )
				border = 0;
			border &= ~side;
		}

		public function enableBorderSide( side: int ): void
		{
			if ( border == UNDEFINED )
				border = 0;
			border != side;
		}

		public function getBackgroundColor(): RGBColor
		{
			return backgroundColor;
		}

		public function getBorder(): int
		{
			return border;
		}

		public function getBorderColor(): RGBColor
		{
			return borderColor;
		}

		public function getBorderColorBottom(): RGBColor
		{
			if ( borderColorBottom == null )
				return borderColor;
			return borderColorBottom;
		}

		public function getBorderColorLeft(): RGBColor
		{
			if ( borderColorLeft == null )
				return borderColor;
			return borderColorLeft;
		}

		public function getBorderColorRight(): RGBColor
		{
			if ( borderColorRight == null )
				return borderColor;
			return borderColorRight;
		}

		public function getBorderColorTop(): RGBColor
		{
			if ( borderColorTop == null )
				return borderColor;
			return borderColorTop;
		}

		public function getBorderWidth(): Number
		{
			return borderWidth;
		}

		public function getBorderWidthBottom(): Number
		{
			return getVariableBorderWidth( borderWidthBottom, BOTTOM );
		}

		public function getBorderWidthLeft(): Number
		{
			return getVariableBorderWidth( borderWidthLeft, LEFT );
		}

		public function getBorderWidthRight(): Number
		{
			return getVariableBorderWidth( borderWidthRight, RIGHT );
		}

		public function getBorderWidthTop(): Number
		{
			return getVariableBorderWidth( borderWidthTop, TOP );
		}

		public function getBottom( margin: Number=0 ): Number
		{
			return lly + margin;
		}

		override public function getChunks(): Array
		{
			return new Array();
		}

		public function getGrayFill(): Number
		{
			if ( backgroundColor is GrayColor )
				return GrayColor( backgroundColor ).gray;
			return 0;
		}

		public function getHeight(): Number
		{
			return ury - lly;
		}

		public function getLeft( margin: Number=0 ): Number
		{
			return llx + margin;
		}

		public function getRight( margin: Number=0 ): Number
		{
			return urx - margin;
		}

		public function getRotation(): int
		{
			return rotation;
		}

		public function getTop( margin: Number=0 ): Number
		{
			return ury - margin;
		}

		public function getWidth(): Number
		{
			return urx - llx;
		}

		public function hasBorder( borderType: int ): Boolean
		{
			if ( border == UNDEFINED )
				return false;
			return ( border & borderType ) == borderType;
		}

		public function hasBorders(): Boolean
		{
			switch ( border )
			{
				case UNDEFINED:
				case NO_BORDER:
					return false;
				default:
					return borderWidth > 0 || borderWidthLeft > 0 || borderWidthRight > 0 || borderWidthTop > 0 || borderWidthBottom
						> 0;
			}
		}

		override public function isNestable(): Boolean
		{
			return false;
		}

		public function isUseVariableBorders(): Boolean
		{
			return useVariableBorders;
		}

		override public function get iscontent(): Boolean
		{
			return true;
		}

		/**
		 * Normalizes the rectangle.
		 * Switches lower left with upper right if necessary.
		 */
		public function normalize(): void
		{
			var a: Number;

			if ( llx > urx )
			{
				a = llx;
				llx = urx;
				urx = a;
			}

			if ( lly > ury )
			{
				a = lly;
				lly = ury;
				ury = a;
			}
		}

		public function rectangle( top: Number, bottom: Number ): RectangleElement
		{
			var tmp: RectangleElement = RectangleElement.clone( this );

			if ( getTop() > top )
			{
				tmp.setTop( top );
				tmp.disableBorderSide( TOP );
			}

			if ( getBottom() < bottom )
			{
				tmp.setBottom( bottom );
				tmp.disableBorderSide( BOTTOM );
			}
			return tmp;
		}

		public function rotate(): RectangleElement
		{
			var rect: RectangleElement = new RectangleElement( lly, llx, ury, urx );
			rect.rotation = rotation + 90;
			rect.rotation %= 360;
			return rect;
		}

		public function setBackgroundColor( value: RGBColor ): void
		{
			backgroundColor = value;
		}

		public function setBorderColor( value: RGBColor ): void
		{
			borderColor = value;
		}

		public function setBorderColorLeft( value: RGBColor ): void
		{
			borderColorLeft = value;
		}

		public function setBorderColorRight( value: RGBColor ): void
		{
			borderColorRight = value;
		}

		public function setBorderColorTop( value: RGBColor ): void
		{
			borderColorTop = value;
		}

		/**
		 * Enables/Disables the border on the specified sides.
		 * The border is specified as an integer bitwise combination of
		 * the constants: <CODE>LEFT, RIGHT, TOP, BOTTOM, ALL</CODE>.
		 *
		 * @see #enableBorderSide(int)
		 * @see #disableBorderSide(int)
		 * @param border	the new value
		 */
		public function setBorderSides( borderType: int ): void
		{
			border = borderType;
		}

		public function setBorderWidth( value: Number ): void
		{
			borderWidth = value;
		}

		public function setBorderWidthBottom( value: Number ): void
		{
			borderWidthBottom = value;
			updateBorderBasedOnWidth( borderWidthBottom, BOTTOM );
		}

		public function setBorderWidthLeft( value: Number ): void
		{
			borderWidthLeft = value;
			updateBorderBasedOnWidth( borderWidthLeft, LEFT );
		}

		public function setBorderWidthRight( value: Number ): void
		{
			borderWidthRight = value;
			updateBorderBasedOnWidth( borderWidthRight, RIGHT );
		}

		public function setBorderWidthTop( value: Number ): void
		{
			borderWidthTop = value;
			updateBorderBasedOnWidth( borderWidthTop, TOP );
		}

		public function setBottom( $lly: Number ): void
		{
			lly = $lly;
		}

		public function setGrayFill( value: Number ): void
		{
			backgroundColor = new GrayColor( value * 255 );
		}

		public function setLeft( $llx: Number ): void
		{
			llx = $llx;
		}

		public function setRight( $urx: Number ): void
		{
			urx = $urx;
		}

		public function setTop( $ury: Number ): void
		{
			ury = $ury;
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

		private function getVariableBorderWidth( variableWithValue: Number, side: int ): Number
		{
			if ( ( border & side ) != 0 )
				return variableWithValue != UNDEFINED ? variableWithValue : borderWidth;
			return 0;
		}

		private function updateBorderBasedOnWidth( width: Number, side: int ): void
		{
			useVariableBorders = true;

			if ( width > 0 )
				enableBorderSide( side );
			else
				disableBorderSide( side );
		}

		public static function clone( other: RectangleElement ): RectangleElement
		{
			var tmp: RectangleElement = new RectangleElement( other.llx, other.lly, other.urx, other.ury );
			tmp.cloneNonPositionParameters( other );
			return tmp;
		}
	}
}