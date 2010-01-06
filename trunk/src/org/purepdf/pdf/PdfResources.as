package org.purepdf.pdf
{
	public class PdfResources extends PdfDictionary
	{
		public function PdfResources()
		{
			super();
		}
		
		public function add( key: PdfName, resource: PdfDictionary ): void
		{
			if( resource.size() == 0 )
				return;
			
			var dict: PdfDictionary = getAsDict( key );
			if( dict == null )
				put( key, resource );
			else
				dict.putAll( resource );
		}
	}
}