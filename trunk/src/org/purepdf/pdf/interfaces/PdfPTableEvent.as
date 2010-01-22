package org.purepdf.pdf.interfaces
{
	import org.purepdf.pdf.PdfContentByte;
	import org.purepdf.pdf.PdfPTable;

	public interface PdfPTableEvent
	{
		function tableLayout( table: PdfPTable, widths: Vector.<Vector.<Number>>, heights: Vector.<Number>, headerRows: int, rowStart: int, canvases: Vector.<PdfContentByte> ): void;
	}
}