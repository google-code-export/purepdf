package org.purepdf.elements
{
	import org.purepdf.Font;
	import org.purepdf.elements.images.ImageElement;

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

		public function Paragraph( phrase: Phrase = null )
		{
			super( phrase );
			
			if (phrase is Paragraph )
			{
				var p: Paragraph = Paragraph(phrase);
				_alignment = p.alignment;
				setLeading( phrase.leading, p.multipliedLeading );
				
				_indentationLeft = p.indentationLeft;
				_indentationRight = p.indentationRight;
				_firstLineIndent = p.firstLineIndent;
				_spacingAfter = p.spacingAfter;
				_spacingBefore = p.spacingBefore;
				_extraParagraphSpace = p.extraParagraphSpace;
			}
		}
		
		override public function add(o:Object) : Boolean
		{
			if (o is List) 
			{
				var list: List = List(o);
				list.indentationLeft =  list.indentationLeft + indentationLeft;
				list.indentationRight = indentationRight;
				return super.add(list);
			}
			else if (o is ImageElement ) {
				super.addSpecial(o);
				return true;
			}
			else if (o is Paragraph) {
				super.add(o);
				var chunks: Vector.<Object> = getChunks();
				if (!(chunks.length == 0)) {
					var tmp: Chunk = Chunk(chunks[chunks.length - 1]);
					super.add( new Chunk("\n", tmp.font) );
				}
				else {
					super.add( Chunk.NEWLINE );
				}
				return true;
			}
			return super.add(o);
		}

		public function get alignment(): int
		{
			return _alignment;
		}

		public function get extraParagraphSpace(): Number
		{
			return _extraParagraphSpace;
		}

		public function get firstLineIndent(): Number
		{
			return _firstLineIndent;
		}

		public function get indentationLeft(): Number
		{
			return _indentationLeft;
		}

		public function get indentationRight(): Number
		{
			return _indentationRight;
		}

		public function get keeptogether(): Boolean
		{
			return _keeptogether;
		}

		public function get multipliedLeading(): Number
		{
			return _multipliedLeading;
		}

		public function get spacingAfter(): Number
		{
			return _spacingAfter;
		}

		public function get spacingBefore(): Number
		{
			return _spacingBefore;
		}

		public function get totalLeading(): Number
		{
			var m: Number = _font == null ? Font.DEFAULTSIZE * _multipliedLeading : font.getCalculatedLeading( _multipliedLeading );

			if ( m > 0 && !hasLeading )
				return m;
			return leading + m;
		}

		override public function get type(): int
		{
			return Element.PARAGRAPH;
		}
		
		public function setLeading( fixedLeading: Number, multipliedLeading: Number ): void
		{
			_leading = fixedLeading;
			_multipliedLeading = multipliedLeading;
		}

		/**
		 * Create a new Paragraph from a string and an optional font.
		 * If no font is passed, the pdf default one will be used
		 */
		public static function create( string: String, font: Font=null ): Paragraph
		{
			var p: Paragraph = new Paragraph();
			p.init( Number.NaN, string, font != null ? font : new Font() );
			return p;
		}
	}
}