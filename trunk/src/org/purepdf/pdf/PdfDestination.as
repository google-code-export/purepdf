package org.purepdf.pdf
{
	import org.purepdf.errors.NonImplementatioError;

	public class PdfDestination extends PdfArray
	{
		public function PdfDestination(object:Object=null)
		{
			super(object);
		}
		
		public function addPage( page: PdfIndirectReference ): Boolean
		{
			throw new NonImplementatioError();
		}
	}
}