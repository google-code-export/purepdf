package org.purepdf.pdf
{
	import org.purepdf.ObjectHash;
	

	public class PdfFunction extends ObjectHash
	{
		protected var writer: PdfWriter;
		private var _reference: PdfIndirectReference;
		protected var dictionary: PdfDictionary;
		
		public function PdfFunction( $writer: PdfWriter )
		{
			writer = $writer;
		}
		
		public function get reference(): PdfIndirectReference
		{
			if( _reference == null )
				_reference = writer.addToBody( dictionary ).getIndirectReference();
			return _reference;
		}
		
		public static function type2( writer: PdfWriter, domain: Vector.<Number>, range: Vector.<Number>, c0: Vector.<Number>, c1: Vector.<Number>, n: Number ): PdfFunction
		{
			var func: PdfFunction = new PdfFunction(writer);
			func.dictionary = new PdfDictionary();
			func.dictionary.put(PdfName.FUNCTIONTYPE, new PdfNumber(2));
			func.dictionary.put(PdfName.DOMAIN, new PdfArray(domain));
			if (range != null)
				func.dictionary.put(PdfName.RANGE, new PdfArray(range));
			if (c0 != null)
				func.dictionary.put(PdfName.C0, new PdfArray(c0));
			if (c1 != null)
				func.dictionary.put(PdfName.C1, new PdfArray(c1));
			func.dictionary.put(PdfName.N, new PdfNumber(n));
			return func;
		}
	}
}