package org.purepdf.pdf.interfaces
{
	import org.purepdf.pdf.PdfName;
	import org.purepdf.pdf.PdfObject;

	public interface IPdfViewerPreferences
	{
		function setViewerPreferences( preferences: int ): void;
		function addViewerPreference( key: PdfName, value: PdfObject ): void;
	}
}