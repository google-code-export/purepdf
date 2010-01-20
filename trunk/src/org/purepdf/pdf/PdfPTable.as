package org.purepdf.pdf
{
	import org.purepdf.elements.Element;
	import org.purepdf.elements.IElementListener;
	import org.purepdf.elements.ILargeElement;
	import org.purepdf.elements.Phrase;
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.elements.images.ImageElement;
	import org.purepdf.errors.DocumentError;
	import org.purepdf.errors.RuntimeError;

	/**
	 * This is a table that can be put at an absolute position but can also
	 * be added to the document as the class Table.
	 */
	public class PdfPTable implements ILargeElement
	{
		public static const BACKGROUNDCANVAS: int = 1;
		public static const BASECANVAS: int = 0;
		public static const LINECANVAS: int = 2;
		public static const TEXTCANVAS: int = 3;
		
		protected var absoluteWidths: Vector.<Number>;
		protected var complete: Boolean = true;
		protected var currentRow: Vector.<PdfPCell>;
		protected var currentRowIdx: int = 0;
		protected var defaultCell: PdfPCell = PdfPCell.fromPhrase( null );
		protected var _headerRows: int;
		protected var isColspan: Boolean = false;
		protected var relativeWidths: Vector.<Number>;
		protected var rowCompleted: Boolean = true;
		protected var rows: Vector.<PdfPRow> = new Vector.<PdfPRow>();
		protected var runDirection: int = PdfWriter.RUN_DIRECTION_DEFAULT;
		protected var spacingAfter: Number;
		protected var spacingBefore: Number;
		protected var totalHeight: Number = 0;
		protected var totalWidth: Number = 0;
		protected var widthPercentage: Number = 80;
		private var extendLastRow: Vector.<Boolean> = Vector.<Boolean>( [false, false] );
		private var footerRows: int;
		private var headersInEvent: Boolean;
		private var horizontalAlignment: int = Element.ALIGN_CENTER;
		private var keepTogether: Boolean;
		private var lockedWidth: Boolean = false;
		private var skipFirstHeader: Boolean = false;
		private var skipLastFooter: Boolean = false;
		private var splitLate: Boolean = true;
		private var splitRows: Boolean = true;

		public function PdfPTable( obj: Object )
		{
			if( obj is Number )
				initFromInt( int(obj) );
		}
		
		/**
		 * 
		 * @throws DocumentError
		 */
		public function setNumberWidths( $relativeWidths: Vector.<Number> ): void
		{
			if (relativeWidths.length != getNumberOfColumns())
				throw new DocumentError("wrong number of columns");
			
			relativeWidths = $relativeWidths.concat();
			absoluteWidths = new Vector.<Number>(relativeWidths.length, true);
			totalHeight = 0;
			calculateWidths();
			calculateHeights(true);
		}
		
		public function setTotalWidth( value: Number ): void
		{
			if ( totalWidth == value )
				return;
			
			totalWidth = value;
			totalHeight = 0;
			calculateWidths();
			calculateHeights(true);
		}
		
		/**
		 * @throws DocumentError
		 */
		public function setTotalWidths( value: Vector.<Number> ): void
		{
			if( value.length != getNumberOfColumns())
				throw new DocumentError("wrong number of columns");
			totalWidth = 0;
			
			for (var k: int = 0; k < value.length; ++k)
				totalWidth += value[k];
			setNumberWidths(value);
		}
		
		/**
		 * @throws DocumentError
		 */
		public function setWidthPercentageAndSize( columnWidth: Vector.<Number>, pageSize: RectangleElement ): void
		{
			if( columnWidth.length != getNumberOfColumns() )
				throw new DocumentError("wrong number of columns");
			var totalWidth: Number = 0;
			for (var k: int = 0; k < columnWidth.length; ++k)
				totalWidth += columnWidth[k];
			widthPercentage = totalWidth / (pageSize.getRight() - pageSize.getLeft()) * 100;
			setNumberWidths(columnWidth);
		}
		
		public function getTotalWidth(): Number {
			return totalWidth;
		}
		
		public function calculateHeights( firsttime: Boolean ): Number
		{
			if (totalWidth <= 0)
				return 0;
			totalHeight = 0;
			for (var k: int = 0; k < rows.length; ++k) {
				totalHeight += getRowHeight1(k, firsttime);
			}
			return totalHeight;
		}
		
		public function calculateHeightsFast(): void
		{
			calculateHeights(false);
		}
		
		public function getDefaultCell(): PdfPCell
		{
			return defaultCell;
		}
		
		public function addStringCell( text: String ): void
		{
			addPhraseCell( new Phrase( text, null ) );
		}
		
		public function addTableCell( table: PdfPTable ): void {
			defaultCell.setTable(table);
			addCell(defaultCell);
			defaultCell.setTable(null);
		}
		
		public function addImageCell( image: ImageElement ): void {
			defaultCell.setImage(image);
			addCell(defaultCell);
			defaultCell.setImage(null);
		}
		
		public function addPhraseCell( phrase: Phrase ): void {
			defaultCell.setPhrase(phrase);
			addCell(defaultCell);
			defaultCell.setPhrase(null);
		}
		
		public function addCell( cell: PdfPCell ): void
		{
			rowCompleted = false;
			var ncell: PdfPCell = PdfPCell.fromCell(cell);
			
			var colspan: int = ncell.getColspan();
			colspan = Math.max(colspan, 1);
			colspan = Math.min(colspan, currentRow.length - currentRowIdx);
			ncell.setColspan(colspan);
			
			if (colspan != 1)
				isColspan = true;
			var rdir: int = ncell.getRunDirection();
			if (rdir == PdfWriter.RUN_DIRECTION_DEFAULT)
				ncell.setRunDirection(runDirection);
			
			skipColsWithRowspanAbove();
			
			var  cellAdded: Boolean = false;
			if (currentRowIdx < currentRow.length) {  
				currentRow[currentRowIdx] = ncell;
				currentRowIdx += colspan;
				cellAdded = true;
			}
			
			skipColsWithRowspanAbove();
			
			if (currentRowIdx >= currentRow.length) {
				var numCols: int = getNumberOfColumns();
				if (runDirection == PdfWriter.RUN_DIRECTION_RTL) {
					var rtlRow: Vector.<PdfPCell> = new Vector.<PdfPCell>(numCols, true);
					var rev: int = currentRow.length;
					for (var k: int = 0; k < currentRow.length; ++k) {
						var rcell: PdfPCell = currentRow[k];
						var cspan: int = rcell.getColspan();
						rev -= cspan;
						rtlRow[rev] = rcell;
						k += cspan - 1;
					}
					currentRow = rtlRow;
				}
				var row: PdfPRow = PdfPRow.fromCell( currentRow );
				if (totalWidth > 0) {
					row.setWidths(absoluteWidths);
					totalHeight += row.getMaxHeights();
				}
				rows.push(row);
				currentRow = new Vector.<PdfPCell>( numCols, true );
				currentRowIdx = 0;
				rowCompleted = true;
			}
			
			if (!cellAdded) {
				currentRow[currentRowIdx] = ncell;
				currentRowIdx += colspan;
			}
		}
		
		public function writeSelectedRows( rowStart: int, rowEnd: int, xPos: Number, yPos: Number, canvases: Vector.<PdfContentByte> ): Number
		{
			return writeSelectedRows1( 0, -1, rowStart, rowEnd, xPos, yPos, canvases );
		}
		
		/**
		 * @throws RuntimeError
		 */
		public function writeSelectedRows1( colStart: int, colEnd: int, rowStart: int, rowEnd: int, xPos: Number, yPos: Number, canvases: Vector.<PdfContentByte> ): Number
		{
			if (totalWidth <= 0)
				throw new RuntimeError("the table width must be greater than zero");
			
			var totalRows: int = rows.length;
			if (rowStart < 0)
				rowStart = 0;
			if (rowEnd < 0)
				rowEnd = totalRows;
			else
				rowEnd = Math.min(rowEnd, totalRows);
			if (rowStart >= rowEnd)
				return yPos;
			
			var totalCols: int = getNumberOfColumns();
			if (colStart < 0)
				colStart = 0;
			else
				colStart = Math.min(colStart, totalCols);
			if (colEnd < 0)
				colEnd = totalCols;
			else
				colEnd = Math.min(colEnd, totalCols);
			
			var yPosStart: Number = yPos;
			var k: int;
			var row: PdfPRow;
			
			for ( k = rowStart; k < rowEnd; ++k) {
				row = rows[k];
				if (row != null) {
					row.writeCells(colStart, colEnd, xPos, yPos, canvases);
					yPos -= row.getMaxHeights();
				}
			}
			
			/*
			if (tableEvent != null && colStart == 0 && colEnd == totalCols) {
				var heights: Vector.<Number> = new Vector.<Number>(rowEnd - rowStart + 1, true);
				heights[0] = yPosStart;
				for ( k = rowStart; k < rowEnd; ++k) {
					row = rows[k];
					var hr: Number = 0;
					if (row != null)
						hr = row.getMaxHeights();
					heights[k - rowStart + 1] = heights[k - rowStart] - hr;
				}
				tableEvent.tableLayout(this, getEventWidths(xPos, rowStart, rowEnd, headersInEvent), heights, headersInEvent ? headerRows : 0, rowStart, canvases);
			}*/
			
			return yPos;
		}
		
		public function writeSelectedRows2( rowStart: int, rowEnd: int, xPos: Number, yPos: Number, canvas: PdfContentByte ): Number
		{
			return writeSelectedRows3( 0, -1, rowStart, rowEnd, xPos, yPos, canvas );
		}
		
		public function writeSelectedRows3( colStart: int, colEnd: int, rowStart: int, rowEnd: int, xPos: Number, yPos: Number, canvas: PdfContentByte ): Number
		{
			var totalCols: int = getNumberOfColumns();
			if (colStart < 0)
				colStart = 0;
			else
				colStart = Math.min(colStart, totalCols);
			
			if (colEnd < 0)
				colEnd = totalCols;
			else
				colEnd = Math.min(colEnd, totalCols);
			
			var clip: Boolean = (colStart != 0 || colEnd != totalCols);
			
			if (clip) {
				var w: Number = 0;
				for (var k: int = colStart; k < colEnd; ++k)
					w += absoluteWidths[k];
				canvas.saveState();
				var lx: Number = (colStart == 0) ? 10000 : 0;
				var rx: Number = (colEnd == totalCols) ? 10000 : 0;
				canvas.rectangle(xPos - lx, -10000, w + lx + rx, PdfPRow.RIGHT_LIMIT);
				canvas.clip();
				canvas.newPath();
			}
			
			var canvases: Vector.<PdfContentByte> = beginWritingRows(canvas);
			var y: Number = writeSelectedRows1( colStart, colEnd, rowStart, rowEnd, xPos, yPos, canvases );
			endWritingRows( canvases );
			
			if (clip)
				canvas.restoreState();
			
			return y;
		}
		
		public static function beginWritingRows( canvas: PdfContentByte ): Vector.<PdfContentByte>
		{
			return Vector.<PdfContentByte>([
				canvas,
				canvas.duplicate(),
				canvas.duplicate(),
				canvas.duplicate(),
			]);
		}
		
		public static function endWritingRows( canvases: Vector.<PdfContentByte> ): void
		{
			var canvas: PdfContentByte = canvases[BASECANVAS];
			canvas.saveState();
			canvas.addContent(canvases[BACKGROUNDCANVAS]);
			canvas.restoreState();
			canvas.saveState();
			canvas.setLineCap(2);
			canvas.resetStroke();
			canvas.addContent(canvases[LINECANVAS]);
			canvas.restoreState();
			canvas.addContent(canvases[TEXTCANVAS]);
		}
		
		public function get size(): int
		{
			return rows.length;
		}
		
		public function getTotalHeight(): Number
		{
			return totalHeight;
		}
		
		public function getRowHeight( idx: int ): Number
		{
			return getRowHeight1(idx, false);
		}
		
		public function getRowHeight1( idx: int, firsttime: Boolean ): Number
		{
			if (totalWidth <= 0 || idx < 0 || idx >= rows.length )
				return 0;
			var row: PdfPRow = rows[idx];
			if (row == null)
				return 0;
			if (firsttime)
				row.setWidths(absoluteWidths);
			var height: Number = row.getMaxHeights();
			var cell: PdfPCell;
			var tmprow: PdfPRow;
			for (var i: int = 0; i < relativeWidths.length; i++) 
			{
				if(!rowSpanAbove(idx, i))
					continue;
				var rs: int = 1;
				while (rowSpanAbove(idx - rs, i)) {
					rs++;
				}
				tmprow = rows[(idx - rs)];
				cell = tmprow.getCells()[i];
				var tmp: Number = 0;
				if (cell.getRowspan() == rs + 1) {
					tmp = cell.getMaxHeight();
					while (rs > 0) {
						tmp -= getRowHeight(idx - rs);
						rs--;
					}
				}
				if (tmp > height)
					height = tmp;
			}
			row.setMaxHeights(height);
			return height;
		}
		
		public function getRowspanHeight( rowIndex: int, cellIndex: int ): Number
		{
			if (totalWidth <= 0 || rowIndex < 0 || rowIndex >= rows.length )
				return 0;
			var row: PdfPRow = rows[rowIndex];
			if (row == null || cellIndex >= row.getCells().length)
				return 0;
			var cell: PdfPCell = row.getCells()[cellIndex];
			if (cell == null)
				return 0;
			var rowspanHeight: Number = 0;
			for (var j: int = 0; j < cell.getRowspan(); j++) {
				rowspanHeight += getRowHeight(rowIndex + j);
			}
			return rowspanHeight;
		}
		
		public function getHeaderHeight(): Number
		{
			var total: Number = 0;
			var s: int = Math.min(rows.length, headerRows);
			for ( var k: int = 0; k < s; ++k) {
				var row: PdfPRow = rows[k];
				if (row != null)
					total += row.getMaxHeights();
			}
			return total;
		}
		
		public function getFooterHeight(): Number
		{
			var total: Number = 0;
			var start: int = Math.max(0, headerRows - footerRows);
			var s: int = Math.min(rows.length, headerRows);
			for (var k: int = start; k < s; ++k) {
				var row: PdfPRow = rows[k];
				if (row != null)
					total += row.getMaxHeights();
			}
			return total;
		}
		
		public function deleteRow( rowNumber: int ): Boolean {
			if (rowNumber < 0 || rowNumber >= rows.length )
				return false;
			if (totalWidth > 0) {
				var row: PdfPRow = rows[rowNumber];
				if (row != null)
					totalHeight -= row.getMaxHeights();
			}
			rows.splice(rowNumber, 1);
			if (rowNumber < headerRows) {
				--headerRows;
				if (rowNumber >= (headerRows - footerRows))
					--footerRows;
			}
			return true;
		}
		
		public function deleteLastRow(): Boolean
		{
			return deleteRow(rows.length - 1);
		}
		
		public function deleteBodyRows(): void
		{
			var rows2: Vector.<PdfPRow> = new Vector.<PdfPRow>();
			for (var k: int = 0; k < headerRows; ++k)
				rows2.push(rows[k]);
			rows = rows2;
			totalHeight = 0;
			if (totalWidth > 0)
				totalHeight = getHeaderHeight();
		}
		
		private function skipColsWithRowspanAbove(): void
		{
			var direction: int = 1;
			if (runDirection == PdfWriter.RUN_DIRECTION_RTL )
				direction = -1;
			while (rowSpanAbove(rows.length, currentRowIdx))
				currentRowIdx += direction;
		}

		private function rowSpanAbove( currRow: int, currCol: int ): Boolean
		{
			if ( ( currCol >= getNumberOfColumns() ) || ( currCol < 0 ) || ( currRow == 0 ) )
				return false;
			var col: int;
			var row: int = currRow - 1;
			var aboveRow: PdfPRow = rows[row];

			if ( aboveRow == null )
				return false;
			var aboveCell: PdfPCell = aboveRow.getCells()[currCol] as PdfPCell;

			while ( ( aboveCell == null ) && ( row > 0 ) )
			{
				aboveRow = rows[--row];

				if ( aboveRow == null )
					return false;
				aboveCell = aboveRow.getCells()[currCol] as PdfPCell;
			}
			var distance: int = currRow - row;

			if ( aboveCell == null )
			{
				col = currCol - 1;
				aboveCell = aboveRow.getCells()[col] as PdfPCell;

				while ( ( aboveCell == null ) && ( row > 0 ) )
					aboveCell = aboveRow.getCells()[--col] as PdfPCell;
				return aboveCell != null && aboveCell.getRowspan() > distance;
			}

			if ( ( aboveCell.getRowspan() == 1 ) && ( distance > 1 ) )
			{
				col = currCol - 1;
				aboveRow = rows[row + 1];
				distance--;
				aboveCell = aboveRow.getCells()[col] as PdfPCell;

				while ( ( aboveCell == null ) && ( col > 0 ) )
					aboveCell = aboveRow.getCells()[--col] as PdfPCell;
			}
			return aboveCell != null && aboveCell.getRowspan() > distance;
		}
		
		/**
		 * @throws DocumentError
		 */
		public function setIntWidths( relativeWidths: Vector.<int> ): void
		{
			var tb: Vector.<Number> = new Vector.<Number>(relativeWidths.length, true);
			for( var k: int = 0; k < relativeWidths.length; ++k)
				tb[k] = relativeWidths[k];
			setNumberWidths(tb);
		}
		
		public function get headerRows():int
		{
			return _headerRows;
		}
		
		public function set headerRows( value: int ): void
		{
			_headerRows = Math.max( value, 0 );
		}
		
		public static function shallowCopy( table: PdfPTable ): PdfPTable
		{
			var nt: PdfPTable = new PdfPTable( null );
			nt.copyFormat( table );
			return nt;
		}
		
		protected function copyFormat( sourceTable: PdfPTable ): void
		{
			relativeWidths = sourceTable.relativeWidths.concat();
			relativeWidths.length = getNumberOfColumns();

			absoluteWidths = sourceTable.absoluteWidths.concat();
			absoluteWidths.length = getNumberOfColumns();
			
			totalWidth = sourceTable.totalWidth;
			totalHeight = sourceTable.totalHeight;
			currentRowIdx = 0;
			runDirection = sourceTable.runDirection;
			defaultCell = PdfPCell.fromCell(sourceTable.defaultCell);
			currentRow = new Vector.<PdfPCell>(sourceTable.currentRow.length, true);
			isColspan = sourceTable.isColspan;
			splitRows = sourceTable.splitRows;
			spacingAfter = sourceTable.spacingAfter;
			spacingBefore = sourceTable.spacingBefore;
			headerRows = sourceTable.headerRows;
			footerRows = sourceTable.footerRows;
			lockedWidth = sourceTable.lockedWidth;
			extendLastRow = sourceTable.extendLastRow;
			headersInEvent = sourceTable.headersInEvent;
			widthPercentage = sourceTable.widthPercentage;
			splitLate = sourceTable.splitLate;
			skipFirstHeader = sourceTable.skipFirstHeader;
			skipLastFooter = sourceTable.skipLastFooter;
			horizontalAlignment = sourceTable.horizontalAlignment;
			keepTogether = sourceTable.keepTogether;
			complete = sourceTable.complete;
		}


		private function initFromInt( numColumns: int ): void
		{
			if( numColumns <= 0 )
				throw new ArgumentError( "the number of columns must be greater than zero" );
			relativeWidths = new Vector.<Number>(numColumns, true);
			for ( var k: int = 0; k < numColumns; ++k )
				relativeWidths[k] = 1;
			
			absoluteWidths = new Vector.<Number>( relativeWidths.length, true );
			calculateWidths();
			currentRow = new Vector.<PdfPCell>(absoluteWidths.length, true);
			keepTogether = false;
		}
		
		protected function calculateWidths(): void
		{
			if( totalWidth <= 0 )
				return;
			var total: Number = 0;
			var k: int;
			var numCols = getNumberOfColumns();
			for (k = 0; k < numCols; ++k)
				total += relativeWidths[k];
			for ( k = 0; k < numCols; ++k)
				absoluteWidths[k] = totalWidth * relativeWidths[k] / total;
		}
		
		public function getNumberOfColumns(): int
		{
			return relativeWidths.length;
		}
		
		public function getHeaderRows(): int
		{
			return headerRows;
		}

		public function getChunks(): Vector.<Object>
		{
			return new Vector.<Object>();
		}

		public function get isContent(): Boolean
		{
			return true;
		}

		public function get isNestable(): Boolean
		{
			return true;
		}

		public function process( listener: IElementListener ): Boolean
		{
			try
			{
				return listener.addElement( this );
			} catch( e: DocumentError ){}
			return false;
		}
		
		public function getWidthPercentage(): Number
		{
			return widthPercentage;
		}
		
		public function setWidthPercentage( value: Number ): void
		{
			widthPercentage = value;
		}
		
		public function getHorizontalAlignment(): int
		{
			return horizontalAlignment;
		}
		
		public function setHorizontalAlignment( value: int ): void
		{
			horizontalAlignment = value;
		}

		public function getRow( idx: int ): PdfPRow
		{
			return rows[idx];
		}

		public function getRows( start: int, end: int ): Vector.<PdfPRow>
		{
			var list: Vector.<PdfPRow> = new Vector.<PdfPRow>();
			if (start < 0 || end > size ) {
				return list;
			}
			var firstRow: PdfPRow = adjustCellsInRow(start, end);
			var colIndex: int = 0;
			var cell: PdfPCell;
			while (colIndex < getNumberOfColumns()) {
				var rowIndex: int = start;
				while (rowSpanAbove(rowIndex--, colIndex)) {
					var row: PdfPRow = rows[rowIndex];
					if (row != null)
					{
						var replaceCell: PdfPCell = row.getCells()[colIndex];
						if (replaceCell != null) {
							firstRow.getCells()[colIndex] = PdfPCell.fromCell(replaceCell);
							var extra: Number = 0;
							var stop: int = Math.min(rowIndex + replaceCell.getRowspan(), end);
							for (var j: int = start + 1; j < stop; j++) {
								extra += getRowHeight(j);
							}
							firstRow.setExtraHeight(colIndex, extra);
							var diff: Number = getRowspanHeight(rowIndex, colIndex) - getRowHeight(start) - extra;
							firstRow.getCells()[colIndex].consumeHeight(diff);
						}
					}
				}
				cell = firstRow.getCells()[colIndex];
				if (cell == null)
					colIndex++;
				else
					colIndex += cell.getColspan();
			}
			list.push(firstRow);
			for (var i: int = start + 1; i < end; i++) {
				list.push(adjustCellsInRow(i, end));
			}
			return list;
		}
		
		protected function adjustCellsInRow( start: int, end: int ): PdfPRow
		{
			var row: PdfPRow = PdfPRow.fromRow( rows[start] );
			row.initExtraHeights();
			var k: int;
			var cell: PdfPCell;
			var cells: Vector.<PdfPCell> = row.getCells();
			for (var i: int = 0; i < cells.length; i++) {
				cell = cells[i];
				if (cell == null || cell.getRowspan() == 1)
					continue;
				var stop: int = Math.min(end, start + cell.getRowspan());
				var extra: Number = 0;
				for ( k = start + 1; k < stop; k++) {
					extra += getRowHeight(k);
				}
				row.setExtraHeight(i, extra);
			}
			return row;
		}
		
		public function getAbsoluteWidths(): Vector.<Number>
		{
			return absoluteWidths;
		}
		
		private function getEventWidths( xPos: Number, firstRow: int, lastRow: int, includeHeaders: Boolean ): Vector.<Vector.<Number>>
		{
			if (includeHeaders) 
			{
				firstRow = Math.max(firstRow, headerRows);
				lastRow = Math.max(lastRow, headerRows);
			}
			
			var k: int;
			var row: PdfPRow;
			var widths: Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>( (includeHeaders ? headerRows : 0) + lastRow - firstRow, true );
			if (isColspan) {
				var n: int = 0;
				if (includeHeaders) {
					for ( k = 0; k < headerRows; ++k) {
						row = rows[k];
						if (row == null)
							++n;
						else
							widths[n++] = row.getEventWidth(xPos);
					}
				}
				for (; firstRow < lastRow; ++firstRow) {
					row = rows[firstRow];
					if (row == null)
						++n;
					else
						widths[n++] = row.getEventWidth(xPos);
				}
			}
			else {
				var numCols: int = getNumberOfColumns();
				var width: Vector.<Number> = new Vector.<Number>( numCols + 1, true );
				width[0] = xPos;
				for (k = 0; k < numCols; ++k)
					width[k + 1] = width[k] + absoluteWidths[k];
				for (k = 0; k < widths.length; ++k)
					widths[k] = width;
			}
			return widths;
		}
		
		public function isSkipFirstHeader(): Boolean
		{
			return skipFirstHeader;
		}
		
		public function isSkipLastFooter(): Boolean
		{
			return skipLastFooter;
		}
		
		public function setSkipFirstHeader( value: Boolean ): void
		{
			skipFirstHeader = value;
		}
		
		public function setSkipLastFooter( value: Boolean ): void
		{
			skipLastFooter = value;
		}
		
		public function setRunDirection( value: int ): void
		{
			switch (runDirection) {
				case PdfWriter.RUN_DIRECTION_DEFAULT:
				case PdfWriter.RUN_DIRECTION_NO_BIDI:
				case PdfWriter.RUN_DIRECTION_LTR:
				case PdfWriter.RUN_DIRECTION_RTL:
					runDirection = value;
					break;
				default:
					throw new RuntimeError("invalid run direction");
			}
		}
		
		public function getRunDirection(): int
		{
			return runDirection;
		}
		
		public function isLockedWidth(): Boolean {
			return lockedWidth;
		}
		
		public function setLockedWidth( value: Boolean ): void
		{
			lockedWidth = value;
		}
		
		public function isSplitRows(): Boolean
		{
			return splitRows;
		}
		
		public function setSplitRows( value: Boolean ): void 
		{
			splitRows = value;
		}
		
		public function setSpacingBefore( value: Number ): void
		{
			spacingBefore = value;
		}
		
		public function setSpacingAfter( value: Number ): void
		{
			spacingAfter = value;
		}    
		
		public function getSpacingBefore(): Number
		{
			return spacingBefore;
		}
		
		public function getSpacingAfter(): Number
		{
			return spacingAfter;
		}    

		public function isExtendLastRow(): Boolean
		{
			return extendLastRow[0];
		}
		
		public function setExtendLastRow( value: Boolean ): void
		{
			extendLastRow[0] = value;
			extendLastRow[1] = value;
		}
		
		public function setExtendLastRows( value1: Boolean, value2: Boolean ): void
		{
			extendLastRow[0] = value1;
			extendLastRow[1] = value2;
		}

		public function isExtendLastRow1( newPageFollows: Boolean ): Boolean
		{
			if (newPageFollows) {
				return extendLastRow[0];	
			}
			return extendLastRow[1];
		}
		
		public function isSplitLate(): Boolean
		{
			return splitLate;
		}
		
		public function setSplitLate( value: Boolean ): void
		{
			splitLate = value;
		}
		
		public function setKeepTogether( value: Boolean ): void
		{
			keepTogether = value;
		}
		
		public function getKeepTogether(): Boolean
		{
			return keepTogether;
		}
		
		public function getFooterRows(): int
		{
			return footerRows;
		}
		
		public function setFooterRows( value: int ): void
		{
			footerRows = Math.max( value, 0 );
		}
		
		public function completeRow(): void
		{
			while (!rowCompleted) {
				addCell(defaultCell);
			}
		}
		
		public function flushContent(): void
		{
			deleteBodyRows();
			setSkipFirstHeader(true);
		}
		
		public function get isComplete(): Boolean
		{
			return complete;
		}
		
		public function set isComplete( value: Boolean ): void
		{
			complete = value;
		}
		
		public function toString(): String
		{
			return "[PdfPTable]";
		}

		public function get type(): int
		{
			return Element.PTABLE;
		}
	}
}