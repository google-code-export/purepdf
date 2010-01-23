package org.purepdf.pdf.events
{
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.pdf.PdfContentByte;
	import org.purepdf.pdf.PdfPCell;
	import org.purepdf.pdf.interfaces.IPdfPCellEvent;
	
	public class PdfPCellEventForwarder implements IPdfPCellEvent
	{
		protected var events: Vector.<IPdfPCellEvent> = new Vector.<IPdfPCellEvent>();
		
		public function PdfPCellEventForwarder()
		{
		}
		
		public function addCellEvent( event: IPdfPCellEvent ): void
		{
			events.push(event);
		}
		
		public function cellLayout(cell:PdfPCell, position:RectangleElement, canvases:Vector.<PdfContentByte>):void
		{
			var event: IPdfPCellEvent;
			for( var i: int = 0; i < events.length; ++i )
			{
				event = events[i];
				event.cellLayout( cell, position, canvases );
			}
		}
	}
}