package org.purepdf
{
	import flash.utils.Dictionary;
	
	import it.sephiroth.utils.HashMap;
	
	import org.purepdf.colors.RGBColor;
	import org.purepdf.errors.NonImplementatioError;
	import org.purepdf.pdf.fonts.BaseFont;
	
	public class FontFactoryImp implements IFontProvider
	{
		private var trueTypeFonts: Dictionary = new Dictionary( false );
		private var fontFamilies: HashMap = new HashMap();
		public var defaultEncoding: String = BaseFont.WINANSI;
		public var defaultEmbedding: Boolean = BaseFont.NOT_EMBEDDED;
		
		public function FontFactoryImp()
		{
			// register all true type fonts
			trueTypeFonts[ FontFactory.COURIER.toLowerCase() ] = FontFactory.COURIER;
			trueTypeFonts[ FontFactory.COURIER_BOLD.toLowerCase() ] = FontFactory.COURIER_BOLD;
			trueTypeFonts[ FontFactory.COURIER_BOLDOBLIQUE.toLowerCase() ] = FontFactory.COURIER_BOLDOBLIQUE;
			trueTypeFonts[ FontFactory.COURIER_OBLIQUE.toLowerCase() ] = FontFactory.COURIER_OBLIQUE;
			trueTypeFonts[ FontFactory.HELVETICA.toLowerCase() ] = FontFactory.HELVETICA;
			trueTypeFonts[ FontFactory.HELVETICA_BOLD.toLowerCase() ] = FontFactory.HELVETICA_BOLD;
			trueTypeFonts[ FontFactory.HELVETICA_BOLDOBLIQUE.toLowerCase() ] = FontFactory.HELVETICA_BOLDOBLIQUE;
			trueTypeFonts[ FontFactory.HELVETICA_OBLIQUE.toLowerCase() ] = FontFactory.HELVETICA_OBLIQUE;
			trueTypeFonts[ FontFactory.SYMBOL.toLowerCase() ] = FontFactory.SYMBOL;
			trueTypeFonts[ FontFactory.TIMES.toLowerCase() ] = FontFactory.TIMES;
			trueTypeFonts[ FontFactory.TIMES_BOLD.toLowerCase() ] = FontFactory.TIMES_BOLD;
			trueTypeFonts[ FontFactory.TIMES_BOLDITALIC.toLowerCase() ] = FontFactory.TIMES_BOLDITALIC;
			trueTypeFonts[ FontFactory.TIMES_ITALIC.toLowerCase() ] = FontFactory.TIMES_ITALIC;
			trueTypeFonts[ FontFactory.TIMES_ROMAN.toLowerCase() ] = FontFactory.TIMES_ROMAN;
			trueTypeFonts[ FontFactory.ZAPFDINGBATS.toLowerCase() ] = FontFactory.ZAPFDINGBATS;
			
			// courier
			var tmp: Vector.<String> = new Vector.<String>();
			tmp.push( FontFactory.COURIER );
			tmp.push( FontFactory.COURIER_BOLD );
			tmp.push( FontFactory.COURIER_BOLDOBLIQUE );
			tmp.push( FontFactory.COURIER_OBLIQUE );
			fontFamilies.put( FontFactory.COURIER.toLowerCase(), tmp );
			
			// helvetica
			tmp = new Vector.<String>();
			tmp.push( FontFactory.HELVETICA );
			tmp.push( FontFactory.HELVETICA_BOLD );
			tmp.push( FontFactory.HELVETICA_BOLDOBLIQUE );
			tmp.push( FontFactory.HELVETICA_OBLIQUE );
			fontFamilies.put( FontFactory.HELVETICA.toLowerCase(), tmp );
			
			// times
			tmp = new Vector.<String>();
			tmp.push( FontFactory.TIMES );
			tmp.push( FontFactory.TIMES_BOLD );
			tmp.push( FontFactory.TIMES_BOLDITALIC );
			tmp.push( FontFactory.TIMES_ITALIC );
			tmp.push( FontFactory.TIMES_ROMAN );
			fontFamilies.put( FontFactory.TIMES.toLowerCase(), tmp );
			
			// symbol
			tmp = new Vector.<String>();
			tmp.push( FontFactory.SYMBOL );
			fontFamilies.put( FontFactory.SYMBOL, tmp );
			
			// z
			tmp = new Vector.<String>();
			tmp.push( FontFactory.ZAPFDINGBATS );
			fontFamilies.put( FontFactory.ZAPFDINGBATS.toLowerCase(), tmp );
			
		}
		
		public function isRegistered(fontname:String):Boolean
		{
			return false;
		}
		
		public function getFont(fontname:String, encoding:String, embedded:Boolean, size:Number, style:int, color:RGBColor):Font
		{
			return getFont1( fontname, encoding, embedded, size, style, color, true );
		}
		
		public function getFont1( fontname: String, encoding: String, embedded: Boolean, size: Number, style: int, color: RGBColor, cached: Boolean ): Font
		{
			if( fontname == null ) return new Font( Font.UNDEFINED, size, style, color );
			var lowercasefontname: String = fontname.toLowerCase();
			var tmp: Vector.<String> = fontFamilies.getValue( lowercasefontname ) as Vector.<String>;
			
			if( tmp != null )
			{
				var s: int = style == Font.UNDEFINED ? Font.NORMAL : style;
				var fs: int = Font.NORMAL;
				var found: Boolean = false;
				
				for( var k: int = 0; k < tmp.length; ++k )
				{
					var f: String = tmp[k];
					var lcf: String = f.toLowerCase();
					fs = Font.NORMAL;
					if( lcf.toLowerCase().indexOf("bold") != -1) fs |= Font.BOLD;
					if( lcf.toLowerCase().indexOf("italic") != -1 || lcf.toLowerCase().indexOf("oblique") != -1) fs |= Font.ITALIC;
					if( (s & Font.BOLDITALIC) == fs )
					{
						fontname = f;
						found = true;
						break;
					}
				}
				
				if( style != Font.UNDEFINED && found )
				{
					style &= ~fs;
				}
			}
			
			var basefont: BaseFont = null;
			
			throw new NonImplementatioError();
			
			return null;
		}
	}
}