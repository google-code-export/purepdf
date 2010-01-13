package org.purepdf.pdf
{
	import it.sephiroth.utils.Entry;
	import it.sephiroth.utils.HashMap;
	import it.sephiroth.utils.ObjectHash;
	import it.sephiroth.utils.collections.iterators.Iterator;
	
	import org.purepdf.Font;
	import org.purepdf.ISplitCharacter;
	import org.purepdf.elements.Chunk;
	import org.purepdf.elements.images.ImageElement;
	import org.purepdf.errors.NonImplementatioError;
	import org.purepdf.pdf.fonts.BaseFont;
	import org.purepdf.pdf.interfaces.IHyphenationEvent;
	import org.purepdf.utils.StringUtils;
	import org.purepdf.utils.Utilities;

	public class PdfChunk extends ObjectHash
	{
		private static const ITALIC_ANGLE: Number = 0.21256;
		private static const singleSpace: Vector.<int> = Vector.<int>( [ 32 ] );
		private static const thisChunk: Vector.<PdfChunk> = new Vector.<PdfChunk>( 1 );

		private static var _keysNoStroke: HashMap;
		private static var _keysAttributes: HashMap;
		
		protected var value: String = PdfObject.NOTHING;
		protected var encoding: String = BaseFont.WINANSI;
		protected var font: PdfFont;
		protected var baseFont: BaseFont;
		protected var splitCharacter: ISplitCharacter;
		protected var attributes: HashMap = new HashMap();
		protected var noStroke: HashMap = new HashMap();
		protected var newlineSplit: Boolean;
		protected var _image: ImageElement;
		protected var _offsetX: Number;
		protected var _offsetY: Number;
		protected var _changeLeading: Boolean = false;
		
		public function get changeLeading():Boolean
		{
			return _changeLeading;
		}
		
		public function set imageOffsetX( value: Number ): void
		{
			_offsetX = value;
		}

		public function get imageOffsetX():Number
		{
			return _offsetX;
		}
		
		public function set imageOffsetY( value: Number ): void
		{
			_offsetY = value;
		}

		public function get imageOffsetY():Number
		{
			return _offsetY;
		}

		private static function init_keysAttributes(): void
		{
			_keysAttributes = new HashMap();
			_keysAttributes.put( Chunk.ACTION, null );
			_keysAttributes.put( Chunk.UNDERLINE, null );
			_keysAttributes.put( Chunk.REMOTEGOTO, null );
			_keysAttributes.put( Chunk.LOCALGOTO, null );
			_keysAttributes.put( Chunk.LOCALDESTINATION, null );
			_keysAttributes.put( Chunk.GENERICTAG, null );
			_keysAttributes.put( Chunk.NEWPAGE, null );
			_keysAttributes.put( Chunk.IMAGE, null );
			_keysAttributes.put( Chunk.BACKGROUND, null );
			_keysAttributes.put( Chunk.PDFANNOTATION, null );
			_keysAttributes.put( Chunk.SKEW, null );
			_keysAttributes.put( Chunk.HSCALE, null );
			_keysAttributes.put( Chunk.SEPARATOR, null );
			_keysAttributes.put( Chunk.TAB, null );
			_keysAttributes.put( Chunk.CHAR_SPACING, null );
		}
		
		private static function init_keysNoStroke(): void
		{
			_keysNoStroke = new HashMap();
			_keysNoStroke.put( Chunk.SUBSUPSCRIPT, null );
			_keysNoStroke.put( Chunk.SPLITCHARACTER, null );
			_keysNoStroke.put( Chunk.HYPHENATION, null );
			_keysNoStroke.put( Chunk.TEXTRENDERMODE, null );
		}
		
		public static function get keysAttributes(): HashMap
		{
			if( _keysAttributes == null )
				init_keysAttributes();
			return _keysAttributes;
		}
		
		public static function get keysNoStroke(): HashMap
		{
			if( _keysNoStroke == null )
				init_keysNoStroke();
			return _keysNoStroke;
		}
		
		internal function getAttribute( name: String ): Object
		{
			if( attributes.containsKey( name ) )
				return attributes.getValue( name );
			return noStroke.getValue( name );
		}

		internal function adjustLeft( newValue: Number ): void
		{
			var o: Vector.<Object> = attributes.getValue( Chunk.TAB ) as Vector.<Object>;
			if( o != null ) 
				attributes.put( Chunk.TAB, Vector.<Object>([ o[0], o[1], o[2], newValue ]) );
		}
		
		public function get image(): ImageElement
		{
			return _image;
		}

		/**
		 * Trim the first space and return the
		 * width of the space trimmed
		 */
		public function trimFirstSpace(): Number
		{
			var ft: BaseFont = font.font;
			if( ft.fontType == BaseFont.FONT_TYPE_CJK && ft.getUnicodeEquivalent(32) != 32)
			{
				trace('warning, unicode');
				if( value.length > 1 && StringUtils.startsWith( value, "\u0001" ) )
				{
					value = value.substring(1);
					return font.getWidth(1);
				}
			} else 
			{
				if( value.length > 1 && StringUtils.startsWith( value, " " ) )
				{
					value = value.substring(1);
					return font.getWidth(32);
				}
			}
			return 0;
		}

		
		/**
		 * Trim the last space.
		 * @return the width of the space trimmed
		 */
		public function trimLastSpace(): Number
		{
			var ft: BaseFont = font.font;
			if( ft.fontType == BaseFont.FONT_TYPE_CJK && ft.getUnicodeEquivalent(32) != 32 ) 
			{
				trace('warning, unicode');
				if( value.length > 1 && StringUtils.endsWith( value, "\u0001") )
				{
					value = value.substring( 0, value.length - 1 );
					return font.getWidth(1);
				}
			} else 
			{
				if( value.length > 1 && StringUtils.endsWith( value, " ") )
				{
					value = value.substring(0, value.length - 1);
					return font.getWidth( 32 );
				}
			}
			return 0;
		}
		
		internal function get width(): Number
		{
			if( isAttribute( Chunk.CHAR_SPACING ) )
			{
				var cs: Number = Number( getAttribute( Chunk.CHAR_SPACING ) );
				return font.getWidth( value ) + value.length * cs;
			}
			return font.getWidth( value );
		}
		
		public function isImage(): Boolean
		{
			return _image != null;
		}
		
		public function toString(): String
		{
			return value;
		}
		
		public function isTab(): Boolean
		{
			return isAttribute( Chunk.TAB );
		}
		
		internal function isAttribute( name: String ): Boolean
		{
			if( attributes.containsKey( name ) )
				return true;
			return noStroke.containsKey( name );
		}
		
		public function isNewlineSplit(): Boolean
		{
			return newlineSplit;
		}
		
		internal function get length(): int
		{
			return value.length;
		}
		
		internal function truncate( width: Number ): PdfChunk
		{
			throw new NonImplementatioError();
		}
		
		/**
		 * Splits this <CODE>PdfChunk</CODE> if it's too long for the given width.
		 * <P>
		 * Returns <VAR>null</VAR> if the <CODE>PdfChunk</CODE> wasn't truncated.
		 * 
		 * @param width
		 *            a given width
		 * @return the <CODE>PdfChunk</CODE> that doesn't fit into the width.
		 */
		
		internal function split( width: Number ): PdfChunk
		{
			newlineSplit = false;
			if( _image != null)
			{
				throw new NonImplementatioError("image not supported here");
			}
			var hyphenationEvent: IHyphenationEvent = noStroke.getValue( Chunk.HYPHENATION ) as IHyphenationEvent;
			var currentPosition: int = 0;
			var splitPosition: int = -1;
			var currentWidth: Number = 0;
			var lastSpace: int = -1;
			var lastSpaceWidth: Number = 0;
			var length: int = value.length;
			var valueArray: Vector.<int> = StringUtils.toCharArray( value );
			var character: uint = 0;
			var ft: BaseFont = font.font;
			var surrogate: Boolean = false;
			
			var returnValue: String;
			var pc: PdfChunk;
			
			if (ft.fontType == BaseFont.FONT_TYPE_CJK && ft.getUnicodeEquivalent( 32 ) != 32 ) 
			{
				while( currentPosition < length )
				{
					var cidChar: int = valueArray[ currentPosition ];
					character = uint(ft.getUnicodeEquivalent( cidChar ));
					if( character == 10 )	// \n
					{
						newlineSplit = true;
						returnValue = value.substring(currentPosition + 1);
						value = value.substring(0, currentPosition);
						if( value.length < 1 )
							value = "\u0001";
						
						pc = PdfChunk.createFromString( returnValue, this );
						return pc;
					}
					
					currentWidth += getCharWidth( cidChar );
					if (character == 32 )	// ' '
					{
						lastSpace = currentPosition + 1;
						lastSpaceWidth = currentWidth;
					}
					
					if( currentWidth > width )
						break;
					
					if( splitCharacter.isSplitCharacter(0, currentPosition, length, valueArray, thisChunk))
						splitPosition = currentPosition + 1;
					currentPosition++;
				}
			} else {
				while( currentPosition < length )
				{
					character = valueArray[currentPosition];
					if( character == 13 || character == 10 )
					{
						newlineSplit = true;
						var inc: int = 1;
						if( character == 13 && currentPosition + 1 < length && valueArray[currentPosition + 1] == 10 )
							inc = 2;
						
						returnValue = value.substring(currentPosition + inc);
						value = value.substring(0, currentPosition);
						if (value.length < 1)
							value = " ";

						pc = PdfChunk.createFromString( returnValue, this );
						return pc;
					}
					
					surrogate = Utilities.isSurrogatePair( valueArray, currentPosition );
					
					if (surrogate)
						currentWidth += getCharWidth( Utilities.convertToUtf32( valueArray[ currentPosition ], valueArray[ currentPosition + 1 ] ) );
					else
						currentWidth += getCharWidth(character);
					if (character == 32)
					{
						lastSpace = currentPosition + 1;
						lastSpaceWidth = currentWidth;
					}
					
					if (surrogate)
						currentPosition++;
					
					if (currentWidth > width)
						break;
					
					if( splitCharacter.isSplitCharacter(0, currentPosition, length, valueArray, null))
						splitPosition = currentPosition + 1;
					currentPosition++;
				}
			}
			
			if (currentPosition == length)
			{
				return null;
			}
			// otherwise, the string has to be truncated
			if (splitPosition < 0) 
			{
				returnValue = value;
				value = "";
				pc = PdfChunk.createFromString( returnValue, this );
				return pc;
			}
			
			if( lastSpace > splitPosition && splitCharacter.isSplitCharacter(0, 0, 1, singleSpace, null))
				splitPosition = lastSpace;
			if (hyphenationEvent != null && lastSpace >= 0 && lastSpace < currentPosition)
			{
				var wordIdx: int = getWord( value, lastSpace );
				if( wordIdx > lastSpace ) 
				{
					var pre: String = hyphenationEvent.getHyphenatedWordPre( value.substring(lastSpace, wordIdx), font.font, font.size, width - lastSpaceWidth );
					var post: String = hyphenationEvent.getHyphenatedWordPost();
					if( pre.length > 0 )
					{
						returnValue = post + value.substring(wordIdx);
						value = StringUtils.trim( value.substring(0, lastSpace) + pre );
						pc = PdfChunk.createFromString( returnValue, this );
						return pc;
					}
				}
			}
			
			returnValue = value.substring(splitPosition);
			value = StringUtils.trim(value.substring(0, splitPosition));
			pc = PdfChunk.createFromString( returnValue, this );
			return pc;
		}
		
		public static function createFromString( string: String, other: PdfChunk ): PdfChunk
		{
			var chunk: PdfChunk = new PdfChunk();
			thisChunk[0] = chunk;
			chunk.value = string;
			chunk.font = other.font;
			chunk.attributes = other.attributes;
			chunk.noStroke = other.noStroke;
			chunk.baseFont = other.baseFont;
			var obj: Vector.<Object> = chunk.attributes.getValue( Chunk.IMAGE ) as Vector.<Object>;
			
			if( obj == null )
			{
				chunk._image = null;
			} else 
			{
				chunk._image = obj[0] as ImageElement;
				chunk._offsetX = obj[1] as Number;
				chunk._offsetY = obj[2] as Number;
				chunk._changeLeading = obj[3];
			}
			
			chunk.encoding = chunk.font.font.encoding;
			chunk.splitCharacter = chunk.noStroke.getValue( Chunk.SPLITCHARACTER ) as ISplitCharacter;
			if ( chunk.splitCharacter == null)
				chunk.splitCharacter = DefaultSplitCharacter.DEFAULT;
			
			return chunk;
		}
		
		
		public function PdfChunk()
		{
		}
		
		internal function isHorizontalSeparator(): Boolean
		{
			if( isAttribute(Chunk.SEPARATOR) )
			{
				var o: Vector.<Object> = Vector.<Object>( getAttribute(Chunk.SEPARATOR) );
				return !Boolean(o[1]);
			}
			return false;
		}
		
		public static function createFromChunk( chunk: Chunk, action: PdfAction ): PdfChunk
		{
			var result: PdfChunk = new PdfChunk();
			
			thisChunk[0] = result;
			result.value = chunk.content;
			
			var f: Font = chunk.font;
			var size: Number = f.size;
			var style: int = f.style;
			
			if( size == Font.UNDEFINED )
				size = 12;
			
			result.baseFont = f.baseFont;
			
			if( style == Font.UNDEFINED)
				style = Font.NORMAL;
			
			if( result.baseFont == null)
			{
				result.baseFont = f.getCalculatedBaseFont( false );
			} else 
			{
				// bold simulation
				if( ( style & Font.BOLD) != 0 )
					result.attributes.put(
						Chunk.TEXTRENDERMODE,
						Vector.<Object>([
							PdfContentByte.TEXT_RENDER_MODE_FILL_STROKE,
							size / 30,
							null]
						)
					);
				// italic simulation
				if( ( style & Font.ITALIC) != 0 )
					result.attributes.put( Chunk.SKEW, Vector.<Number>([ 0, ITALIC_ANGLE ]) );
			}
			
			result.font = new PdfFont( result.baseFont, size );
			// other style possibilities
			var attr: HashMap = chunk.attributes;
			
			if( attr != null )
			{
				for( var i: Iterator = attr.entrySet().iterator(); i.hasNext();)
				{
					var entry: Entry = Entry( i.next() );
					var name: Object = entry.getKey();
					if( keysAttributes.containsKey(name) )
						result.attributes.put(name, entry.getValue());
					else if (keysNoStroke.containsKey(name))
						result.noStroke.put(name, entry.getValue());
				}
				if( "" == attr.getValue( Chunk.GENERICTAG ) )
					result.attributes.put( Chunk.GENERICTAG, chunk.content );
			}
			
			var obj: Vector.<Object>;
			var unders: Vector.<Vector.<Object>>;
			
			if( f.isUnderline )
			{
				obj = Vector.<Object>([ null, Vector.<Number>([ 0, 1 / 15, 0, -1 / 3, 0 ]) ]);
				unders = Utilities.addToArray( Vector.<Vector.<Object>>(result.attributes.getValue( Chunk.UNDERLINE )), obj );
				result.attributes.put( Chunk.UNDERLINE, unders );
			}
			
			if( f.isStrikethru )
			{
				obj = Vector.<Object>([ null, Vector.<Number>([ 0, 1 / 15, 0, 1 / 3, 0 ]) ]);
				unders = Utilities.addToArray( Vector.<Vector.<Object>>( result.attributes.getValue( Chunk.UNDERLINE )), obj );
				result.attributes.put(Chunk.UNDERLINE, unders);
			}
			
			if( action != null )
				result.attributes.put( Chunk.ACTION, action );
			
			// the color can't be stored in a PdfFont
			result.noStroke.put( Chunk.COLOR, f.color );
			result.noStroke.put( Chunk.ENCODING, result.font.font.encoding );
			obj = result.attributes.getValue( Chunk.IMAGE ) as Vector.<Object>;
			
			if( obj == null )
			{
				result._image = null;
			} else 
			{
				result.attributes.remove( Chunk.HSCALE );
				result._image = obj[0] as ImageElement;
				result._offsetX = obj[1] as Number;
				result._offsetY = obj[2] as Number;
				result._changeLeading = obj[3];
			}
			result.font.image = result._image;
			
			var tmp_hs: Object = result.attributes.getValue( Chunk.HSCALE );
			var hs: Number;
			if( tmp_hs != null ) hs = Number(hs);
			
			if( !isNaN( hs ) )
				result.font.horizontalScaling = hs;
			
			result.encoding = result.font.font.encoding;
			result.splitCharacter = result.noStroke.getValue( Chunk.SPLITCHARACTER ) as ISplitCharacter;
			
			if( result.splitCharacter == null )
				result.splitCharacter = DefaultSplitCharacter.DEFAULT;
			
			return result;
		}
		
		/**
		 * Gets the Unicode equivalent to a CID
		 */
		public function getUnicodeEquivalent( c: int ): int 
		{
			return baseFont.getUnicodeEquivalent(c);
		}
		
		protected function getWord( text: String, start: int ): int
		{
			throw new NonImplementatioError("getWord not yet implemented!");
			var len: int = text.length;
			while( start < len )
			{
				if( !Character.isLetter(text.charAt(start)))
					break;
				++start;
			}
			return start;
		}
		
		internal function getCharWidth( c: int ): Number
		{
			if( noPrint( c ) )
				return 0;
			
			if( isAttribute(Chunk.CHAR_SPACING) )
			{
				var cs: Number = getAttribute( Chunk.CHAR_SPACING ) as Number;
				return font.getWidth( c ) + cs;
			}
			return font.getWidth( c );
		}
		
		public static function noPrint( c: int ): Boolean
		{
			return ((c >= 0x200b && c <= 0x200f) || (c >= 0x202a && c <= 0x202e));
		}


	}
}