package org.purepdf.pdf.fonts
{
	import flash.utils.ByteArray;
	import it.sephiroth.utils.HashMap;
	import org.purepdf.utils.StringUtils;

	/**
	 * Use this class if you want to register more fonts to 
	 * be used with the document
	 */
	public class FontsResourceFactory
	{
		[Embed( source="Helvetica.afm", mimeType="application/octet-stream" )] private var helvetica_afm1: Class;
		[Embed( source="Helvetica-Bold.afm", mimeType="application/octet-stream" )] private var helvetica_afm2: Class;
		[Embed( source="Helvetica-BoldOblique.afm", mimeType="application/octet-stream" )] private var helvetica_afm3: Class;
		[Embed( source="Helvetica-Oblique.afm", mimeType="application/octet-stream" )] private var helvetica_afm4: Class;
		
		[Embed( source="Courier.afm", mimeType="application/octet-stream" )] private var courier_afm1: Class;
		[Embed( source="Courier-Bold.afm", mimeType="application/octet-stream" )] private var courier_afm2: Class;
		[Embed( source="Courier-BoldOblique.afm", mimeType="application/octet-stream" )] private var courier_afm3: Class;
		[Embed( source="Courier-Oblique.afm", mimeType="application/octet-stream" )] private var courier_afm4: Class;
		
		[Embed( source="Times-Roman.afm", mimeType="application/octet-stream" )] private var times_afm1: Class;
		[Embed( source="Times-Bold.afm", mimeType="application/octet-stream" )] private var times_afm2: Class;
		[Embed( source="Times-BoldItalic.afm", mimeType="application/octet-stream" )] private var times_afm3: Class;
		[Embed( source="Times-Italic.afm", mimeType="application/octet-stream" )] private var times_afm4: Class;
		
		[Embed( source="Symbol.afm", mimeType="application/octet-stream" )] private var symbol_afm1: Class;
		[Embed( source="ZapfDingbats.afm", mimeType="application/octet-stream" )] private var zap_afm1: Class;
		
		private static var instance: FontsResourceFactory;
		private var fontsMap: HashMap;

		/**
		 * Do not use constructor to initialize this class but <code>getInstance</code>
		 * should be used
		 * 
		 * @see getInstance()
		 */
		public function FontsResourceFactory( lock: Lock )
		{
			if ( lock == null )
				throw new Error( "Cannot instantiate a new FontsResourceFactory. Use getInstance instead" );

			fontsMap = new HashMap();
			fontsMap.put( BaseFont.HELVETICA, helvetica_afm1 );
			fontsMap.put( BaseFont.HELVETICA_BOLD, helvetica_afm2 );
			fontsMap.put( BaseFont.HELVETICA_BOLDOBLIQUE, helvetica_afm3 );
			fontsMap.put( BaseFont.HELVETICA_OBLIQUE, helvetica_afm4 );
			
			fontsMap.put( BaseFont.COURIER, courier_afm1 );
			fontsMap.put( BaseFont.COURIER_BOLD, courier_afm2 );
			fontsMap.put( BaseFont.COURIER_BOLDOBLIQUE, courier_afm3 );
			fontsMap.put( BaseFont.COURIER_OBLIQUE, courier_afm4 );
			
			fontsMap.put( BaseFont.TIMES_ROMAN, times_afm1 );
			fontsMap.put( BaseFont.TIMES_BOLD, times_afm2 );
			fontsMap.put( BaseFont.TIMES_BOLDITALIC, times_afm3 );
			fontsMap.put( BaseFont.TIMES_ITALIC, times_afm4 );
			
			fontsMap.put( BaseFont.SYMBOL, symbol_afm1 );
			fontsMap.put( BaseFont.ZAPFDINGBATS, zap_afm1 );
		}

		/**
		 * Return true if a font is already registered
		 * @param name the font name. eg. "Helvetica"
		 * @see registerFont()
		 */
		public function fontIsRegistered( name: String ): Boolean
		{
			if ( StringUtils.endsWith( name, ".afm" ) )
				return fontsMap.containsKey( name );
			return fontsMap.containsKey( name + ".afm" );
		}

		public function getFontFile( filename: String ): ByteArray
		{
			if ( fontsMap.containsKey( filename ) )
				return new( fontsMap.getValue( filename ) )();
			return null;
		}

		/**
		 * <p>You can register a new font passing the bytearray class
		 * of an embedded resource</p>
		 * <p>Example
		 * <code>
		 * [Embed(source="assets/fonts/Helvetica-Bold.afm", mimeType="application/octet-stream")]<br>
		 * private var helveticaB: Class;<br>
		 * <br>
		 * public function main()<br>
		 * {<br>
		 * 	FontsResourceFactory.getInstance().registerFont( BaseFont.HELVETICA_BOLD, helveticaB );<br>
		 *	var font: Font = new Font( Font.HELVETICA, 18, Font.BOLD );<br>
		 *	document.addElement( Paragraph.create("Hello world", font) );<br>
		 * }<br>
		 * </code>
		 * </p>
		 * 
		 * @param name	The font name (eg. "Helvetica")
		 */
		public function registerFont( name: String, file: Class ): void
		{
			fontsMap.put( name, file );
		}

		/**
		 * Return the singleton of FontsResourceFactory
		 * 
		 * @see registerFont()
		 * @see fontIsRegistered()
		 * @see getFontFile()
		 */
		public static function getInstance(): FontsResourceFactory
		{
			if ( instance == null )
				instance = new FontsResourceFactory( new Lock() );
			return instance;
		}
	}
}

class Lock
{
}