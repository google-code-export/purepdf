package org.purepdf.pdf
{
	import it.sephiroth.utils.HashMap;
	import it.sephiroth.utils.collections.iterators.Iterator;
	
	import org.purepdf.pdf.forms.PdfFormField;
	import org.purepdf.utils.pdf_core;

	public class PdfAcroForm extends PdfDictionary
	{
		private var calculationOrder: PdfArray = new PdfArray();
		private var documentFields: PdfArray = new PdfArray();
		private var fieldTemplates: HashMap = new HashMap();
		private var sigFlags: int = 0;
		private var writer: PdfWriter;

		public function PdfAcroForm( $writer: PdfWriter )
		{
			super();
			writer = $writer;
		}

		public function addDocumentField( ref: PdfIndirectReference ): void
		{
			documentFields.add( ref );
		}

		public function addFieldTemplates( ft: HashMap ): void
		{
			fieldTemplates.putAll( ft );
		}
		
		public function get valid(): Boolean
		{
			if (documentFields.size() == 0) return false;
			put(PdfName.FIELDS, documentFields);
			if (sigFlags != 0)
				put(PdfName.SIGFLAGS, new PdfNumber(sigFlags));
			if (calculationOrder.size() > 0)
				put(PdfName.CO, calculationOrder);
			if (fieldTemplates.isEmpty()) return true;
			var dic: PdfDictionary = new PdfDictionary();
			
			for (var it: Iterator = fieldTemplates.keySet().iterator(); it.hasNext();) 
			{
				var template: PdfTemplate = PdfTemplate( it.next() );
				PdfFormField.pdf_core::mergeResources(dic, PdfDictionary(template.resources));
			}
			put(PdfName.DR, dic);
			put(PdfName.DA, new PdfString("/Helv 0 Tf 0 g "));
			var fonts: PdfDictionary = dic.getValue(PdfName.FONT) as PdfDictionary;
			if (fonts != null) {
				writer.pdf_core::eliminateFontSubset(fonts);
			}
			return true;
		}
	}
}