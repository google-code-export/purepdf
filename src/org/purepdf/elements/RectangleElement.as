package org.purepdf.elements
{
	import org.purepdf.colors.GrayColor;
	import org.purepdf.colors.RGBColor;

	public class RectangleElement extends Element implements IElement
	{
		public static const BOTTOM: int = 2;
		public static const LEFT: int = 4;
		public static const NO_BORDER: int = 0;
		public static const RIGHT: int = 8;
		public static const TOP: int = 1;
		public static const ALL: int = TOP | BOTTOM | LEFT | RIGHT;
		public static const UNDEFINED: int = -1;
		protected var _backgroundColor: RGBColor = null;
		protected var _border: int = UNDEFINED;
		protected var _borderColor: RGBColor = null;
		protected var _borderColorBottom: RGBColor = null;
		protected var _borderColorLeft: RGBColor = null;
		protected var _borderColorRight: RGBColor = null;
		protected var _borderColorTop: RGBColor = null;
		protected var _borderWidth: Number = UNDEFINED;
		protected var _borderWidthBottom: Number = UNDEFINED;
		protected var _borderWidthLeft: Number = UNDEFINED;
		protected var _borderWidthRight: Number = UNDEFINED;
		protected var _borderWidthTop: Number = UNDEFINED;
		protected var llx: Number;
		protected var lly: Number;
		protected var _rotation: int = 0;
		protected var urx: Number;
		protected var ury: Number;
		protected var _useVariableBorders: Boolean = false;

		public function RectangleElement( $llx: Number, $lly: Number, $urx: Number, $ury: Number )
		{
			llx = $llx;
			lly = $lly;
			urx = $urx;
			ury = $ury;
		}

		public function cloneNonPositionParameters( rect: RectangleElement ): void
		{
			_rotation = rect._rotation;
			_backgroundColor = rect._backgroundColor;
			_border = rect._border;
			_useVariableBorders = rect._useVariableBorders;
			_borderWidth = rect._borderWidth;
			_borderWidthBottom = rect._borderWidthBottom;
			_borderWidthLeft = rect._borderWidthLeft;
			_borderWidthRight = rect._borderWidthRight;
			_borderWidthTop = rect._borderWidthTop;
			_borderColor = rect._borderColor;
			_borderColorBottom = rect._borderColorBottom;
			_borderColorLeft = rect._borderColorLeft;
			_borderColorRight = rect._borderColorRight;
			_borderColorTop = rect._borderColorTop;
		}

		public function disableBorderSide( side: int ): void
		{
			if ( _border == UNDEFINED )
				_border = 0;
			_border &= ~side;
		}

		public function enableBorderSide( side: int ): void
		{
			if ( _border == UNDEFINED )
				_border = 0;
			_border != side;
		}

		public function get backgroundColor(): RGBColor
		{
			return _backgroundColor;
		}

		public function get border(): int
		{
			return _border;
		}

		public function get borderColor(): RGBColor
		{
			return _borderColor;
		}

		public function get borderColorBottom(): RGBColor
		{
			if ( _borderColorBottom == null )
				return _borderColor;
			return _borderColorBottom;
		}

		public function get borderColorLeft(): RGBColor
		{
			if ( _borderColorLeft == null )
				return _borderColor;
			return _borderColorLeft;
		}

		public function get borderColorRight(): RGBColor
		{
			if ( _borderColorRight == null )
				return _borderColor;
			return _borderColorRight;
		}

		public function get borderColorTop(): RGBColor
		{
			if ( _borderColorTop == null )
				return _borderColor;
			return _borderColorTop;
		}

		public function get borderWidth(): Number
		{
			return _borderWidth;
		}

		public function get borderWidthBottom(): Number
		{
			return getVariableBorderWidth( _borderWidthBottom, BOTTOM );
		}

		public function get borderWidthLeft(): Number
		{
			return getVariableBorderWidth( _borderWidthLeft, LEFT );
		}

		public function get borderWidthRight(): Number
		{
			return getVariableBorderWidth( _borderWidthRight, RIGHT );
		}

		public function get borderWidthTop(): Number
		{
			return getVariableBorderWidth( _borderWidthTop, TOP );
		}

		public function getBottom( margin: Number=0 ): Number
		{
			return lly + margin;
		}

		override public function getChunks(): Vector.<Object>
		{
			return new Vector.<Object>();
		}

		public function get grayFill(): Number
		{
			if ( _backgroundColor is GrayColor )
				return GrayColor( _backgroundColor ).gray;
			return 0;
		}

		public function get height(): Number
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

		public function get rotation(): int
		{
			return _rotation;
		}

		public function getTop( margin: Number=0 ): Number
		{
			return ury - margin;
		}

		public function get width(): Number
		{
			return urx - llx;
		}

		public function hasBorder( borderType: int ): Boolean
		{
			if ( _border == UNDEFINED )
				return false;
			return ( _border & borderType ) == borderType;
		}

		public function hasBorders(): Boolean
		{
			switch ( _border )
			{
				case UNDEFINED:
				case NO_BORDER:
					return false;
				default:
					return _borderWidth > 0 || _borderWidthLeft > 0 || _borderWidthRight > 0 || _borderWidthTop > 0 || _borderWidthBottom
						> 0;
			}
		}

		override public function get isNestable(): Boolean
		{
			return false;
		}

		public function isUseVariableBorders(): Boolean
		{
			return _useVariableBorders;
		}

		override public function get isContent(): Boolean
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
			rect._rotation = _rotation + 90;
			rect._rotation %= 360;
			return rect;
		}

		public function setBackgroundColor( value: RGBColor ): void
		{
			_backgroundColor = value;
		}

		public function setBorderColor( value: RGBColor ): void
		{
			_borderColor = value;
		}

		public function setBorderColorLeft( value: RGBColor ): void
		{
			_borderColorLeft = value;
		}

		public function setBorderColorRight( value: RGBColor ): void
		{
			_borderColorRight = value;
		}

		public function setBorderColorTop( value: RGBColor ): void
		{
			_borderColorTop = value;
		}
		
		public function setBorderColorBottom( value: RGBColor ): void
		{
			_borderColorBottom = value;
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
			_border = borderType;
		}

		public function setBorderWidth( value: Number ): void
		{
			_borderWidth = value;
		}

		public function setBorderWidthBottom( value: Number ): void
		{
			_borderWidthBottom = value;
			updateBorderBasedOnWidth( _borderWidthBottom, BOTTOM );
		}

		public function setBorderWidthLeft( value: Number ): void
		{
			_borderWidthLeft = value;
			updateBorderBasedOnWidth( _borderWidthLeft, LEFT );
		}

		public function setBorderWidthRight( value: Number ): void
		{
			_borderWidthRight = value;
			updateBorderBasedOnWidth( _borderWidthRight, RIGHT );
		}

		public function setBorderWidthTop( value: Number ): void
		{
			_borderWidthTop = value;
			updateBorderBasedOnWidth( _borderWidthTop, TOP );
		}

		public function setBottom( $lly: Number ): void
		{
			lly = $lly;
		}

		public function setGrayFill( value: Number ): void
		{
			_backgroundColor = new GrayColor( value * 255 );
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
			buf += width + "x";
			buf += height + " (rot: ";
			buf += _rotation + " degrees)";
			return buf;
		}

		override public function get type(): int
		{
			return Element.RECTANGLE;
		}

		private function getVariableBorderWidth( variableWithValue: Number, side: int ): Number
		{
			if ( ( _border & side ) != 0 )
				return variableWithValue != UNDEFINED ? variableWithValue : _borderWidth;
			return 0;
		}

		private function updateBorderBasedOnWidth( width: Number, side: int ): void
		{
			_useVariableBorders = true;

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