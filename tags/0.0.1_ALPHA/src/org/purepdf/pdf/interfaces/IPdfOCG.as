package org.purepdf.pdf.interfaces
{
	import org.purepdf.pdf.PdfIndirectReference;
	import org.purepdf.pdf.PdfObject;

	/**
	 * The interface common to all layer types
	 */
	public interface IPdfOCG
	{
		function get ref(): PdfIndirectReference;
		function get pdfObject(): PdfObject;
	}
}