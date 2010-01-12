package org.purepdf.pdf
{
	/**
	 * A >PdfAction> defines an action that can be triggered from a PDF file.
	 */
	public class PdfAction extends PdfDictionary
	{
		public function PdfAction($type:PdfName=null)
		{
			super($type);
		}
	}
}