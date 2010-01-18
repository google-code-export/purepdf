package org.purepdf.pdf
{
	

	public class PdfDestination extends PdfArray
	{
		public static const XYZ: int = 0;
		public static const FIT: int = 1;
		public static const FITH: int = 2;
		public static const FITV: int = 3;
		public static const FITR: int = 4;
		public static const FITB: int = 5;
		public static const FITBH: int = 6;
		public static const FITBV: int = 7;

		private var _status: Boolean = false;
		
		public function PdfDestination(object:Object=null)
		{
			super(object);
		}
		
		public function addPage( page: PdfIndirectReference ): Boolean
		{
			if (!_status)
			{
				addFirst( page );
				_status = true;
				return true;
			}
			return false;
		}
		
		public function get hasPage(): Boolean
		{
			return _status;
		}
		
		static public function create2( type: int, left: Number, top: Number, zoom: Number ): PdfDestination
		{
			var dest: PdfDestination = new PdfDestination( PdfName.XYZ );
			if (left < 0)
				dest.add( PdfNull.PDFNULL );
			else
				dest.add( new PdfNumber(left) );
			if (top < 0)
				dest.add(PdfNull.PDFNULL);
			else
				dest.add(new PdfNumber(top));
			dest.add(new PdfNumber(zoom));
			return dest;
		}
		
		public static function create( type: int, parameter: Number ): PdfDestination
		{
			var result: PdfDestination = new PdfDestination( new PdfNumber( parameter ) );
			
			switch( type )
			{
				case FITV:
					result.addFirst(PdfName.FITV);
					break;
				
				case FITBH:
					result.addFirst(PdfName.FITBH);
					break;
				
				case FITBV:
					result.addFirst(PdfName.FITBV);
					break;

				default:
					result.addFirst( PdfName.FITH );
					break;
			}
			
			return result;
		}
	}
}