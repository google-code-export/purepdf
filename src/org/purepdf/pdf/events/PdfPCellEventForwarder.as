package org.purepdf.pdf.events
{
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.pdf.PdfContentByte;
	import org.purepdf.pdf.PdfPCell;
	import org.purepdf.pdf.interfaces.PdfPCellEvent;
	
	public class PdfPCellEventForwarder implements PdfPCellEvent
	{
		protected var events: Vector.<PdfPCellEvent> = new Vector.<PdfPCellEvent>();
		
		public function PdfPCellEventForwarder()
		{
		}
		
		public function addCellEvent( event: PdfPCellEvent ): void
		{
			events.push(event);
		}
		
		public function cellLayout(cell:PdfPCell, position:RectangleElement, canvases:Vector.<PdfContentByte>):void
		{
			var event: PdfPCellEvent;
			for( var i: int = 0; i < events.length; ++i )
			{
				event = events[i];
				event.cellLayout( cell, position, canvases );
			}
		}
	}
}