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

		override public function setBackgroundColor( value: RGBColor ): void
		{
			throwReadOnlyError();
		}

		override public function setBorderColor( value: RGBColor ): void
		{
			throwReadOnlyError();
		}

		override public function setBorderColorBottom( value: RGBColor ): void
		{
			throwReadOnlyError();
		}

		override public function setBorderColorLeft( value: RGBColor ): void
		{
			throwReadOnlyError();
		}

		override public function setBorderColorRight( value: RGBColor ): void
		{
			throwReadOnlyError();
		}

		override public function setBorderColorTop( value: RGBColor ): void
		{
			throwReadOnlyError();
		}

		override public function setBorderSides( borderType: int ): void
		{
			throwReadOnlyError();
		}

		override public function setBorderWidth( value: Number ): void
		{
			throwReadOnlyError();
		}

		override public function setBorderWidthBottom( value: Number ): void
		{
			throwReadOnlyError();
		}

		override public function setBorderWidthLeft( value: Number ): void
		{
			throwReadOnlyError();
		}

		override public function setBorderWidthRight( value: Number ): void
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