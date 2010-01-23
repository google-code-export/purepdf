package org.purepdf.pdf.forms
{
	import it.sephiroth.utils.HashMap;
	
	import org.purepdf.colors.RGBColor;
	import org.purepdf.elements.Element;
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.errors.NullPointerError;
	import org.purepdf.pdf.PdfAppearance;
	import org.purepdf.pdf.PdfBorderDictionary;
	import org.purepdf.pdf.PdfCopyFieldsImp;
	import org.purepdf.pdf.PdfName;
	import org.purepdf.pdf.PdfWriter;
	import org.purepdf.pdf.fonts.BaseFont;

	[Abstract]
	public class FieldBase
	{
		public static const BORDER_WIDTH_MEDIUM: Number = 2;
		public static const BORDER_WIDTH_THICK: Number = 3;
		public static const BORDER_WIDTH_THIN: Number = 1;
		public static const COMB: int = PdfFormField.FF_COMB;
		public static const DO_NOT_SCROLL: int = PdfFormField.FF_DONOTSCROLL;
		public static const DO_NOT_SPELL_CHECK: int = PdfFormField.FF_DONOTSPELLCHECK;
		public static const EDIT: int = PdfFormField.FF_EDIT;
		public static const FILE_SELECTION: int = PdfFormField.FF_FILESELECT;
		public static const HIDDEN: int = 1;
		public static const HIDDEN_BUT_PRINTABLE: int = 3;
		public static const MULTILINE: int = PdfFormField.FF_MULTILINE;
		public static const MULTISELECT: int = PdfFormField.FF_MULTISELECT;
		public static const PASSWORD: int = PdfFormField.FF_PASSWORD;
		public static const READ_ONLY: int = PdfFormField.FF_READ_ONLY;
		public static const REQUIRED: int = PdfFormField.FF_REQUIRED;
		public static const VISIBLE: int = 0;
		public static const VISIBLE_BUT_DOES_NOT_PRINT: int = 2;
		private static var _fieldKeys: HashMap;
		protected var alignment: int = Element.ALIGN_LEFT;
		protected var backgroundColor: RGBColor;
		protected var borderColor: RGBColor;
		protected var borderStyle: int = PdfBorderDictionary.STYLE_SOLID;
		protected var borderWidth: Number = BORDER_WIDTH_THIN;
		protected var box: RectangleElement;
		protected var fieldName: String;
		protected var font: BaseFont;
		protected var _fontSize: Number = 0;
		protected var maxCharacterLength: int;
		protected var options: int;
		protected var rotation: int = 0;
		protected var text: String = "";
		protected var textColor: RGBColor;
		protected var visibility: int = 0;
		protected var writer: PdfWriter;

		public function FieldBase( $writer: PdfWriter, $box: RectangleElement, $fieldName: String )
		{
			writer = $writer;
			box = $box;
			fieldName = $fieldName;
		}
		
		public function get fontSize():Number
		{
			return _fontSize;
		}

		public function set fontSize(value:Number):void
		{
			_fontSize = value;
		}

		/**
		 * 
		 * @throws DocumentError
		 */
		protected function getRealFont(): BaseFont
		{
			if (font == null)
				return BaseFont.createFont( BaseFont.HELVETICA, BaseFont.WINANSI, false);
			else
				return font;
		}

		
		protected function getBorderAppearance(): PdfAppearance
		{
			var app: PdfAppearance = PdfAppearance.createAppearance( writer, box.width, box.height );
			switch (rotation) {
				case 90:
					app.setMatrix(0, 1, -1, 0, box.height, 0);
					break;
				case 180:
					app.setMatrix(-1, 0, 0, -1, box.width, box.height);
					break;
				case 270:
					app.setMatrix(0, -1, 1, 0, 0, box.width);
					break;
			}
			app.saveState();
			
			if (backgroundColor != null) {
				app.setColorFill(backgroundColor);
				app.rectangle(0, 0, box.width, box.height);
				app.fill();
			}
			
			if (borderStyle == PdfBorderDictionary.STYLE_UNDERLINE) {
				if (borderWidth != 0 && borderColor != null) {
					app.setColorStroke(borderColor);
					app.setLineWidth(borderWidth);
					app.moveTo(0, borderWidth / 2);
					app.lineTo(box.width, borderWidth / 2);
					app.stroke();
				}
			}
			else if (borderStyle == PdfBorderDictionary.STYLE_BEVELED) {
				if (borderWidth != 0 && borderColor != null) {
					app.setColorStroke(borderColor);
					app.setLineWidth(borderWidth);
					app.rectangle(borderWidth / 2, borderWidth / 2, box.width - borderWidth, box.height - borderWidth);
					app.stroke();
				}
				// beveled
				var actual: RGBColor = backgroundColor;
				if (actual == null)
					actual = RGBColor.WHITE;
				app.setGrayFill(1);
				drawTopFrame(app);
				app.setColorFill(actual.darker());
				drawBottomFrame(app);
			}
			else if (borderStyle == PdfBorderDictionary.STYLE_INSET) {
				if (borderWidth != 0 && borderColor != null) {
					app.setColorStroke(borderColor);
					app.setLineWidth(borderWidth);
					app.rectangle(borderWidth / 2, borderWidth / 2, box.width - borderWidth, box.height - borderWidth);
					app.stroke();
				}
				
				app.setGrayFill(0.5);
				drawTopFrame(app);
				app.setGrayFill(0.75);
				drawBottomFrame(app);
			}
			else {
				if (borderWidth != 0 && borderColor != null) {
					if (borderStyle == PdfBorderDictionary.STYLE_DASHED)
						app.setLineDash2(3, 0);
					app.setColorStroke(borderColor);
					app.setLineWidth(borderWidth);
					app.rectangle(borderWidth / 2, borderWidth / 2, box.width - borderWidth, box.height - borderWidth);
					app.stroke();
					if ((options & COMB) != 0 && maxCharacterLength > 1) {
						var step: Number = box.width / maxCharacterLength;
						var yb: Number = borderWidth / 2;
						var yt: Number = box.height - borderWidth / 2;
						for (var k: int = 1; k < maxCharacterLength; ++k) {
							var x: Number = step * k;
							app.moveTo(x, yb);
							app.lineTo(x, yt);
						}
						app.stroke();
					}
				}
			}
			app.restoreState();
			return app;
		}
		
		private function drawTopFrame( app: PdfAppearance ): void
		{
			app.moveTo(borderWidth, borderWidth);
			app.lineTo(borderWidth, box.height - borderWidth);
			app.lineTo(box.width - borderWidth, box.height - borderWidth);
			app.lineTo(box.width - 2 * borderWidth, box.height - 2 * borderWidth);
			app.lineTo(2 * borderWidth, box.height - 2 * borderWidth);
			app.lineTo(2 * borderWidth, 2 * borderWidth);
			app.lineTo(borderWidth, borderWidth);
			app.fill();
		}
		
		private function drawBottomFrame( app: PdfAppearance ): void
		{
			app.moveTo(borderWidth, borderWidth);
			app.lineTo(box.width - borderWidth, borderWidth);
			app.lineTo(box.width - borderWidth, box.height - borderWidth);
			app.lineTo(box.width - 2 * borderWidth, box.height - 2 * borderWidth);
			app.lineTo(box.width - 2 * borderWidth, 2 * borderWidth);
			app.lineTo(2 * borderWidth, 2 * borderWidth);
			app.lineTo(borderWidth, borderWidth);
			app.fill();
		}

		static private function get fieldKeys(): HashMap
		{
			if ( _fieldKeys == null )
				initFieldKeys();
			return _fieldKeys;
		}

		static private function initFieldKeys(): void
		{
			_fieldKeys = new HashMap();
			_fieldKeys.putAll( PdfCopyFieldsImp.fieldKeys );
			_fieldKeys.put( PdfName.T, 1 );
		}
	}
}