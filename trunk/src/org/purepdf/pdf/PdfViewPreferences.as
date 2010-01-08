package org.purepdf.pdf
{
	import org.purepdf.ObjectHash;

	/**
	 * Contains the constants used for modify the pdf display
	 * preferences
	 * 
	 * @see org.purepdf.pdf.PdfDocument.setViewerPreferences()
	 */
	public class PdfViewPreferences extends ObjectHash
	{
		public static const PageLayoutSinglePage: int = 1;
		public static const PageLayoutOneColumn: int = 2;
		public static const PageLayoutTwoColumnLeft: int = 4;
		public static const PageLayoutTwoColumnRight: int = 8;
		public static const PageLayoutTwoPageLeft: int = 16;
		public static const PageLayoutTwoPageRight: int = 32;
		public static const PageModeUseNone: int = 64;
		public static const PageModeUseOutlines: int = 128;
		public static const PageModeUseThumbs: int = 256;
		public static const PageModeFullScreen: int = 512;
		public static const PageModeUseOC: int = 1024;
		public static const PageModeUseAttachments: int = 2048;
		
		public static const HideToolbar: int = 1 << 12;
		public static const HideMenubar: int = 1 << 13;
		public static const HideWindowUI: int = 1 << 14;
		public static const FitWindow: int = 1 << 15;
		public static const CenterWindow: int = 1 << 16;
		public static const DisplayDocTitle: int = 1 << 17;
		public static const NonFullScreenPageModeUseNone: int = 1 << 18;
		public static const NonFullScreenPageModeUseOutlines: int = 1 << 19;
		public static const NonFullScreenPageModeUseThumbs: int = 1 << 20;
		public static const NonFullScreenPageModeUseOC: int = 1 << 21;
		public static const DirectionL2R: int = 1 << 22;
		public static const DirectionR2L: int = 1 << 23;
		public static const PrintScalingNone: int = 1 << 24;
	}
}