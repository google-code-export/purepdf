package org.purepdf.pdf
{
	import org.purepdf.Font;
	import org.purepdf.elements.Chunk;
	import org.purepdf.elements.Phrase;
	import org.purepdf.pdf.fonts.BaseFont;
	import org.purepdf.utils.StringUtils;
	import org.purepdf.utils.Utilities;

	public class FontSelector
	{
		protected var fonts: Vector.<Font> = new Vector.<Font>();
		
		public function FontSelector()
		{
		}
		
		/**
		 * Process the text so that it will render with a combination of fonts
		 * if needed.
		 */    
		public function process( text: String ): Phrase
		{
			var fsize: int = fonts.length;
			if (fsize == 0)
				throw new TypeError("no font is defined");
			
			var cc: Vector.<int> = StringUtils.toCharArray( text );
			var len: int = cc.length;
			var sb: String = "";
			var font: Font = null;
			var lastidx: int = -1;
			var f: int;
			var ck: Chunk;
			var ret: Phrase = new Phrase(null,null);
			
			for (var k: int = 0; k < len; ++k )
			{
				var c: int = cc[k];
				if( c == 10 || c == 13 ) {
					sb += String.fromCharCode( c );
					continue;
				}
				
				if( Utilities.isSurrogatePair(cc, k) )
				{
					var u: int = Utilities.convertToUtf32_3(cc, k);
					
					for( f = 0; f < fsize; ++f )
					{
						font = fonts[f];
						if( font.baseFont.charExists(u) )
						{
							if( lastidx != f )
							{
								if( sb.length > 0 && lastidx != -1 )
								{
									ck = new Chunk( sb, fonts[lastidx] );
									ret.add(ck);
									sb = "";
								}
								lastidx = f;
							}
							sb += String.fromCharCode(c);
							sb += String.fromCharCode(cc[++k]);
							break;
						}
					}
				}
				else {
					for ( f = 0; f < fsize; ++f )
					{
						font = fonts[f];
						if ( font.baseFont.charExists(c)) {
							if (lastidx != f) {
								if (sb.length > 0 && lastidx != -1) {
									ck = new Chunk( sb, fonts[lastidx]);
									ret.add(ck);
									sb = "";
								}
								lastidx = f;
							}
							sb += String.fromCharCode(c);
							break;
						}
					}
				}
			}
			if (sb.length > 0) {
				ck = new Chunk(sb, fonts[lastidx == -1 ? 0 : lastidx] );
				ret.add(ck);
			}
			return ret;
		}
		
		public function addFont( value: Font ): void
		{
			if( value.baseFont != null )
			{
				fonts.push( value );
				return;
			}
			
			var bf: BaseFont = value.getCalculatedBaseFont(true);
			var f2: Font = Font.fromBaseFont( bf, value.size, value.getCalculatedSize(), value.color );
			fonts.push( f2 );
		}
	}
}