package org.purepdf.pdf
{
	import it.sephiroth.utils.ObjectHash;
	
	import org.purepdf.errors.NonImplementatioError;

	public class PdfReader extends ObjectHash
	{
		private var _appendable: Boolean;
		
		static public function getPdfObject( obj: PdfObject ): PdfObject
		{
			if ( obj == null )
				return null;
			if( !obj.isIndirect() )
				return obj;
			throw new NonImplementatioError();
		}

		static public function getPdfObjects( obj: PdfObject, parent: PdfObject ): PdfObject
		{
			if ( obj == null )
				return null;

			if ( !obj.isIndirect() )
			{
				var ref: PRIndirectReference;
				
				if( parent != null && ( ref = parent.getIndRef() ) != null && ref.reader.appenbable )
				{
					throw new NonImplementatioError( "Indirect objects not yet implemented" );
				}
				return obj;
			}
			return getPdfObject( obj );
		}
		
		public function get appenbable(): Boolean
		{
			return _appendable;
		}
	}
}