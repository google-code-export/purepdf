package org.purepdf.pdf
{
	import org.purepdf.errors.NonImplementatioError;

	public class PdfPRow
	{
		public function PdfPRow()
		{
		}
		
		public static function fromCell( cell: Vector.<PdfPCell> ): PdfPRow
		{
			throw new NonImplementatioError();
		}
		
		public static function fromRow( row: PdfPRow ): PdfPRow
		{
			throw new NonImplementatioError();
		}
	}
}