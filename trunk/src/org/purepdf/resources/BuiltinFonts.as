package org.purepdf.resources
{
	/**
	 * This class contains all the pdf builtin fonts you can use for writing text.
	 * Use the FontsResourceFactory to register a new font.
	 * 
	 * @see FontsResourceFactory#registerFont()
	 */
	public final class BuiltinFonts
	{
		[Embed( source="afm/Courier.afm", mimeType="application/octet-stream" )]
		public static const COURIER: Class;
		
		[Embed( source="afm/Courier-Bold.afm", mimeType="application/octet-stream" )]
		public static const COURIER_BOLD: Class;
		
		[Embed( source="afm/Courier-BoldOblique.afm", mimeType="application/octet-stream" )]
		public static const COURIER_BOLDOBLIQUE: Class;
		
		[Embed( source="afm/Courier-Oblique.afm", mimeType="application/octet-stream" )]
		public static const COURIER_OBLIQUE: Class;
		
		[Embed( source="afm/Helvetica.afm", mimeType="application/octet-stream" )]
		public static const HELVETICA: Class;
		
		[Embed( source="afm/Helvetica-Bold.afm", mimeType="application/octet-stream" )]
		public static const HELVETICA_BOLD: Class;
		
		[Embed( source="afm/Helvetica-BoldOblique.afm", mimeType="application/octet-stream" )]
		public static const HELVETICA_BOLDOBLIQUE: Class;
		
		[Embed( source="afm/Helvetica-Oblique.afm", mimeType="application/octet-stream" )]
		public static const HELVETICA_OBLIQUE: Class;

		[Embed( source="afm/Symbol.afm", mimeType="application/octet-stream" )]
		public static const SYMBOL: Class;

		[Embed( source="afm/Times-Roman.afm", mimeType="application/octet-stream" )]
		public static const TIMES_ROMAN: Class;
		
		[Embed( source="afm/Times-Bold.afm", mimeType="application/octet-stream" )]
		public static const TIMES_BOLD: Class;
		
		[Embed( source="afm/Times-BoldItalic.afm", mimeType="application/octet-stream" )]
		public static const TIMES_BOLDITALIC: Class;
		
		[Embed( source="afm/Times-Italic.afm", mimeType="application/octet-stream" )]
		public static const TIMES_ITALIC: Class;
		
		[Embed( source="afm/ZapfDingbats.afm", mimeType="application/octet-stream" )]
		public static const ZAPFDINGBATS: Class;

	}
}