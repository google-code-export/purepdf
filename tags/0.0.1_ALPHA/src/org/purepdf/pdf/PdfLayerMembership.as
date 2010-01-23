package org.purepdf.pdf
{
	import org.purepdf.pdf.interfaces.IPdfOCG;
	
	public class PdfLayerMembership extends PdfDictionary implements IPdfOCG
	{
		public function PdfLayerMembership($type:PdfName=null)
		{
			super($type);
		}
		
		public function get ref():PdfIndirectReference
		{
			return null;
		}
		
		public function get pdfObject():PdfObject
		{
			return null;
		}
	}
}