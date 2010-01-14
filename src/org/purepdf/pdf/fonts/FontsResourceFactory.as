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
		[Embed( source="Helvetica.afm", mimeType="application/octet-stream" )]
		private var helvetica_afm: Class;
		
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
			fontsMap.put( BaseFont.HELVETICA + ".afm", helvetica_afm );
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
		 * You can register a new font passing the bytearray class
		 * of an embedded resource
		 * Example<p>
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
		 * 
		 * @param name	The font name (eg. "Helvetica")
		 */
		public function registerFont( name: String, file: Class ): void
		{
			fontsMap.put( name + ".afm", file );
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