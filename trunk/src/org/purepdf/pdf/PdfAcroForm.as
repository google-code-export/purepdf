package org.purepdf.pdf
{
	import it.sephiroth.utils.HashMap;

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
	}
}