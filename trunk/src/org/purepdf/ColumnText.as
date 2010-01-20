package org.purepdf
{
	import org.purepdf.elements.Chunk;
	import org.purepdf.elements.Element;
	import org.purepdf.elements.Phrase;
	import org.purepdf.errors.ConversionError;
	import org.purepdf.errors.DocumentError;
	import org.purepdf.errors.NonImplementatioError;
	import org.purepdf.errors.NullPointerError;
	import org.purepdf.errors.RuntimeError;
	import org.purepdf.pdf.PdfChunk;
	import org.purepdf.pdf.PdfContentByte;
	import org.purepdf.pdf.PdfDocument;
	import org.purepdf.pdf.PdfFont;
	import org.purepdf.pdf.PdfLine;
	import org.purepdf.pdf.PdfWriter;
	import org.purepdf.utils.pdf_core;

	public class ColumnText
	{
		public static const GLOBAL_SPACE_CHAR_RATIO: Number = 0;
		public static const NO_MORE_COLUMN: int = 2;
		public static const NO_MORE_TEXT: int = 1;
		public static const START_COLUMN: int = 0;
		protected const LINE_STATUS_NOLINE: int = 2;
		protected const LINE_STATUS_OFFLIMITS: int = 1;
		protected const LINE_STATUS_OK: int = 0;
		protected var _alignment: int = Element.ALIGN_LEFT;
		protected var _extraParagraphSpace: Number = 0;
		protected var _followingIndent: Number = 0;
		protected var _indent: Number = 0;
		protected var _multipliedLeading: Number = 0;
		protected var bidiLine: BidiLine;
		protected var canvas: PdfContentByte;
		protected var canvases: Vector.<PdfContentByte>;
		protected var composite: Boolean = false;
		protected var compositeColumn: ColumnText;
		protected var compositeElements: Array;
		protected var currentLeading: Number = 16;
		protected var descender: Number;
		protected var fixedLeading: Number = 16;
		protected var leftWall: Vector.<Vector.<Number>>;
		protected var leftX: Number;
		protected var lineStatus: int;
		protected var listIdx: int = 0;
		protected var maxY: Number;
		protected var minY: Number;
		protected var rectangularMode: Boolean = false;
		protected var rectangularWidth: Number = -1;
		protected var _rightIndent: Number = 0;
		protected var rightWall: Vector.<Vector.<Number>>;
		protected var rightX: Number;
		protected var runDirection: int = PdfWriter.RUN_DIRECTION_DEFAULT;
		protected var waitPhrase: Phrase;
		protected var yLine: Number;
		private var _useAscender: Boolean = false;
		private var adjustFirstLine: Boolean = true;
		private var arabicOptions: int = 0;
		private var filledWidth: Number;
		private var firstLineY: Number;
		private var firstLineYDone: Boolean = false;
		private var lastWasNewline: Boolean = true;
		private var linesWritten: int;
		private var spaceCharRatio: Number = GLOBAL_SPACE_CHAR_RATIO;
		private var splittedRow: Boolean;

		public function ColumnText( content: PdfContentByte )
		{
			canvas = content;
		}

		public function get rightIndent():Number
		{
			return _rightIndent;
		}

		public function set rightIndent(value:Number):void
		{
			_rightIndent = value;
			lastWasNewline = true;
		}

		public function addText( phrase: Phrase ): void
		{
			if ( phrase == null || composite )
				return;
			addWaitingPhrase();

			if ( bidiLine == null )
			{
				waitPhrase = phrase;
				return;
			}
			var chunks: Vector.<Object> = phrase.getChunks();

			for ( var k: int = 0; k < chunks.length; ++k )
				bidiLine.addChunk( PdfChunk.fromChunk( Chunk( chunks[k] ), null ) );
		}

		public function get alignment(): int
		{
			return _alignment;
		}

		public function set alignment( value: int ): void
		{
			_alignment = value;
		}

		public function get extraParagraphSpace(): Number
		{
			return _extraParagraphSpace;
		}

		public function set extraParagraphSpace( value: Number ): void
		{
			_extraParagraphSpace = value;
		}

		public function get followingIndent(): Number
		{
			return _followingIndent;
		}

		public function set followingIndent( value: Number ): void
		{
			_followingIndent = value;
			lastWasNewline = true;
		}

		/**
		 * Outputs the lines to the document. The output can be simulated.
		 * @param simulate <CODE>true</CODE> to simulate the writing to the document
		 * @return returns the result of the operation. It can be <CODE>NO_MORE_TEXT</CODE>
		 * and/or <CODE>NO_MORE_COLUMN</CODE>
		 *
		 * @throws DocumentError
		 */
		public function go( simulate: Boolean = false ): int
		{
			if ( composite )
				throw new NonImplementatioError();
			addWaitingPhrase();

			if ( bidiLine == null )
				return NO_MORE_TEXT;
			descender = 0;
			linesWritten = 0;
			var dirty: Boolean = false;
			var ratio: Number = spaceCharRatio;
			var currentValues: Vector.<Object> = new Vector.<Object>( 2, true );
			var currentFont: PdfFont = null;
			var lastBaseFactor: Number = 0;
			currentValues[1] = lastBaseFactor;
			var pdf: PdfDocument = null;
			var graphics: PdfContentByte = null;
			var text: PdfContentByte = null;
			var firstLineY: Number = Number.NaN;
			var localRunDirection: int = PdfWriter.RUN_DIRECTION_NO_BIDI;

			if ( runDirection != PdfWriter.RUN_DIRECTION_DEFAULT )
				localRunDirection = runDirection;

			if ( canvas != null )
			{
				graphics = canvas;
				pdf = canvas.pdfDocument;
				text = canvas.duplicate();
			} else if ( !simulate )
				throw new NullPointerError( "column text go with simulate == false and text == null" );

			if ( !simulate )
			{
				if ( ratio == GLOBAL_SPACE_CHAR_RATIO )
					ratio = text.writer.spaceCharRatio;
				else if ( ratio < 0.001 )
					ratio = 0.001;
			}
			var firstIndent: Number = 0;
			var line: PdfLine;
			var x1: Number;
			var status: int = 0;

			while ( true )
			{
				firstIndent = ( lastWasNewline ? _indent : _followingIndent ); //

				if ( rectangularMode )
				{
					if ( rectangularWidth <= firstIndent + _rightIndent )
					{
						status = NO_MORE_COLUMN;

						if ( bidiLine.isEmpty )
							status |= NO_MORE_TEXT;
						break;
					}

					if ( bidiLine.isEmpty )
					{
						status = NO_MORE_TEXT;
						break;
					}
					line = bidiLine.processLine( leftX, rectangularWidth - firstIndent - _rightIndent, _alignment, localRunDirection,
									arabicOptions );

					if ( line == null )
					{
						status = NO_MORE_TEXT;
						break;
					}
					var maxSize: Vector.<Number> = line.getMaxSize();

					if ( useAscender && isNaN( firstLineY ) )
						currentLeading = line.ascender;
					else
						currentLeading = Math.max( fixedLeading + maxSize[0] * _multipliedLeading, maxSize[1] );

					if ( yLine > maxY || yLine - currentLeading < minY )
					{
						status = NO_MORE_COLUMN;
						bidiLine.restore();
						break;
					}
					yLine -= currentLeading;

					if ( !simulate && !dirty )
					{
						text.beginText();
						dirty = true;
					}

					if ( isNaN( firstLineY ) )
						firstLineY = yLine;
					updateFilledWidth( rectangularWidth - line.widthLeft );
					x1 = leftX;
				} else
				{
					var yTemp: Number = yLine;
					var xx: Vector.<Number> = findLimitsTwoLines();

					if ( xx == null )
					{
						status = NO_MORE_COLUMN;

						if ( bidiLine.isEmpty )
							status |= NO_MORE_TEXT;
						yLine = yTemp;
						break;
					}

					if ( bidiLine.isEmpty )
					{
						status = NO_MORE_TEXT;
						yLine = yTemp;
						break;
					}
					x1 = Math.max( xx[0], xx[2] );
					var x2: Number = Math.min( xx[1], xx[3] );

					if ( x2 - x1 <= firstIndent + _rightIndent )
						continue;

					if ( !simulate && !dirty )
					{
						text.beginText();
						dirty = true;
					}
					line = bidiLine.processLine( x1, x2 - x1 - firstIndent - _rightIndent, _alignment, localRunDirection,
									arabicOptions );

					if ( line == null )
					{
						status = NO_MORE_TEXT;
						yLine = yTemp;
						break;
					}
				}

				if ( !simulate )
				{
					currentValues[0] = currentFont;
					text.setTextMatrix( 1, 0, 0, 1, x1 + ( line.isRTL ? _rightIndent : firstIndent ) + line.pdf_core::indentLeft,
									yLine );
					pdf.pdf_core::writeLineToContent( line, text, graphics, currentValues, ratio );
					currentFont = currentValues[0] as PdfFont;
				}
				lastWasNewline = line.isNewlineSplit;
				yLine -= line.isNewlineSplit ? _extraParagraphSpace : 0;
				++linesWritten;
				descender = line.descender;
			}

			if ( dirty )
			{
				text.endText();
				canvas.pdf_core::addContent( text );
			}
			return status;
		}

		public function get indent(): Number
		{
			return _indent;
		}

		public function set indent( value: Number ): void
		{
			_indent = value;
			lastWasNewline = true;
		}

		public function get leading(): Number
		{
			return fixedLeading;
		}

		public function get multipliedLeading(): Number
		{
			return _multipliedLeading;
		}

		public function setAlignment( value: int ): void
		{
			_alignment = value;
		}

		public function setLeading( leading: Number, mul: Number = 0 ): void
		{
			fixedLeading = leading;
			_multipliedLeading = mul;
		}

		public function setRunDirection( value: int ): void
		{
			if ( value < PdfWriter.RUN_DIRECTION_DEFAULT || value > PdfWriter.RUN_DIRECTION_RTL )
				throw new RuntimeError( "invalid run direction" );
			runDirection = value;
		}

		public function setSimpleColumn( llx: Number, lly: Number, urx: Number, ury: Number ): void
		{
			leftX = Math.min( llx, urx );
			maxY = Math.max( lly, ury );
			minY = Math.min( lly, ury );
			rightX = Math.max( llx, urx );
			yLine = maxY;
			rectangularWidth = rightX - leftX;

			if ( rectangularWidth < 0 )
				rectangularWidth = 0;
			rectangularMode = true;
		}

		public function setText( phrase: Phrase ): void
		{
			bidiLine = null;
			composite = false;
			compositeColumn = null;
			compositeElements = null;
			listIdx = 0;
			splittedRow = false;
			waitPhrase = phrase;
		}

		public function updateFilledWidth( w: Number ): void
		{
			if ( w > filledWidth )
				filledWidth = w;
		}

		/**
		 * Simplified method for rectangular columns
		 */
		public function get useAscender(): Boolean
		{
			return _useAscender;
		}

		public function set useAscender( value: Boolean ): void
		{
			_useAscender = value;
		}

		/**
		 * Finds the intersection between the yLine and the two
		 * column bounds
		 */
		protected function findLimitsOneLine(): Vector.<Number>
		{
			var x1: Number = findLimitsPoint( leftWall );

			if ( lineStatus == LINE_STATUS_OFFLIMITS || lineStatus == LINE_STATUS_NOLINE )
				return null;
			var x2: Number = findLimitsPoint( rightWall );

			if ( lineStatus == LINE_STATUS_NOLINE )
				return null;
			return Vector.<Number>( [x1, x2] );
		}

		/**
		 * Finds the intersection between the yLine and the column
		 */
		protected function findLimitsPoint( wall: Vector.<Vector.<Number>> ): Number
		{
			lineStatus = LINE_STATUS_OK;

			if ( yLine < minY || yLine > maxY )
			{
				lineStatus = LINE_STATUS_OFFLIMITS;
				return 0;
			}

			for ( var k: int = 0; k < wall.length; ++k )
			{
				var r: Vector.<Number> = wall[k];

				if ( yLine < r[0] || yLine > r[1] )
					continue;
				return r[2] * yLine + r[3];
			}
			lineStatus = LINE_STATUS_NOLINE;
			return 0;
		}

		/**
		 * Finds the intersection between the yLine,
		 * the yLine-leading and the two column bounds
		 */
		protected function findLimitsTwoLines(): Vector.<Number>
		{
			var repeat: Boolean = false;

			for ( ; ;  )
			{
				if ( repeat && currentLeading == 0 )
					return null;
				repeat = true;
				var x1: Vector.<Number> = findLimitsOneLine();

				if ( lineStatus == LINE_STATUS_OFFLIMITS )
					return null;
				yLine -= currentLeading;

				if ( lineStatus == LINE_STATUS_NOLINE )
					continue;
				var x2: Vector.<Number> = findLimitsOneLine();

				if ( lineStatus == LINE_STATUS_OFFLIMITS )
					return null;

				if ( lineStatus == LINE_STATUS_NOLINE )
				{
					yLine -= currentLeading;
					continue;
				}

				if ( x1[0] >= x2[1] || x2[0] >= x1[1] )
					continue;
				return Vector.<Number>( [x1[0], x1[1], x2[0], x2[1]] );
			}
			return null;
		}

		private function addWaitingPhrase(): void
		{
			if ( bidiLine == null && waitPhrase != null )
			{
				bidiLine = new BidiLine();
				var chunks: Vector.<Object> = waitPhrase.getChunks();

				for ( var k: int = 0; k < chunks.length; ++k )
					bidiLine.addChunk( PdfChunk.fromChunk( Chunk( chunks[k] ), null ) );
				waitPhrase = null;
			}
		}

		/**
		 * Shows a line of text. Only the first line is written.
		 *
		 * @param canvas where the text is to be written to
		 * @param alignment the alignment
		 * @param phrase the <CODE>Phrase</CODE> with the text
		 * @param x the x reference position
		 * @param y the y reference position
		 * @param rotation the rotation to be applied in degrees counterclockwise
		 */
		static public function showTextAligned( canvas: PdfContentByte, alignment: int, phrase: Phrase, x: Number, y: Number,
						rotation: Number, runDirection: int = 0 ): void
		{
			if ( alignment != Element.ALIGN_LEFT && alignment != Element.ALIGN_CENTER && alignment != Element.ALIGN_RIGHT )
				alignment = Element.ALIGN_LEFT;
			canvas.saveState();
			var ct: ColumnText = new ColumnText( canvas );
			var lly: Number = -1;
			var ury: Number = 2;
			var llx: Number;
			var urx: Number;

			switch ( alignment )
			{
				case Element.ALIGN_LEFT:
					llx = 0;
					urx = 20000;
					break;
				case Element.ALIGN_RIGHT:
					llx = -20000;
					urx = 0;
					break;
				default:
					llx = -20000;
					urx = 20000;
					break;
			}

			if ( rotation == 0 )
			{
				llx += x;
				lly += y;
				urx += x;
				ury += y;
			} else
			{
				var alpha: Number = rotation * Math.PI / 180.0;
				var cos: Number = Math.cos( alpha );
				var sin: Number = Math.sin( alpha );
				canvas.concatCTM( cos, sin, -sin, cos, x, y );
			}
			ct.addText( phrase );
			ct.setLeading( 2 );
			ct._alignment = alignment;
			ct.setSimpleColumn( llx, lly, urx, ury );

			if ( runDirection == PdfWriter.RUN_DIRECTION_RTL )
			{
				if ( alignment == Element.ALIGN_LEFT )
					alignment = Element.ALIGN_RIGHT;
				else if ( alignment == Element.ALIGN_RIGHT )
					alignment = Element.ALIGN_LEFT;
			}
			ct.setAlignment( alignment );
			ct.setRunDirection( runDirection );

			try
			{
				ct.go();
			} catch ( e: DocumentError )
			{
				throw new ConversionError( e );
			}
			canvas.restoreState();
		}
	}
}