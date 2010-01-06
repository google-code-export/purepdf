package org.purepdf.pdf
{
	import org.purepdf.pdf.interfaces.IPdfViewerPreferences;

	public class PdfViewerPreferencesImp implements IPdfViewerPreferences
	{
		public static const DIRECTION_PREFERENCES: Vector.<PdfName> = Vector.<PdfName>( [ PdfName.L2R, PdfName.R2L ] );
		public static const DUPLEX_PREFERENCES: Vector.<PdfName> = Vector.<PdfName>( [ PdfName.SIMPLEX, PdfName.DUPLEXFLIPSHORTEDGE, PdfName.DUPLEXFLIPLONGEDGE ] );
		public static const NONFULLSCREENPAGEMODE_PREFERENCES: Vector.<PdfName> = Vector.<PdfName>( [ PdfName.USENONE, PdfName.USEOUTLINES, PdfName.USETHUMBS, PdfName.USEOC ] );
		public static const PAGE_BOUNDARIES: Vector.<PdfName> = Vector.<PdfName>( [ PdfName.MEDIABOX, PdfName.CROPBOX, PdfName.BLEEDBOX, PdfName.TRIMBOX, PdfName.ARTBOX ] );
		public static const PRINTSCALING_PREFERENCES: Vector.<PdfName> = Vector.<PdfName>( [ PdfName.APPDEFAULT, PdfName.NONE ] );
		public static const VIEWER_PREFERENCES: Vector.<PdfName> = Vector.<PdfName>( [ PdfName.HIDETOOLBAR, // 0
																					   PdfName.HIDEMENUBAR, // 1
																					   PdfName.HIDEWINDOWUI, // 2
																					   PdfName.FITWINDOW, // 3
																					   PdfName.CENTERWINDOW, // 4
																					   PdfName.DISPLAYDOCTITLE, // 5
																					   PdfName.NONFULLSCREENPAGEMODE, // 6
																					   PdfName.DIRECTION, // 7
																					   PdfName.VIEWAREA, // 8
																					   PdfName.VIEWCLIP, // 9
																					   PdfName.PRINTAREA, // 10
																					   PdfName.PRINTCLIP, // 11
																					   PdfName.PRINTSCALING, // 12
																					   PdfName.DUPLEX, // 13
																					   PdfName.PICKTRAYBYPDFSIZE, // 14
																					   PdfName.PRINTPAGERANGE, // 15
																					   PdfName.NUMCOPIES // 16
																					 ] );
		private static var viewerPreferencesMask: int = 0xfff000;
		private var pageLayoutAndMode: int = 0;
		private var viewerPreferences: PdfDictionary = new PdfDictionary();

		public function PdfViewerPreferencesImp()
		{
		}

		public function addToCatalog( catalog: PdfDictionary ): void
		{
			// Page Layout
			catalog.remove( PdfName.PAGELAYOUT );

			if ( ( pageLayoutAndMode & PdfWriter.PageLayoutSinglePage ) != 0 )
				catalog.put( PdfName.PAGELAYOUT, PdfName.SINGLEPAGE );
			else if ( ( pageLayoutAndMode & PdfWriter.PageLayoutOneColumn ) != 0 )
				catalog.put( PdfName.PAGELAYOUT, PdfName.ONECOLUMN );
			else if ( ( pageLayoutAndMode & PdfWriter.PageLayoutTwoColumnLeft ) != 0 )
				catalog.put( PdfName.PAGELAYOUT, PdfName.TWOCOLUMNLEFT );
			else if ( ( pageLayoutAndMode & PdfWriter.PageLayoutTwoColumnRight ) != 0 )
				catalog.put( PdfName.PAGELAYOUT, PdfName.TWOCOLUMNRIGHT );
			else if ( ( pageLayoutAndMode & PdfWriter.PageLayoutTwoPageLeft ) != 0 )
				catalog.put( PdfName.PAGELAYOUT, PdfName.TWOPAGELEFT );
			else if ( ( pageLayoutAndMode & PdfWriter.PageLayoutTwoPageRight ) != 0 )
				catalog.put( PdfName.PAGELAYOUT, PdfName.TWOPAGERIGHT );
			// Page Mode
			catalog.remove( PdfName.PAGEMODE );

			if ( ( pageLayoutAndMode & PdfWriter.PageModeUseNone ) != 0 )
				catalog.put( PdfName.PAGEMODE, PdfName.USENONE );
			else if ( ( pageLayoutAndMode & PdfWriter.PageModeUseOutlines ) != 0 )
				catalog.put( PdfName.PAGEMODE, PdfName.USEOUTLINES );
			else if ( ( pageLayoutAndMode & PdfWriter.PageModeUseThumbs ) != 0 )
				catalog.put( PdfName.PAGEMODE, PdfName.USETHUMBS );
			else if ( ( pageLayoutAndMode & PdfWriter.PageModeFullScreen ) != 0 )
				catalog.put( PdfName.PAGEMODE, PdfName.FULLSCREEN );
			else if ( ( pageLayoutAndMode & PdfWriter.PageModeUseOC ) != 0 )
				catalog.put( PdfName.PAGEMODE, PdfName.USEOC );
			else if ( ( pageLayoutAndMode & PdfWriter.PageModeUseAttachments ) != 0 )
				catalog.put( PdfName.PAGEMODE, PdfName.USEATTACHMENTS );
			catalog.remove( PdfName.VIEWERPREFERENCES );

			if ( viewerPreferences.size() > 0 )
			{
				catalog.put( PdfName.VIEWERPREFERENCES, viewerPreferences );
			}
		}

		public function addViewerPreference( key: PdfName, value: PdfObject ): void
		{
			switch ( getIndex( key ) )
			{
				case 0: // HIDETOOLBAR
				case 1: // HIDEMENUBAR
				case 2: // HIDEWINDOWUI
				case 3: // FITWINDOW
				case 4: // CENTERWINDOW
				case 5: // DISPLAYDOCTITLE
				case 14: // PICKTRAYBYPDFSIZE
					if ( value is PdfBoolean )
					{
						viewerPreferences.put( key, value );
					}
					break;
				case 6: // NONFULLSCREENPAGEMODE
					if ( value is PdfName && isPossibleValue( PdfName( value ), NONFULLSCREENPAGEMODE_PREFERENCES ) )
					{
						viewerPreferences.put( key, value );
					}
					break;
				case 7: // DIRECTION
					if ( value is PdfName && isPossibleValue( PdfName( value ), DIRECTION_PREFERENCES ) )
					{
						viewerPreferences.put( key, value );
					}
					break;
				case 8: // VIEWAREA
				case 9: // VIEWCLIP
				case 10: // PRINTAREA
				case 11: // PRINTCLIP
					if ( value is PdfName && isPossibleValue( PdfName( value ), PAGE_BOUNDARIES ) )
					{
						viewerPreferences.put( key, value );
					}
					break;
				case 12: // PRINTSCALING
					if ( value is PdfName && isPossibleValue( PdfName( value ), PRINTSCALING_PREFERENCES ) )
					{
						viewerPreferences.put( key, value );
					}
					break;
				case 13: // DUPLEX
					if ( value is PdfName && isPossibleValue( PdfName( value ), DUPLEX_PREFERENCES ) )
					{
						viewerPreferences.put( key, value );
					}
					break;
				case 15: // PRINTPAGERANGE
					if ( value is PdfArray )
					{
						viewerPreferences.put( key, value );
					}
					break;
				case 16: // NUMCOPIES
					if ( value is PdfNumber )
					{
						viewerPreferences.put( key, value );
					}
					break;
			}
		}

		public function getPageLayoutMode(): int
		{
			return pageLayoutAndMode;
		}

		public function getViewerPreferences(): PdfDictionary
		{
			return viewerPreferences;
		}

		public function setViewerPreferences( preferences: int ): void
		{
			pageLayoutAndMode |= preferences;

			if ( ( preferences & viewerPreferencesMask ) != 0 )
			{
				pageLayoutAndMode = ~viewerPreferencesMask & pageLayoutAndMode;

				if ( ( preferences & PdfWriter.HideToolbar ) != 0 )
					viewerPreferences.put( PdfName.HIDETOOLBAR, PdfBoolean.PDF_TRUE );

				if ( ( preferences & PdfWriter.HideMenubar ) != 0 )
					viewerPreferences.put( PdfName.HIDEMENUBAR, PdfBoolean.PDF_TRUE );

				if ( ( preferences & PdfWriter.HideWindowUI ) != 0 )
					viewerPreferences.put( PdfName.HIDEWINDOWUI, PdfBoolean.PDF_TRUE );

				if ( ( preferences & PdfWriter.FitWindow ) != 0 )
					viewerPreferences.put( PdfName.FITWINDOW, PdfBoolean.PDF_TRUE );

				if ( ( preferences & PdfWriter.CenterWindow ) != 0 )
					viewerPreferences.put( PdfName.CENTERWINDOW, PdfBoolean.PDF_TRUE );

				if ( ( preferences & PdfWriter.DisplayDocTitle ) != 0 )
					viewerPreferences.put( PdfName.DISPLAYDOCTITLE, PdfBoolean.PDF_TRUE );

				if ( ( preferences & PdfWriter.NonFullScreenPageModeUseNone ) != 0 )
					viewerPreferences.put( PdfName.NONFULLSCREENPAGEMODE, PdfName.USENONE );
				else if ( ( preferences & PdfWriter.NonFullScreenPageModeUseOutlines ) != 0 )
					viewerPreferences.put( PdfName.NONFULLSCREENPAGEMODE, PdfName.USEOUTLINES );
				else if ( ( preferences & PdfWriter.NonFullScreenPageModeUseThumbs ) != 0 )
					viewerPreferences.put( PdfName.NONFULLSCREENPAGEMODE, PdfName.USETHUMBS );
				else if ( ( preferences & PdfWriter.NonFullScreenPageModeUseOC ) != 0 )
					viewerPreferences.put( PdfName.NONFULLSCREENPAGEMODE, PdfName.USEOC );

				if ( ( preferences & PdfWriter.DirectionL2R ) != 0 )
					viewerPreferences.put( PdfName.DIRECTION, PdfName.L2R );
				else if ( ( preferences & PdfWriter.DirectionR2L ) != 0 )
					viewerPreferences.put( PdfName.DIRECTION, PdfName.R2L );

				if ( ( preferences & PdfWriter.PrintScalingNone ) != 0 )
					viewerPreferences.put( PdfName.PRINTSCALING, PdfName.NONE );
			}
		}

		private function getIndex( key: PdfName ): int
		{
			for ( var i: int = 0; i < VIEWER_PREFERENCES.length; i++ )
			{
				if ( VIEWER_PREFERENCES[ i ].equals( key ) )
					return i;
			}
			return -1;
		}

		private function isPossibleValue( value: PdfName, accepted: Vector.<PdfName> ): Boolean
		{
			for ( var i: int = 0; i < accepted.length; i++ )
			{
				if ( accepted[ i ].equals( value ) )
				{
					return true;
				}
			}
			return false;
		}
	}
}