package org.purepdf.colors
{
	import it.sephiroth.utils.ObjectHash;
	
	import org.purepdf.pdf.PdfShadingPattern;

	public class ShadingColor extends ExtendedColor
	{
		public static const serialVersionUID: Number = 4817929454941328671;
		private var _shadingPattern: PdfShadingPattern;
		
		public function ShadingColor( pattern: PdfShadingPattern )
		{
			super( TYPE_SHADING );
			setValue( 0.5, 0.5, 0.5 );
			_shadingPattern = pattern;
		}
		
		public function get shadingPattern(): PdfShadingPattern
		{
			return _shadingPattern;
		}
		
		override public function equals( obj: ObjectHash ): Boolean
		{
			return this == obj;
		}
		
		override public function hashCode() : int
		{
			return _shadingPattern.hashCode();
		}
	}
}