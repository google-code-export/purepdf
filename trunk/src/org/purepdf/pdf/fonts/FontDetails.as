package org.purepdf.pdf.fonts
{
	import flash.utils.Dictionary;
	
	import it.sephiroth.utils.HashMap;
	import it.sephiroth.utils.ObjectHash;
	
	import org.purepdf.errors.ConversionError;
	import org.purepdf.errors.NonImplementatioError;
	import org.purepdf.pdf.PdfIndirectReference;
	import org.purepdf.pdf.PdfName;
	import org.purepdf.pdf.PdfWriter;
	import org.purepdf.utils.Bytes;
	import org.purepdf.utils.pdf_core;

	[ExcludeClass]
	public class FontDetails extends ObjectHash
	{
		protected var _subset: Boolean = true;
		private var _baseFont: BaseFont;
		private var _cjkTag: Dictionary;
		private var _fontName: PdfName;
		private var _fontType: int;
		private var _indirectReference: PdfIndirectReference;
		private var _longTag: HashMap;
		private var _shortTag: Vector.<int>;
		private var _symbolic: Boolean;

		/**
		 * Each font used in a document has an instance of this class.
		 * This class stores the characters used in the document and other
		 * specifics unique to the current working document.
		 */
		public function FontDetails( $fontName: PdfName, $indirectReference: PdfIndirectReference, $baseFont: BaseFont )
		{
			_fontName = $fontName;
			_indirectReference = $indirectReference;
			_baseFont = $baseFont;
			_fontType = $baseFont.fontType;

			switch ( _fontType )
			{
				case BaseFont.FONT_TYPE_T1:
				case BaseFont.FONT_TYPE_TT:
					_shortTag = new Vector.<int>( 256 );
					break;
				
				case BaseFont.FONT_TYPE_CJK:
					throw new NonImplementatioError( "FontType CJK not yet supported" );
					break;
				
				case BaseFont.FONT_TYPE_TTUNI:
					throw new NonImplementatioError( "TrueType unicode not yet supported" );
					break;
			}
		}
		
		/**
		 * Convert a string into <code>Bytes</code> to be placed in the document.
		 * The conversion is done according to the font and the encoding and the characters
		 * used are stored.
		 * 
		 * @see org.purepdf.utils.Bytes
		 */
		pdf_core function convertToBytes( text: String ): Bytes
		{
			var b: Bytes = null;
			var len: int;
			var k: int;
			
			switch( _fontType )
			{
				case BaseFont.FONT_TYPE_T3:
					return baseFont.convertToBytes( text );
					
				case BaseFont.FONT_TYPE_T1:
				case BaseFont.FONT_TYPE_TT:
					b = baseFont.convertToBytes(text);
					len = b.length;
					for( k = 0; k < len; ++k )
						_shortTag[ b[k] & 0xff ] = 1;
					break;
				
				case BaseFont.FONT_TYPE_CJK:
					len = text.length;
					for( k = 0; k < len; ++k )
						throw new NonImplementatioError();
					b = baseFont.convertToBytes( text );
					break;
				
				case BaseFont.FONT_TYPE_DOCUMENT:
					b = baseFont.convertToBytes( text );
					break;
				
				case BaseFont.FONT_TYPE_TTUNI:
					throw new NonImplementatioError();
					break;
			}
			return b;
		}
		
		/**
		 * Write the font definition to the document
		 * @see PdfWriter
		 */
		pdf_core function writeFont( writer: PdfWriter ): void
		{
			try
			{
				switch( _fontType )
				{
					case BaseFont.FONT_TYPE_T3:
						baseFont.writeFont( writer, indirectReference, null );
						break;
					
					case BaseFont.FONT_TYPE_T1:
					case BaseFont.FONT_TYPE_TT:
						var firstChar: int;
						var lastChar: int;
						for( firstChar = 0; firstChar < 256; ++firstChar )
						{
							if( _shortTag[firstChar] != 0 )
								break;
						}
						
						for( lastChar = 255; lastChar >= firstChar; --lastChar )
						{
							if( _shortTag[lastChar] != 0 )
								break;
						}
						
						if( firstChar > 255 )
						{
							firstChar = 255;
							lastChar = 255;
						}
						
						baseFont.writeFont( writer, indirectReference, Vector.<Object>([firstChar, lastChar, _shortTag, subset ]) );
						break;
					
					case BaseFont.FONT_TYPE_CJK:
						baseFont.writeFont( writer, indirectReference, Vector.<Object>([_cjkTag]) );
						break;
					
					case BaseFont.FONT_TYPE_TTUNI:
						baseFont.writeFont( writer, indirectReference, Vector.<Object>([_longTag, subset]) );
						break;
				}
			} catch( e: Error ) {
				throw new ConversionError( e );
			}
		}

		public function get baseFont(): BaseFont
		{
			return _baseFont;
		}

		public function get fontName(): PdfName
		{
			return _fontName;
		}

		public function get fontType(): int
		{
			return _fontType;
		}

		public function get indirectReference(): PdfIndirectReference
		{
			return _indirectReference;
		}

		/**
		 * Indicates if all the glyphs and widths for that particular
		 * encoding should be included in the document.
		 * @return false to include all the glyphs and widths.
		 */
		public function get subset(): Boolean
		{
			return _subset;
		}

		public function set subset( value: Boolean ): void
		{
			_subset = value;
		}

		public function get symbolic(): Boolean
		{
			return _symbolic;
		}
	}
}