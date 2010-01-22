package org.purepdf.pdf.interfaces
{
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.pdf.PdfContentByte;
	import org.purepdf.pdf.PdfPCell;

	public interface PdfPCellEvent
	{
		function cellLayout( cell: PdfPCell, position: RectangleElement, canvases: Vector.<PdfContentByte> ): void;
	}
}