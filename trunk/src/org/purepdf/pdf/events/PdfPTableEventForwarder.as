package org.purepdf.pdf.events
{
	import org.purepdf.pdf.PdfContentByte;
	import org.purepdf.pdf.PdfPTable;
	import org.purepdf.pdf.interfaces.PdfPTableEvent;

	public class PdfPTableEventForwarder implements PdfPTableEvent
	{
		protected var events: Vector.<PdfPTableEvent> = new Vector.<PdfPTableEvent>();

		public function PdfPTableEventForwarder()
		{
		}

		public function addTableEvent( event: PdfPTableEvent ): void
		{
			events.push( event );
		}

		public function tableLayout( table: PdfPTable, widths: Vector.<Vector.<Number>>, heights: Vector.<Number>, headerRows: int,
						rowStart: int, canvases: Vector.<PdfContentByte> ): void
		{
			var event: PdfPTableEvent;

			for ( var i: int = 0; i < events.length; ++i )
			{
				event = events[i];
				event.tableLayout( table, widths, heights, headerRows, rowStart, canvases );
			}
		}
	}
}