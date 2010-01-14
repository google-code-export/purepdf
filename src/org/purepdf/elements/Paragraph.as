package org.purepdf.elements
{
	import org.purepdf.Font;

	public class Paragraph extends Phrase
	{
		private static const serialVersionUID: Number = 7852314969733375514;

		protected var _alignment: int = Element.ALIGN_UNDEFINED;
		protected var _indentationLeft: Number = 0;
		protected var _indentationRight: Number = 0;
		protected var _keeptogether: Boolean = false;
		protected var _multipliedLeading: Number = 0;
		protected var _spacingAfter: Number = 0;
		protected var _spacingBefore: Number = 0;
		private var _extraParagraphSpace: Number = 0;
		private var _firstLineIndent: Number = 0;

		public function Paragraph()
		{
			super();
		}
		
		override public function type() : int
		{
			return PARAGRAPH;
		}
		
		public function get totalLeading(): Number
		{
			var m: Number = _font == null ? Font.DEFAULTSIZE * _multipliedLeading : font.getCalculatedLeading( _multipliedLeading );
			if( m > 0 && !hasLeading() )
				return m;
			return leading + m;
		}
		
		public function get extraParagraphSpace():Number
		{
			return _extraParagraphSpace;
		}

		public function get keeptogether():Boolean
		{
			return _keeptogether;
		}

		public function get alignment():int
		{
			return _alignment;
		}

		public function get multipliedLeading():Number
		{
			return _multipliedLeading;
		}

		public function get indentationRight():Number
		{
			return _indentationRight;
		}

		public function get indentationLeft():Number
		{
			return _indentationLeft;
		}

		public function get firstLineIndent():Number
		{
			return _firstLineIndent;
		}

		public function get spacingBefore(): Number
		{
			return _spacingBefore;
		}
		
		public function get spacingAfter(): Number
		{
			return _spacingAfter;
		}
			

		public static function create( string: String, font: Font = null ): Paragraph
		{
			var p: Paragraph = new Paragraph();
			p.init( Number.NaN, string, font != null ? font : new Font() );
			return p;
		}
	}
}