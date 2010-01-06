package org.purepdf.pdf
{
	import org.purepdf.errors.NonImplementatioError;

	public class PdfReader
	{
		public static function getPdfObject( obj: PdfObject ): PdfObject
		{
			if( obj == null )
				return null;
			
			throw new NonImplementatioError();
		}
	}
}