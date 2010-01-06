package 
{
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	import org.purepdf.colors.RGBColor;
	import org.purepdf.elements.AnnotationElement;
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.elements.images.ImageElement;
	import org.purepdf.pdf.PageSize;
	import org.purepdf.pdf.PdfDocument;
	import org.purepdf.pdf.PdfWriter;

	/**
	 * This example create a PDF document with
	 * different type of images ( png, jpeg, bitmapdata )
	 * 
	 * Test also image scaling, alignment, absolute positioning..
	 * 
	 */
	public class ImageTypes extends DefaultBasicExample
	{
		[Embed(source="assets/image1.jpg")]
		private var cls1: Class;
		
		[Embed(source="assets/appicondocsec.png")]
		private var cls2: Class;
		
		[Embed(source="assets/hitchcock.gif", mimeType="application/octet-stream")]
		private var cls3: Class;
		
		public function ImageTypes()
		{
			super();
		}
		
		override protected function execute(event:Event=null) : void
		{
			super.execute();
			
			var bmp: BitmapData = ( new cls1() as Bitmap ).bitmapData;
			var rect: RectangleElement = PageSize.A4;
			var document: PdfDocument = PdfWriter.create( buffer, rect );
			
			document.open();
			document.addTitle( getQualifiedClassName( this ) );
			document.addSubject("Image Types Example");
			
			// ---------------
			// JPEG image
			// ---------------
			var bytes: ByteArray = new JPGEncoder( 90 ).encode( bmp );
			var image1: ImageElement = ImageElement.getInstance( bytes );
			image1.alignment = ImageElement.RIGHT;	// set the image alignment
			image1.setBorderWidth( 5 );
			image1.setBorderSides( RectangleElement.LEFT | RectangleElement.TOP | RectangleElement.RIGHT | RectangleElement.BOTTOM );
			image1.setBorderColor( new RGBColor( 255, 255, 255 ) );
			document.addElement( image1 );
			
			// test image scaling
			image1.scaleToFit( 50, 50 );
			image1.alignment = ImageElement.LEFT;
			document.addElement( image1 );
			
			image1.scalePercent( 100, 100 );
			image1.scaleAbsolute( 100, 100 );
			document.addElement( image1 );
			
			// ---------------
			// PNG image
			// ---------------
			bytes = PNGEncoder.encode( ( new cls2() as Bitmap ).bitmapData );
			var image: ImageElement = ImageElement.getInstance( bytes );
			image.alignment = ImageElement.MIDDLE;
			document.addElement( image );
			
			image.scaleToFit( 300, 300 );
			image.alignment = ImageElement.LEFT;
			document.addElement( image );
			
			// ---------------
			// GIF Image
			// ---------------
			bytes = new cls3() as ByteArray;
			image = ImageElement.getInstance( bytes );
			document.addElement( image );
			
			
			// ---------------
			// BitmapData image
			// ---------------
			bmp = new BitmapData( 100, 100 );
			bmp.lock();
			
			for( var k: int = 0; k < 100; ++k )
			{
				for( var j: int = 0; j < 100; ++j )
				{
					var c: uint = ((255 * Math.sin(j * .5 * Math.PI / 100)) << 16 ) | ((256 - j * 256 / 100) << 8 ) | (255 * Math.cos(k * .5 * Math.PI / 100));
					bmp.setPixel( k, j, c );
				}
			}
			
			bmp.unlock();
			
			image = ImageElement.getRawInstance( 100, 100, 4, 8, bmp.getPixels( bmp.rect ) );
			image.setAbsolutePosition( 100, 200 );
			image.setRotation( Math.PI / 4 );
			
			document.addElement( image );
			
			
			// close and save the document
			document.close();
			save();
		}
	}
}