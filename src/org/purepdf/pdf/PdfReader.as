package org.purepdf.pdf
{
	import it.sephiroth.utils.ObjectHash;
	
	import org.purepdf.errors.NonImplementatioError;

	public class PdfReader extends ObjectHash
	{
		public static function getPdfObject( obj: PdfObject ): PdfObject
		{
			if( obj == null )
				return null;
			
			throw new NonImplementatioError();
		}
	}
}