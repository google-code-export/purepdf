package org.purepdf.pdf
{
	import it.sephiroth.utils.ObjectHash;
	import org.purepdf.errors.NonImplementatioError;

	public class PdfReader extends ObjectHash
	{
		static public function getPdfObject( obj: PdfObject ): PdfObject
		{
			if ( obj == null )
				return null;
			throw new NonImplementatioError();
		}

		static public function getPdfObjects( obj: PdfObject, parent: PdfObject ): PdfObject
		{
			if ( obj == null )
				return null;

			if ( !obj.isIndirect() )
			{
				throw new NonImplementatioError( "Indirect objects not yet implemented" );
			}
			return getPdfObject( obj );
		}
	}
}