package org.purepdf.pdf.fonts
{
	import flash.utils.Dictionary;
	
	import it.sephiroth.utils.HashMap;
	
	import org.purepdf.errors.NonImplementatioError;
	import org.purepdf.pdf.PRIndirectReference;
	import org.purepdf.pdf.PdfDictionary;
	import org.purepdf.pdf.PdfIndirectReference;

	public class DocumentFont extends BaseFont
	{
		private var metrics: HashMap = new HashMap();
		private var fontName: String;
		private var _refFont: PRIndirectReference;
		private var font: PdfDictionary;
		private var uni2byte: Dictionary = new Dictionary();
		private var diffmap: Dictionary;
		private var Ascender: Number = 800;
		private var CapHeight: Number = 700;
		private var Descender: Number = -200;
		private var ItalicAngle: Number = 0;
		private var llx: Number = -50;
		private var lly: Number = -200;
		private var urx: Number = 100;
		private var ury: Number = 900;
		private var isType0: Boolean = false;
		private var cjkMirror: BaseFont;
		
		
		public function DocumentFont()
		{
			super();
			throw new NonImplementatioError();
		}
		
		public function get indirectReference(): PdfIndirectReference
		{
			return _refFont;
		}
	}
}