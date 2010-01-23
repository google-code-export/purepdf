package org.purepdf.elements
{
	import org.purepdf.utils.assertTrue;
	import org.purepdf.utils.pdf_core;

	public class HeaderFooter extends RectangleElement
	{
		private var _numbered: Boolean;
		private var _before: Phrase;
		private var _after: Phrase;
		private var _pageN: int = 0;
		private var _alignment: int;
		
		/**
		 * Header/Footer
		 * If both before and after are passed then numbered is forced to true
		 * 
		 * @throws AssertionError
		 */
		public function HeaderFooter( before: Phrase, after: Phrase = null, numbered: Boolean = true )
		{
			super(0,0,0,0);
			assertTrue( before != null, "before Phrase can't be null");
			
			border = TOP | BOTTOM;
			borderWidth = 1;
			
			this._before = before;
			this._after = after;
			this._numbered = after != null ? true : numbered;
		}
		
		public function get paragraph(): Paragraph
		{
			var p: Paragraph = Paragraph.fromChunk( null, _before.leading );
			p.add( _before );
			if( _numbered )
				p.pdf_core::addSpecial( new Chunk( _pageN.toString(), _before.font ) );
			
			if( _after != null )
				p.pdf_core::addSpecial( _after );
			
			p.alignment = _alignment;
			return p;
		}
		
		public function get alignment():int
		{
			return _alignment;
		}

		public function set alignment(value:int):void
		{
			_alignment = value;
		}

		public function get pageNumber():int
		{
			return _pageN;
		}

		public function set pageNumber(value:int):void
		{
			_pageN = value;
		}

		public function get numbered():Boolean
		{
			return _numbered;
		}

	}
}