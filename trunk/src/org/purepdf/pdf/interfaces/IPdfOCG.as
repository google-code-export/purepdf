package org.purepdf.pdf.interfaces
{
	import org.purepdf.pdf.PdfIndirectReference;
	import org.purepdf.pdf.PdfObject;

	/**
	 * The interface common to all layer types
	 */
	public interface IPdfOCG
	{
		function getRef(): PdfIndirectReference;
		function getPdfObject(): PdfObject;
	}
}