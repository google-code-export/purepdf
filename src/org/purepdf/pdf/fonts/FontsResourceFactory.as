package org.purepdf.pdf.fonts
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.purepdf.utils.StringUtils;

	/**
	 * Use this class if you want to register more fonts to 
	 * be used with the document
	 */
	public class FontsResourceFactory
	{

		private static var instance: FontsResourceFactory;
		private var fontsMap: Dictionary;

		/**
		 * Do not use constructor to initialize this class but <code>getInstance</code>
		 * should be used
		 * 
		 * @see FontsResourceFactory#getInstance()
		 */
		public function FontsResourceFactory( lock: Lock )
		{
			if ( lock == null )
				throw new Error( "Cannot instantiate a new FontsResourceFactory. Use getInstance instead" );

			fontsMap = new Dictionary();
		}

		/**
		 * Return true if a font is already registered
		 * @param name the font name. eg. "Helvetica"
		 * @see #registerFont()
		 */
		public function fontIsRegistered( name: String ): Boolean
		{
			if ( StringUtils.endsWith( name, ".afm" ) )
				return fontsMap[name] != null;
			return fontsMap[ name + ".afm" ] != null;
		}

		public function getFontFile( filename: String ): ByteArray
		{
			if ( fontsMap[filename] )
				return new( fontsMap[ filename ] )();
			return null;
		}

		/**
		 * <p>You can register a new font passing the bytearray class
		 * of an embedded resource</p>
		 * <p>Example
		 * <pre>
		 * [Embed(source="assets/fonts/Helvetica-Bold.afm", mimeType="application/octet-stream")]
		 * private var helveticaB: Class;
		 * public function main()
		 * {
		 *	// this will register a custom, user defined font
		 *	FontsResourceFactory.getInstance().registerFont( BaseFont.HELVETICA_BOLD, helveticaB );
		 *	// register a new font, using one of the builtin fonts
		 *	FontsResourceFactory.getInstance().registerFont( BaseFont.HELVETICA, BuiltinFonts.HELVETICA );
		 *	var font: Font = new Font( Font.HELVETICA, 18, Font.BOLD );
		 *	document.addElement( new Paragraph("Hello world", font) );
		 * }
		 * </pre>
		 * </p>
		 * 
		 * <p>You can use the built-in fonts embedded into the separate BuiltinFonts class</p>
		 * 
		 * @param name	The font name (eg. "Helvetica")
		 * @see BuiltinFonts
		 */
		public function registerFont( name: String, file: Class ): void
		{
			fontsMap[ name ] = file;
		}

		/**
		 * Return the singleton of FontsResourceFactory
		 * 
		 * @see #registerFont()
		 * @see #fontIsRegistered()
		 * @see #getFontFile()
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