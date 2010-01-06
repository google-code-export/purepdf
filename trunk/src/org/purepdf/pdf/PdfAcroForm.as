package org.purepdf.pdf
{
	import org.purepdf.utils.collections.HashMap;

	public class PdfAcroForm extends PdfDictionary
	{
		private var writer: PdfWriter;
		private var fieldTemplates: HashMap = new HashMap();
		private var documentFields: PdfArray = new PdfArray();
		private var calculationOrder: PdfArray = new PdfArray();
		private var sigFlags: int = 0;
		
		public function PdfAcroForm( $writer: PdfWriter )
		{
			super();
			writer = $writer;
		}
		
		public function addFieldTemplates( ft: HashMap ): void
		{
			fieldTemplates.putAll( ft );
		}
		
		public function addDocumentField( ref: PdfIndirectReference ): void
		{
			documentFields.add( ref );
		}
	}
}