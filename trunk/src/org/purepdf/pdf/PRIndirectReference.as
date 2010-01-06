package org.purepdf.pdf
{
	public class PRIndirectReference extends PdfIndirectReference
	{
		public function PRIndirectReference($type:int=0, $number:int=-1, $generation:int=0)
		{
			super($type, $number, $generation);
		}
	}
}