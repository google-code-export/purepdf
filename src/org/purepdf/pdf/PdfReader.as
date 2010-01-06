package org.purepdf.pdf
{
	import org.purepdf.errors.NonImplementatioError;

	public class PdfReader
	{
		
		/**
		 * Reads a <CODE>PdfObject</CODE> resolving an indirect reference
		 * if needed.
		 * @param obj the <CODE>PdfObject</CODE> to read
		 * @return the resolved <CODE>PdfObject</CODE>
		 */
		
		public static function getPdfObject( obj: PdfObject ): PdfObject
		{
			if( obj == null )
				return null;
			
			throw new NonImplementatioError();
			/*
			if( !obj.isIndirect() )
				return obj;
		
		
			var ref: PRIndirectReference = PRIndirectReference( obj );
			var idx: int = ref.getNumber();
			var appendable: Boolean = ref.getReader().appendable;
			obj = ref.getReader().getPdfObject( idx );
			
			if( obj == null )
			{
				return null;
			} else
			{
				if( appendable )
				{
					switch( obj.type() )
					{
						case PdfObject.NULL:
							obj = new PdfNull();
							break;
						
						case PdfObject.BOOLEAN:
							obj = new PdfBoolean( (obj as PdfBoolean ).booleanValue() );
							break;
						
						case PdfObject.NAME:
							obj = new PdfName( obj.getBytes() );
							break;
					}
					
					obj.setIndRef(ref);
				}
				return obj;
			}
			*/
		}
	}
}