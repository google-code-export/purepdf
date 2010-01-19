package org.purepdf
{
	import org.purepdf.elements.Chunk;
	import org.purepdf.errors.NonImplementatioError;
	import org.purepdf.lang.Character;
	import org.purepdf.pdf.PdfChunk;
	import org.purepdf.pdf.PdfLine;
	import org.purepdf.pdf.PdfWriter;
	import org.purepdf.pdf.fonts.BaseFont;
	import org.purepdf.utils.Utilities;
	import org.purepdf.utils.pdf_core;

	public class BidiLine
	{
		protected var chunks: Vector.<PdfChunk> = new Vector.<PdfChunk>();
		protected var currentChar: int = 0;
		protected var totalTextLength: int = 0;
		protected var indexChunk: int = 0;
		protected var runDirection: int;
		protected var indexChunkChar: int = 0;
		protected var arabicOptions: int;
		
		protected var storedRunDirection: int;
		protected var storedText: Vector.<int> = new Vector.<int>();
		protected var storedDetailChunks: Vector.<PdfChunk> = new Vector.<PdfChunk>();
		protected var storedTotalTextLength: int = 0;
		
		protected var storedOrderLevels: Vector.<int> = new Vector.<int>();
		protected var storedIndexChars: Vector.<int> = new Vector.<int>();
		
		protected var indexChars: Vector.<int> = new Vector.<int>(pieceSize);
		
		protected var storedIndexChunk: int = 0;
		protected var storedIndexChunkChar: int = 0;
		protected var storedCurrentChar: int = 0;
		
		protected var shortStore: Boolean;
		
		protected var pieceSize: int = 256;
		protected var text: Vector.<int> = new Vector.<int>( pieceSize );
		protected var detailChunks: Vector.<PdfChunk> = new Vector.<PdfChunk>( pieceSize );
		
		public function BidiLine()
		{
		}
		
		public function addPiece( c: int, chunk: PdfChunk ): void
		{
			if( totalTextLength >= pieceSize )
			{
				var tempText: Vector.<int> = text;
				var tempDetailChunks: Vector.<PdfChunk> = detailChunks;

				pieceSize *= 2;
				
				text = tempText.concat();
				text.length = totalTextLength;
				
				detailChunks = tempDetailChunks.concat();
				detailChunks.length = totalTextLength;
			}
			
			text[totalTextLength] = c;
			detailChunks[totalTextLength++] = chunk;
		}
		
		public function getParagraph( $runDirection: int ): Boolean
		{
			runDirection = $runDirection;
			currentChar = 0;
			totalTextLength = 0;
			
			var hasText: Boolean = false;
			var c: int;
			var uniC: int;
			var bf: BaseFont;
			
			for( ; indexChunk < chunks.length; ++indexChunk )
			{
				var ck: PdfChunk = chunks[indexChunk];
				bf = ck.font.font;
				var s: String = ck.toString();
				var len: int = s.length;
				for (; indexChunkChar < len; ++indexChunkChar) {
					c = s.charCodeAt( indexChunkChar );
					uniC = bf.getUnicodeEquivalent(c);
					if( uniC == 13 || uniC == 10 )
					{
						if( uniC == 13 && indexChunkChar + 1 < len && s.charCodeAt(indexChunkChar + 1) == 10 )
							++indexChunkChar;
						++indexChunkChar;
						if (indexChunkChar >= len) {
							indexChunkChar = 0;
							++indexChunk;
						}
						hasText = true;
						if (totalTextLength == 0)
							detailChunks[0] = ck;
						break;
					}
					addPiece(c, ck);
				}
				if (hasText)
					break;
				indexChunkChar = 0;
			}
			if (totalTextLength == 0)
				return hasText;
			
			// remove trailing WS
			totalTextLength = trimRight(0, totalTextLength - 1) + 1;
			if (totalTextLength == 0) {
				return true;
			}
			
			if (runDirection == PdfWriter.RUN_DIRECTION_LTR || runDirection == PdfWriter.RUN_DIRECTION_RTL)
				throw new NonImplementatioError("Run direction not yet supported");
			
			totalTextLength = trimRightEx(0, totalTextLength - 1) + 1;
			return true;
		}
		
		public function save(): void
		{
			if( indexChunk > 0 )
			{
				if( indexChunk >= chunks.length )
				{
					chunks.length = 0;
				} else 
				{
					for( --indexChunk; indexChunk >= 0; --indexChunk )
						chunks.splice(indexChunk, 1);
				}
				indexChunk = 0;
			}
			storedRunDirection = runDirection;
			storedTotalTextLength = totalTextLength;
			storedIndexChunk = indexChunk;
			storedIndexChunkChar = indexChunkChar;
			storedCurrentChar = currentChar;
			shortStore = (currentChar < totalTextLength);
			if( !shortStore ) 
			{
				if( storedText.length < totalTextLength )
				{
					storedText = new Vector.<int>(totalTextLength);
					storedDetailChunks = new Vector.<PdfChunk>(totalTextLength);
				}
				storedText = text.concat();
				storedDetailChunks = detailChunks.concat();
				storedText.length = totalTextLength;
				storedDetailChunks.length = totalTextLength;
				
			}
			
			if (runDirection == PdfWriter.RUN_DIRECTION_LTR || runDirection == PdfWriter.RUN_DIRECTION_RTL)
			{
				throw new NonImplementatioError();
			}
		}
		
		public function processLine( leftX: Number, width: Number, alignment: int, runDirection: int, $arabicOptions: int ): PdfLine
		{
			arabicOptions = $arabicOptions;
			save();
			var isRTL: Boolean = ( runDirection == PdfWriter.RUN_DIRECTION_RTL );
			var ck: PdfChunk;
			
			if( currentChar >= totalTextLength )
			{
				var hasText: Boolean = getParagraph( runDirection );
				if (!hasText)
					return null;
				
				if( totalTextLength == 0 )
				{
					var ar: Vector.<PdfChunk> = new Vector.<PdfChunk>();
					ck = PdfChunk.fromString( "", detailChunks[0] );
					ar.push( ck );
					return PdfLine.create( 0, 0, 0, alignment, true, ar, isRTL );
				}
			}
			
			var originalWidth: Number = width;
			var lastSplit: int = -1;
			if( currentChar != 0 )
				currentChar = trimLeftEx( currentChar, totalTextLength - 1 );
			var oldCurrentChar: int = currentChar;
			var uniC: int = 0;
			ck = null;
			var charWidth: Number = 0;
			var lastValidChunk: PdfChunk = null;
			var splitChar: Boolean = false;
			var surrogate: Boolean = false;
			
			for( ; currentChar < totalTextLength; ++currentChar )
			{
				ck = detailChunks[currentChar];
				surrogate = Utilities.isSurrogatePair( text, currentChar );
				if (surrogate)
					uniC = ck.getUnicodeEquivalent( Utilities.convertToUtf32_3( text, currentChar ) );
				else
					uniC = ck.getUnicodeEquivalent( text[currentChar] );
				
				if( PdfChunk.noPrint(uniC) )
					continue;
				
				if( surrogate )
					charWidth = ck.getCharWidth( uniC );
				else
					charWidth = ck.getCharWidth( text[currentChar] );
				
				splitChar = ck.isExtSplitCharacter( oldCurrentChar, currentChar, totalTextLength, text, detailChunks );
				
				if( splitChar && Character.isWhitespace( uniC ) )
				{
					//throw new NonImplementatioError();
					lastSplit = currentChar;
				}
				
				if( width - charWidth < 0 )
					break;
				
				if( splitChar )
					lastSplit = currentChar;
				
				width -= charWidth;
				lastValidChunk = ck;
				
				if( ck.isTab() )
				{
					var tab: Vector.<Object> = ck.getAttribute( Chunk.TAB ) as Vector.<Object>;
					var tabPosition: Number = Number(tab[1]);
					var newLine: Boolean = tab[2];
					
					if( newLine && tabPosition < originalWidth - width )
					{
						return PdfLine.create( 0, originalWidth, width, alignment, true, createArrayOfPdfChunks( oldCurrentChar, currentChar - 1 ), isRTL );
					}
					detailChunks[currentChar].pdf_core::adjustLeft( leftX );
					width = originalWidth - tabPosition;
				}
				if (surrogate)
					++currentChar;
			}
			
			if( lastValidChunk == null ) 
			{
				++currentChar;
				if (surrogate)
					++currentChar;
				return PdfLine.create( 0, originalWidth, 0, alignment, false, createArrayOfPdfChunks(currentChar - 1, currentChar - 1), isRTL );
			}
			
			if (currentChar >= totalTextLength)
				return PdfLine.create( 0, originalWidth, width, alignment, true, createArrayOfPdfChunks(oldCurrentChar, totalTextLength - 1), isRTL );
			
			var newCurrentChar: int = trimRightEx( oldCurrentChar, currentChar - 1 );
			if( newCurrentChar < oldCurrentChar )
				return PdfLine.create( 0, originalWidth, width, alignment, false, createArrayOfPdfChunks(oldCurrentChar, currentChar - 1), isRTL );

			if( newCurrentChar == currentChar - 1 )
			{
				var he: Object = lastValidChunk.getAttribute(Chunk.HYPHENATION);
				if (he != null) {
					throw new NonImplementatioError();
				}
			}
			
			if( lastSplit == -1 || lastSplit >= newCurrentChar )
				return PdfLine.create( 0, originalWidth, width + getWidth(newCurrentChar + 1, currentChar - 1), alignment, false, createArrayOfPdfChunks(oldCurrentChar, newCurrentChar), isRTL );

			currentChar = lastSplit + 1;
			newCurrentChar = trimRightEx( oldCurrentChar, lastSplit );
			if( newCurrentChar < oldCurrentChar )
				newCurrentChar = currentChar - 1;
			return PdfLine.create( 0, originalWidth, originalWidth - getWidth(oldCurrentChar, newCurrentChar), alignment, false, createArrayOfPdfChunks(oldCurrentChar, newCurrentChar), isRTL );
		}
		
		public function restore(): void
		{
			runDirection = storedRunDirection;
			totalTextLength = storedTotalTextLength;
			indexChunk = storedIndexChunk;
			indexChunkChar = storedIndexChunkChar;
			currentChar = storedCurrentChar;
			
			if( !shortStore )
			{
				text = storedText.concat();
				text.length = totalTextLength;
				
				detailChunks = storedDetailChunks.concat();
				detailChunks.length = totalTextLength;
			}
			
			if( runDirection == PdfWriter.RUN_DIRECTION_LTR || runDirection == PdfWriter.RUN_DIRECTION_RTL )
			{
				throw new NonImplementatioError();
			}
		}
		
		/** 
		 * Gets the width of a range of characters
		 */    
		public function getWidth( startIdx: int, lastIdx: int ): Number
		{
			var c: int = 0;
			var uniC: int;
			var ck: PdfChunk = null;
			var width: Number = 0;
			
			for( ; startIdx <= lastIdx; ++startIdx )
			{
				var surrogate: Boolean = Utilities.isSurrogatePair( text, startIdx );
				if( surrogate )
				{
					width += detailChunks[startIdx].getCharWidth( Utilities.convertToUtf32_3( text, startIdx ) );
					++startIdx;
				} else
				{
					c = text[startIdx];
					ck = detailChunks[startIdx];
					if( PdfChunk.noPrint(ck.getUnicodeEquivalent(c) ) )
						continue;
					width += detailChunks[startIdx].getCharWidth(c);
				}
			}
			return width;
		}
		
		public function createArrayOfPdfChunks( startIdx: int, endIdx: int, extraPdfChunk: PdfChunk = null ): Vector.<PdfChunk>
		{
			var bidi: Boolean = ( runDirection == PdfWriter.RUN_DIRECTION_LTR || runDirection == PdfWriter.RUN_DIRECTION_RTL );
			if (bidi)
			{
				throw new NonImplementatioError();
			}
			var ar: Vector.<PdfChunk> = new Vector.<PdfChunk>();
			var refCk: PdfChunk = detailChunks[startIdx];
			var ck: PdfChunk = null;
			var buf: String = "";
			var c: int;
			var idx: int = 0;
			
			for( ; startIdx <= endIdx; ++startIdx )
			{
				idx = bidi ? indexChars[startIdx] : startIdx;
				c = text[idx];
				ck = detailChunks[idx];
				if( PdfChunk.noPrint(ck.getUnicodeEquivalent(c)) )
					continue;
				
				if( ck.isImage() || ck.isSeparator() || ck.isTab() ) {
					if( buf.length > 0 ){
						ar.push( PdfChunk.fromString( buf.toString(), refCk) );
						buf = "";
					}
					ar.push(ck);
				} else if (ck == refCk)
				{
					buf += String.fromCharCode(c);
				} else 
				{
					if( buf.length > 0)
					{
						ar.push( PdfChunk.fromString(buf.toString(), refCk));
						buf = "";
					}
					if (!ck.isImage() && !ck.isSeparator() && !ck.isTab())
						buf += String.fromCharCode(c);
					refCk = ck;
				}
			}
			if (buf.length > 0)
				ar.push( PdfChunk.fromString( buf.toString(), refCk ) );
			
			if( extraPdfChunk != null )
				ar.push( extraPdfChunk );
			return ar;
		}
		
		public function get isEmpty(): Boolean
		{
			return ( currentChar >= totalTextLength && indexChunk >= chunks.length );
		}
		
		public function addChunk( chunk: PdfChunk ): void
		{
			chunks.push( chunk );
		}
		
		public function trimRight( startIdx: int, endIdx: int ): int
		{
			var idx: int = endIdx;
			var c: int;
			for( ; idx >= startIdx; --idx )
			{
				c = detailChunks[idx].getUnicodeEquivalent(text[idx]);
				if (!isWS(c))
					break;
			}
			return idx;
		}
		
		public function trimLeft( startIdx: int, endIdx: int ): int
		{
			var idx: int = startIdx;
			var c: int;
			for (; idx <= endIdx; ++idx) {
				c = detailChunks[idx].getUnicodeEquivalent(text[idx]);
				if (!isWS(c))
					break;
			}
			return idx;
		}
		
		public function trimRightEx( startIdx: int, endIdx: int ): int
		{
			var idx: int = endIdx;
			var c: int = 0;
			for (; idx >= startIdx; --idx) {
				c = detailChunks[idx].getUnicodeEquivalent(text[idx]);
				if (!isWS(c) && !PdfChunk.noPrint(c))
					break;
			}
			return idx;
		}
		
		public function trimLeftEx( startIdx: int, endIdx: int ): int
		{
			var idx: int = startIdx;
			var c: int = 0;
			for (; idx <= endIdx; ++idx) {
				c = detailChunks[idx].getUnicodeEquivalent(text[idx]);
				if (!isWS(c) && !PdfChunk.noPrint(c))
					break;
			}
			return idx;
		}
		
		public static function isWS( c: int ): Boolean
		{
			return c <= 32;
		}
	}
}