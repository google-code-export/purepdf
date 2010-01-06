package org.purepdf.pdf
{
	import org.purepdf.elements.RectangleElement;
	
	public class PdfFormField extends PdfAnnotation
	{
		public static const FF_READ_ONLY: int = 1;
		public static const FF_REQUIRED: int = 2;
		public static const FF_NO_EXPORT: int = 4;
		public static const FF_NO_TOGGLE_TO_OFF: int = 16384;
		public static const FF_RADIO: int = 32768;
		public static const FF_PUSHBUTTON: int = 65536;
		public static const FF_MULTILINE: int = 4096;
		public static const FF_PASSWORD: int = 8192;
		public static const FF_COMBO: int = 131072;
		public static const FF_EDIT: int = 262144;
		public static const FF_FILESELECT: int = 1048576;
		public static const FF_MULTISELECT: int = 2097152;
		public static const FF_DONOTSPELLCHECK: int = 4194304;
		public static const FF_DONOTSCROLL: int = 8388608;
		public static const FF_COMB: int = 16777216;
		public static const FF_RADIOSINUNISON: int = 1 << 25;
		public static const Q_LEFT: int = 0;
		public static const Q_CENTER: int = 1;
		public static const Q_RIGHT: int = 2;
		public static const MK_NO_ICON: int = 0;
		public static const MK_NO_CAPTION: int = 1;
		public static const MK_CAPTION_BELOW: int = 2;
		public static const MK_CAPTION_ABOVE: int = 3;
		public static const MK_CAPTION_RIGHT: int = 4;
		public static const MK_CAPTION_LEFT: int = 5;
		public static const MK_CAPTION_OVERLAID: int = 6;
		public static const IF_SCALE_ALWAYS: PdfName = PdfName.A;
		public static const IF_SCALE_BIGGER: PdfName = PdfName.B;
		public static const IF_SCALE_SMALLER: PdfName = PdfName.S;
		public static const IF_SCALE_NEVER: PdfName = PdfName.N;
		public static const IF_SCALE_ANAMORPHIC: PdfName = PdfName.A;
		public static const IF_SCALE_PROPORTIONAL: PdfName = PdfName.P;
		public static const MULTILINE: Boolean = true;
		public static const SINGLELINE: Boolean = false;
		public static const PLAINTEXT: Boolean = false;
		public static const PASSWORD: Boolean = true;
		
		protected var formParent: PdfFormField;
		protected var formKids: Array;
		
		private static const mergeTarget: Vector.<PdfName> = Vector.<PdfName>( [PdfName.FONT, PdfName.XOBJECT, PdfName.COLORSPACE, PdfName.PATTERN] );
		
		public function PdfFormField( $writer: PdfWriter, rect: RectangleElement )
		{
			super($writer, rect);
		}
		
		public function get parent(): PdfFormField
		{
			return formParent;
		}
		
		public function get kids(): Array
		{
			return formKids;
		}
	}
}