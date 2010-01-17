package
{
	import flash.events.Event;
	
	import org.purepdf.elements.Paragraph;
	import org.purepdf.pdf.PdfVersion;

	public class HelloWorldMaximum extends DefaultBasicExample
	{
		public function HelloWorldMaximum(d_list:Array=null)
		{
			super(["This example shows how you can change the document units","The Minimum UserUnit is 1 (1 unit = 1/72 inch)","Maximum is 75,000"]);
		}
		
		override protected function execute(event:Event=null) : void
		{
			super.execute();
			
			createDocument("Hello World maximum");
			document.open();
			
			document.setPdfVersion( PdfVersion.VERSION_1_6 );
			document.userunit = 75000;
			
			document.addElement( Paragraph.create("Hello World") );
			
			document.close();
			save();
		}
	}
}