package org.purepdf.pdf
{
	import org.purepdf.ColumnText;
	import org.purepdf.elements.Element;
	import org.purepdf.elements.IElement;
	import org.purepdf.elements.Phrase;
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.elements.images.ImageElement;
	import org.purepdf.errors.NonImplementatioError;

	public class PdfPCell extends RectangleElement
	{
		protected var _phrase: Phrase;
		private var _colspan: int = 1;
		private var _column: ColumnText = new ColumnText( null );
		private var _fixedHeight: Number = 0;
		private var _image: ImageElement;
		private var _minimumHeight: Number;
		private var _noWrap: Boolean = false;
		private var _paddingBottom: Number = 2;
		private var _paddingLeft: Number = 2;
		private var _paddingRight: Number = 2;
		private var _paddingTop: Number = 2;
		private var _rowspan: int = 1;
		private var _table: PdfPTable;
		private var _useBorderPadding: Boolean = false;
		private var _useDescender: Boolean;
		private var _verticalAlignment: int = Element.ALIGN_TOP;

		public function PdfPCell()
		{
			super( 0, 0, 0, 0 );
		}
		
		public function get rightIndent(): Number
		{
			return _column.rightIndent;
		}
		
		public function set rightIndent( value: Number ): void
		{
			_column.rightIndent = value;
		}
		
		public function get followingIndent():Number
		{
			return _column.followingIndent;
		}
		
		public function set followingIndent(value:Number):void
		{
			_column.followingIndent = value;
		}
		
		
		public function get rowspan():int
		{
			return _rowspan;
		}

		public function set rowspan(value:int):void
		{
			_rowspan = value;
		}

		public function get colspan():int
		{
			return _colspan;
		}

		public function set colspan(value:int):void
		{
			_colspan = value;
		}

		public function get table():PdfPTable
		{
			return _table;
		}

		public function set table(value:PdfPTable):void
		{
			_table = value;
			_column.setText(null);
			_image = null;
			if (_table != null) {
				_table.setExtendLastRow(verticalAlignment == Element.ALIGN_TOP);
				_column.addElement(table);
				_table.setWidthPercentage(100);
			}
		}

		public function get noWrap():Boolean
		{
			return _noWrap;
		}

		public function set noWrap(value:Boolean):void
		{
			_noWrap = value;
		}

		public function get hasMinimumHeight(): Boolean
		{
			return minimumHeight > 0;
		}
		
		public function get minimumHeight():Number
		{
			return _minimumHeight;
		}

		public function set minimumHeight(value:Number):void
		{
			_minimumHeight = value;
			_fixedHeight = 0;
		}

		public function get hasFixedHeight(): Boolean
		{
			return fixedHeight > 0;
		}
		
		public function get fixedHeight():Number
		{
			return _fixedHeight;
		}

		public function set fixedHeight(value:Number):void
		{
			_fixedHeight = value;
			_minimumHeight = 0;
		}

		public function get extraParagraphSpace(): Number
		{
			return _column.extraParagraphSpace;
		}
		
		public function set extraParagraphSpace( value: Number ): void
		{
			_column.extraParagraphSpace = value;
		}
		
		public function set indent( value: Number ): void
		{
			_column.indent = value;
		}
		
		public function get indent(): Number
		{
			return _column.indent;
		}
		
		public function setLeading( fixedLeading: Number, multipliedLeading: Number ): void
		{
			_column.setLeading( fixedLeading, multipliedLeading );
		}
		
		public function get leading(): Number
		{
			return _column.leading;
		}
		
		public function get multipliedLeading(): Number
		{
			return _column.multipliedLeading;
		}
		
		public function get useBorderPadding():Boolean
		{
			return _useBorderPadding;
		}

		public function set useBorderPadding(value:Boolean):void
		{
			_useBorderPadding = value;
		}

		public function set padding( value: Number ): void {
			_paddingBottom = value;
			_paddingTop = value;
			_paddingLeft = value;
			_paddingRight = value;
		}
		
		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}

		public function set paddingBottom(value:Number):void
		{
			_paddingBottom = value;
		}

		public function getEffectivePaddingBottom(): Number
		{
			if (isUseBorderPadding()) {
				var border: Number = getBorderWidthBottom()/(isUseVariableBorders() ? 1 : 2 );
				return _paddingBottom + border;
			}
			return _paddingBottom;
		}
		
		public function get paddingTop():Number
		{
			return _paddingTop;
		}

		public function set paddingTop(value:Number):void
		{
			_paddingTop = value;
		}

		public function get effectivePaddingTop(): Number
		{
			if (isUseBorderPadding()) {
				var border: Number = getBorderWidthTop()/(isUseVariableBorders()? 1 : 2 );
				return _paddingTop + border;
			}
			return _paddingTop;
		}
		
		public function get paddingRight():Number
		{
			return _paddingRight;
		}

		public function set paddingRight(value:Number):void
		{
			_paddingRight = value;
		}

		public function get effectivePaddingLeft(): Number
		{
			if( isUseBorderPadding() )
			{
				var border: Number = getBorderWidthLeft() / (isUseVariableBorders() ? 1 : 2 );
				return _paddingLeft + border;
			}
			return _paddingLeft;
		}
		
		public function get effectivePaddingRight(): Number
		{
			if (isUseBorderPadding()) {
				var border: Number = getBorderWidthRight() / (isUseVariableBorders() ? 1 : 2 );
				return _paddingRight + border;
			}
			return _paddingRight;
		}
		
		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}

		public function set paddingLeft(value:Number):void
		{
			_paddingLeft = value;
		}

		public function get verticalAlignment():int
		{
			return _verticalAlignment;
		}

		public function set verticalAlignment(value:int):void
		{
			if( _table != null )
				_table.setExtendLastRow( value == Element.ALIGN_TOP );
			_verticalAlignment = value;
		}

		public function get horizontalAlignment(): int
		{
			return _column.alignment;
		}
		
		public function set horizontalAlignment( value: int ): void
		{
			_column.alignment = value;
		}
		
		public function get phrase():Phrase
		{
			return _phrase;
		}

		public function set phrase(value:Phrase):void
		{
			_table = null;
			_image = null;
			_phrase = value
			_column.setText( _phrase );
		}

		public function addElement( element: IElement ): void
		{
			if (_table != null) {
				_table = null;
				_column.setText(null);
			}
			_column.addElement(element);
		}

		static public function fromCell( cell: PdfPCell ): PdfPCell
		{
			throw new NonImplementatioError();
		}

		static public function fromPhrase( phrase: Phrase ): PdfPCell
		{
			throw new NonImplementatioError();
		}
	}
}