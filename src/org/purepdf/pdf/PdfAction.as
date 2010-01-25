package org.purepdf.pdf
{
	import org.purepdf.errors.RuntimeError;
	import org.purepdf.utils.Bytes;
	import org.purepdf.utils.pdf_core;

	/**
	 * A PdfAction defines an action that can be triggered
	 */
	public class PdfAction extends PdfDictionary
	{
		public static const FIRSTPAGE: int = 1;
		public static const PREVPAGE: int = 2;
		public static const NEXTPAGE: int = 3;
		public static const LASTPAGE: int = 4;
		public static const PRINTDIALOG: int = 5;
		
		public function PdfAction()
		{
		}
		
		/** 
		 * Create a JavaScript action. If the JavaScript is smaller than
		 * 50 characters it will be placed as a string, otherwise it will
		 * be placed as a compressed stream.
		 * 
		 * @param code the JavaScript code
		 * @param writer the writer for this action
		 * 
		 * @return the JavaScript action
		 */    
		public static function javaScript( code: String, writer: PdfWriter, unicode: Boolean = false ): PdfAction
		{
			var js: PdfAction = new PdfAction();
			js.put(PdfName.S, PdfName.JAVASCRIPT);
			
			if ( unicode && code.length < 50 ) {
				js.put(PdfName.JS, new PdfString(code, PdfObject.TEXT_UNICODE));
			} else if( !unicode && code.length < 100 )
			{
				js.put(PdfName.JS, new PdfString(code));
			} else {
				try {
					var b: Bytes = PdfEncodings.convertToBytes( code, unicode ? PdfObject.TEXT_UNICODE : PdfObject.TEXT_PDFDOCENCODING);
					var stream: PdfStream = new PdfStream(b);
					stream.flateCompress( writer.getCompressionLevel() );
					js.put(PdfName.JS, writer.pdf_core::addToBody(stream).getIndirectReference() );
				}
				catch (e: Error ) {
					js.put(PdfName.JS, new PdfString(code));
				}
			}
			return js;
		}
		
		/**
		 * Creates a new PDfAction from a named action
		 * 
		 * @see #FIRSTPAGE
		 * @see #PREVPAGE
		 * @see #NEXTPAGE
		 * @see #LASTPAGE
		 * @see #PRINTDIALOG
		 */
		public static function fromNamed( named: int ): PdfAction
		{
			var r: PdfAction = new PdfAction();
			r.put( PdfName.S, PdfName.NAMED );
			
			switch( named )
			{
				case FIRSTPAGE:
					r.put( PdfName.N, PdfName.FIRSTPAGE );
					break;
				
				case PREVPAGE:
					r.put( PdfName.N, PdfName.PREVPAGE );
					break;
				
				case NEXTPAGE:
					r.put( PdfName.N, PdfName.NEXTPAGE );
					break;
				
				case LASTPAGE:
					r.put( PdfName.N, PdfName.LASTPAGE );
					break;
				
				case PRINTDIALOG:
					r.put( PdfName.S, PdfName.JAVASCRIPT );
					r.put( PdfName.JS, new PdfString("this.print(true);\r") );
					break;
				
				default:
					throw new RuntimeError("invalid named action");
			}
			
			return r;
		}
		
		public static function fromURL( url: String, isMap: Boolean = false ): PdfAction
		{
			var action: PdfAction = new PdfAction();
			action.put( PdfName.S, PdfName.URI );
			action.put( PdfName.URI, new PdfString( url ) );

			if ( isMap )
				action.put( PdfName.ISMAP, PdfBoolean.PDF_TRUE );
			return action;
		}
		
		public static function fromDestination( destination: PdfIndirectReference ): PdfAction
		{
			var action: PdfAction = new PdfAction();
			action.put( PdfName.S, PdfName.GOTO );
			action.put( PdfName.D, destination );
			return action;
		}
	}
}