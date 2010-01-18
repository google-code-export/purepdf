package org.purepdf.pdf
{

	/**
	 * A PdfAction defines an action that can be triggered
	 */
	public class PdfAction extends PdfDictionary
	{
		public function PdfAction()
		{
		}
		
		public static function create( url: String, isMap: Boolean = false ): PdfAction
		{
			var action: PdfAction = new PdfAction();
			action.put( PdfName.S, PdfName.URI );
			action.put( PdfName.URI, new PdfString( url ) );

			if ( isMap )
				action.put( PdfName.ISMAP, PdfBoolean.PDF_TRUE );
			return action;
		}
		
		public static function create2( destination: PdfIndirectReference ): PdfAction
		{
			var action: PdfAction = new PdfAction();
			action.put( PdfName.S, PdfName.GOTO );
			action.put( PdfName.D, destination );
			return action;
		}
	}
}