package org.purepdf.pdf.events
{
	import org.purepdf.pdf.PdfContentByte;
	import org.purepdf.pdf.PdfPTable;
	import org.purepdf.pdf.interfaces.IPdfPTableEvent;

	public class PdfPTableEventForwarder implements IPdfPTableEvent
	{
		protected var events: Vector.<IPdfPTableEvent> = new Vector.<IPdfPTableEvent>();

		public function PdfPTableEventForwarder()
		{
		}

		public function addTableEvent( event: IPdfPTableEvent ): void
		{
			events.push( event );
		}

		public function tableLayout( table: PdfPTable, widths: Vector.<Vector.<Number>>, heights: Vector.<Number>, headerRows: int,
						rowStart: int, canvases: Vector.<PdfContentByte> ): void
		{
			var event: IPdfPTableEvent;

			for ( var i: int = 0; i < events.length; ++i )
			{
				event = events[i];
				event.tableLayout( table, widths, heights, headerRows, rowStart, canvases );
			}
		}
	}
}