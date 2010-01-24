package org.purepdf.pdf.fonts
{
	import it.sephiroth.utils.HashMap;
	
	import org.purepdf.errors.DocumentError;
	import org.purepdf.errors.NonImplementatioError;
	import org.purepdf.pdf.PdfIndirectReference;
	import org.purepdf.pdf.PdfWriter;
	import org.purepdf.utils.Bytes;
	import org.purepdf.utils.StringUtils;
	import org.purepdf.utils.Utilities;

	public class TrueTypeFontUnicode extends TrueTypeFont
	{
		private var vertical: Boolean = false;

		public function TrueTypeFontUnicode()
		{
			super();
		}
		
		override public function init( $ttFile: String, $enc: String, $emb: Boolean, $ttfAfm: Vector.<int>, $justNames: Boolean, $forceRead: Boolean ): void
		{
			var nameBase: String = getBaseName( $ttFile );
			var ttcName: String = getTTCName( nameBase );

			if ( nameBase.length < $ttFile.length )
			{
				style = $ttFile.substring( nameBase.length );
			}
			
			_encoding = $enc;
			embedded = $emb;
			fileName = ttcName;
			ttcIndex = "";

			if ( ttcName.length < nameBase.length )
				ttcIndex = nameBase.substring( ttcName.length + 1 );
			_fontType = FONT_TYPE_TTUNI;

			if ( ( StringUtils.endsWith( fileName.toLowerCase(), ".ttf" ) || StringUtils.endsWith( fileName.toLowerCase(),
							".otf" ) || StringUtils.endsWith( fileName.toLowerCase(), ".ttc" ) ) && ( ( $enc == IDENTITY_H || $enc ==
							IDENTITY_V ) && $emb ) )
			{
				
				rf = FontsResourceFactory.getInstance().getFontFile( fileName );
				rf.position = 0;
				
				process( $forceRead );

				if ( os_2.fsType == 2 )
					throw new DocumentError( fileName + " cannot be embedded due to licensing restrictions" );

				if ( ( cmap31 == null && !_fontSpecific ) || ( cmap10 == null && _fontSpecific ) )
					directTextToByte = true;

				if ( _fontSpecific )
				{
					_fontSpecific = false;
					var tempEncoding: String = encoding;
					_encoding = "";
					createEncoding();
					_encoding = tempEncoding;
					_fontSpecific = true;
				}
			} else
			{
				throw new DocumentError( fileName + " is not a ttf font file" );
			}
			vertical = StringUtils.endsWith( $enc, "V" );
		}
		
		override internal function convertToByte(char1:int) : Bytes
		{
			return null;
		}
		
		override internal function convertToBytes(char1:String) : Bytes
		{
			return null;
		}
		
		override public function getMetricsTT(c:int) : Vector.<int>
		{
			if( cmapExt != null )
				return cmapExt.getValue(c) as Vector.<int>;
			
			var map: HashMap = null;
			
			if (_fontSpecific)
				map = cmap10;
			else
				map = cmap31;
			
			if (map == null)
				return null;
			
			if( _fontSpecific )
			{
				if ((c & 0xffffff00) == 0 || (c & 0xffffff00) == 0xf000)
					return map.getValue(c & 0xff) as Vector.<int>;
				else
					return null;
			} else
			{
				return map.getValue( c ) as Vector.<int>;
			}
			return null;
		}
		
		override public function charExists(c:int) : Boolean
		{
			return getMetricsTT(c) != null;
		}
		
		
		override protected function _getWidthI( code: int ): int
		{
			if ( vertical )
				return 1000;

			if ( _fontSpecific )
			{
				if ( ( code & 0xFF00 ) == 0 || ( code & 0xFF00 ) == 0xF000 )
					return getRawWidth( code & 0xFF, null );
				else
					return 0;
			} else
			{
				return getRawWidth( code, encoding );
			}
		}

		override protected function _getWidthS( text: String ): int
		{
			if ( vertical )
				return text.length * 1000;
			var total: int = 0;
			var k: int;
			var c: int;
			var len: int;

			if ( _fontSpecific )
			{
				var cc: Vector.<int> = StringUtils.toCharArray( text );
				len = cc.length;

				for ( k = 0; k < len; ++k )
				{
					c = cc[k];

					if ( ( c & 0xff00 ) == 0 || ( c & 0xff00 ) == 0xf000 )
						total += getRawWidth( c & 0xff, null );
				}
			} else
			{
				len = text.length;

				for ( k = 0; k < len; ++k )
				{
					if ( Utilities.isSurrogatePair2( text, k ) )
					{
						total += getRawWidth( Utilities.convertToUtf32_2( text, k ), encoding );
						++k;
					} else
					{
						total += getRawWidth( text.charCodeAt( k ), encoding );
					}
				}
			}
			return total;
		}
		
		override internal function writeFont(writer:PdfWriter, ref:PdfIndirectReference, params:Vector.<Object>) : void
		{
			throw new NonImplementatioError();
		}
	}
}