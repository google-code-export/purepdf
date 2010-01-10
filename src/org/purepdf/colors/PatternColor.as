package org.purepdf.colors
{
	import it.sephiroth.utils.ObjectHash;
	
	import org.purepdf.pdf.PdfPatternPainter;

	public class PatternColor extends ExtendedColor
	{
		private var _painter: PdfPatternPainter;

		public function PatternColor( p: PdfPatternPainter )
		{
			super( TYPE_PATTERN );
			setValue( 127, 127, 127 );
			_painter = p;
		}

		override public function equals( obj: ObjectHash ): Boolean
		{
			return this == obj;
		}

		override public function hashCode(): int
		{
			return _painter.hashCode();
		}

		public function get painter(): PdfPatternPainter
		{
			return _painter;
		}
	}
}