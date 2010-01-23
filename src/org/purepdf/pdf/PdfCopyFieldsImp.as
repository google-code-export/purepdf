package org.purepdf.pdf
{
	import flash.utils.ByteArray;
	
	import it.sephiroth.utils.HashMap;
	
	import org.purepdf.elements.RectangleElement;
	
	public class PdfCopyFieldsImp extends PdfWriter
	{
		public static var _fieldKeys: HashMap;
		
		public static function get fieldKeys(): HashMap
		{
			if( _fieldKeys == null )
				initFieldKeys();
			return _fieldKeys;
		}
		
		private static function initFieldKeys(): void
		{
			_fieldKeys = new HashMap();
			_fieldKeys.put(PdfName.AA, 1);
			_fieldKeys.put(PdfName.FT, 1);
			_fieldKeys.put(PdfName.TU, 1);
			_fieldKeys.put(PdfName.TM, 1);
			_fieldKeys.put(PdfName.FF, 1);
			_fieldKeys.put(PdfName.V, 1);
			_fieldKeys.put(PdfName.DV, 1);
			_fieldKeys.put(PdfName.DS, 1);
			_fieldKeys.put(PdfName.RV, 1);
			_fieldKeys.put(PdfName.OPT, 1);
			_fieldKeys.put(PdfName.MAXLEN, 1);
			_fieldKeys.put(PdfName.TI, 1);
			_fieldKeys.put(PdfName.I, 1);
			_fieldKeys.put(PdfName.LOCK, 1);
			_fieldKeys.put(PdfName.SV, 1);			
		}
		
		public function PdfCopyFieldsImp( instance: Lock, output: ByteArray, pagesize: RectangleElement )
		{
			super( instance, output, pagesize );
		}
	}
}