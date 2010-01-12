package org.purepdf.elements
{
	import org.purepdf.Font;

	public class Paragraph extends Phrase
	{
		private static const serialVersionUID: Number = 7852314969733375514;
		
		protected var alignment: int = Element.ALIGN_UNDEFINED;
		protected var multipliedLeading: Number = 0;
		protected var indentationLeft: Number;
		protected var indentationRight: Number;
		private var firstLineIndent: Number = 0;
		protected var spacingBefore: Number;
		protected var spacingAfter: Number;
		private var extraParagraphSpace: Number = 0;
		protected var keeptogether: Boolean = false;
		
		public function Paragraph()
		{
			super();
		}
		
		public static function create( string: String ): Paragraph
		{
			var p: Paragraph = new Paragraph();
			p.init( Number.NaN, string, new Font() );
			return p;
		}
	}
}