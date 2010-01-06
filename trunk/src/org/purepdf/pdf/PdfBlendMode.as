package org.purepdf.pdf
{
	/**
	 * Possible transparency blend modes to be used in a <code>PdfGstate</code>
	 * 
	 * @see org.purepdf.pdf.PdfGState
	 */
	public class PdfBlendMode
	{
		public static const NORMAL: PdfName = new PdfName("Normal");
		public static const COMPATIBLE: PdfName = new PdfName("Compatible");
		public static const MULTIPLY: PdfName = new PdfName("Multiply");
		public static const SCREEN: PdfName = new PdfName("Screen");
		public static const OVERLAY: PdfName = new PdfName("Overlay");
		public static const DARKEN: PdfName = new PdfName("Darken");
		public static const LIGHTEN: PdfName = new PdfName("Lighten");
		public static const COLORDODGE: PdfName = new PdfName("ColorDodge");
		public static const COLORBURN: PdfName = new PdfName("ColorBurn");
		public static const HARDLIGHT: PdfName = new PdfName("HardLight");
		public static const SOFTLIGHT: PdfName = new PdfName("SoftLight");
		public static const DIFFERENCE: PdfName = new PdfName("Difference");
		public static const EXCLUSION: PdfName = new PdfName("Exclusion");
	}
}