package
{
	import flash.events.Event;
	
	import org.purepdf.elements.Chunk;
	import org.purepdf.elements.Paragraph;
	import org.purepdf.pdf.PdfContentByte;
	import org.purepdf.pdf.barcode.Barcode;
	import org.purepdf.pdf.barcode.BarcodeEAN;
	import org.purepdf.pdf.fonts.BaseFont;
	import org.purepdf.pdf.fonts.BuiltinFonts;
	import org.purepdf.pdf.fonts.FontsResourceFactory;

	public class BarCodes extends DefaultBasicExample
	{
		public function BarCodes(d_list:Array=null)
		{
			super(["Create barcodes"]);
			FontsResourceFactory.getInstance().registerFont( BaseFont.HELVETICA, BuiltinFonts.HELVETICA );
		}
		
		override protected function execute(event:Event=null) : void
		{
			super.execute();
			
			createDocument();
			document.open();
			
			var cb: PdfContentByte = document.getDirectContent();
			
			// EAN 13
			document.add( new Paragraph("Barcode EAN.UCC-13") );
			var bcode: Barcode = new BarcodeEAN();
			bcode.code = "4512345678906";
			var p: Paragraph = new Paragraph("default:  \n");
			p.add( Chunk.fromImage( bcode.createImageWithBarcode( cb, null, null ), 0, -5 ) );
			p.add( Chunk.NEWLINE );
			bcode.guardBars = false;
			p.add("without guard bars: \n");
			p.add( Chunk.fromImage( bcode.createImageWithBarcode( cb, null, null ), 0, -5 ) );
			
			p.leading = bcode.getBarcodeSize().height;
			document.add( p );
			
			document.close();
			save();
		}
	}
}