package org.purepdf.elements
{
	import org.purepdf.colors.RGBColor;
	import org.purepdf.errors.UnsupportedOperationError;

	public class ReadOnlyRectangle extends RectangleElement
	{
		public function ReadOnlyRectangle( $llx: Number, $lly: Number, $urx: Number, $ury: Number )
		{
			super( $llx, $lly, $urx, $ury );
		}

		override public function disableBorderSide( side: int ): void
		{

			throwReadOnlyError();
		}

		override public function enableBorderSide( side: int ): void
		{
			throwReadOnlyError();
		}

		override public function normalize(): void
		{
			throwReadOnlyError();
		}

		override public function set backgroundColor( value: RGBColor ): void
		{
			throwReadOnlyError();
		}

		override public function set borderColor( value: RGBColor ): void
		{
			throwReadOnlyError();
		}

		override public function set borderColorBottom( value: RGBColor ): void
		{
			throwReadOnlyError();
		}

		override public function set borderColorLeft( value: RGBColor ): void
		{
			throwReadOnlyError();
		}

		override public function set borderColorRight( value: RGBColor ): void
		{
			throwReadOnlyError();
		}

		override public function set borderColorTop( value: RGBColor ): void
		{
			throwReadOnlyError();
		}

		override public function set borderSides( borderType: int ): void
		{
			throwReadOnlyError();
		}

		override public function set borderWidth( value: Number ): void
		{
			throwReadOnlyError();
		}

		override public function set borderWidthBottom( value: Number ): void
		{
			throwReadOnlyError();
		}

		override public function set borderWidthLeft( value: Number ): void
		{
			throwReadOnlyError();
		}

		override public function set borderWidthRight( value: Number ): void
		{
			throwReadOnlyError();
		}

		override public function setBottom( $lly: Number ): void
		{
			throwReadOnlyError();
		}

		override public function setGrayFill( value: Number ): void
		{
			throwReadOnlyError();
		}

		override public function setLeft( $llx: Number ): void
		{
			throwReadOnlyError();
		}

		override public function setRight( $urx: Number ): void
		{
			throwReadOnlyError();
		}

		override public function setTop( $ury: Number ): void
		{
			throwReadOnlyError();
		}

		private function throwReadOnlyError(): void
		{
			throw new UnsupportedOperationError( "This Rectangle is read-only" );
		}
	}
}