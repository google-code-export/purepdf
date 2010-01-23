package org.purepdf.pdf
{
	public class PRIndirectReference extends PdfIndirectReference
	{
		protected var _reader: PdfReader;
		
		public function PRIndirectReference($type:int=0, $number:int=-1, $generation:int=0)
		{
			super($type, $number, $generation);
		}
		
		public function get reader(): PdfReader
		{
			return _reader;
		}
	}
}