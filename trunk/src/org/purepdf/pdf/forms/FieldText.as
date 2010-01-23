package org.purepdf.pdf.forms
{
	import org.purepdf.ColumnText;
	import org.purepdf.Font;
	import org.purepdf.colors.GrayColor;
	import org.purepdf.colors.RGBColor;
	import org.purepdf.elements.Chunk;
	import org.purepdf.elements.Element;
	import org.purepdf.elements.Phrase;
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.pdf.FontSelector;
	import org.purepdf.pdf.PdfAppearance;
	import org.purepdf.pdf.PdfBorderDictionary;
	import org.purepdf.pdf.PdfWriter;
	import org.purepdf.pdf.fonts.BaseFont;
	import org.purepdf.utils.StringUtils;

	public class FieldText extends FieldBase
	{
		private var choiceExports: Vector.<String>;
		private var choiceSelections: Array = new Array();
		private var choices: Vector.<String>;
		private var defaultText: String;
		private var extraMarginLeft: Number = 0;
		private var extraMarginTop: Number = 0;
		private var topFirst: int;
		private var extensionFont: BaseFont;
		private var substitutionFonts: Vector.<BaseFont>;

		public function FieldText( $writer: PdfWriter, $box: RectangleElement, $fieldName: String )
		{
			super( $writer, $box, $fieldName );
		}
		
		/**
		 * 
		 * @throws DocumentError
		 */
		public function getAppearance(): PdfAppearance
		{
			var app: PdfAppearance = getBorderAppearance();
			app.beginVariableText();
			if (text == null || text.length == 0) {
				app.endVariableText();
				return app;
			}
			
			var borderExtra: Boolean = borderStyle == PdfBorderDictionary.STYLE_BEVELED || borderStyle == PdfBorderDictionary.STYLE_INSET;
			var h: Number = box.height - borderWidth * 2 - extraMarginTop;
			var bw2: Number = borderWidth;
			if (borderExtra) {
				h -= borderWidth * 2;
				bw2 *= 2;
			}
			var offsetX: Number = Math.max(bw2, 1);
			var offX: Number = Math.min(bw2, offsetX);
			app.saveState();
			app.rectangle(offX, offX, box.width - 2 * offX, box.height - 2 * offX);
			app.clip();
			app.newPath();
			var ptext: String;
			if ((options & PASSWORD) != 0)
				ptext = obfuscatePassword(text);
			else if ((options & MULTILINE) == 0)
				ptext = removeCRLF(text);
			else
				ptext = text; //fixed by Kazuya Ujihara (ujihara.jp)
			var ufont: BaseFont = getRealFont();
			var fcolor: RGBColor = (textColor == null) ? GrayColor.GRAYBLACK : textColor;
			var rtl: int = checkRTL(ptext) ? PdfWriter.RUN_DIRECTION_LTR : PdfWriter.RUN_DIRECTION_NO_BIDI;
			var usize: Number = _fontSize;
			var phrase: Phrase = composePhrase(ptext, ufont, fcolor, usize);
			if ((options & MULTILINE) != 0) {
				var width: Number = box.width - 4 * offsetX - extraMarginLeft;
				var factor: Number = ufont.getFontDescriptor(BaseFont.BBOXURY, 1) - ufont.getFontDescriptor(BaseFont.BBOXLLY, 1);
				var ct: ColumnText = new ColumnText(null);
				if (usize == 0) {
					usize = h / factor;
					if (usize > 4) {
						if (usize > 12)
							usize = 12;
						var step: Number = Math.max((usize - 4) / 10, 0.2);
						ct.setSimpleColumn(0, -h, width, 0);
						ct.alignment = alignment;
						ct.runDirection = rtl;
						for (; usize > 4; usize -= step) {
							ct.yLine = 0;
							changeFontSize(phrase, usize);
							ct.setText(phrase);
							ct.setLeading(factor * usize);
							var status: int = ct.go(true);
							if ((status & ColumnText.NO_MORE_COLUMN) == 0)
								break;
						}
					}
					if (usize < 4)
						usize = 4;
				}
				changeFontSize(phrase, usize);
				ct.canvas = app;
				var leading: Number = usize * factor;
				var offsetY: Number = offsetX + h - ufont.getFontDescriptor(BaseFont.BBOXURY, usize);
				ct.setSimpleColumn(extraMarginLeft + 2 * offsetX, -20000, box.width - 2 * offsetX, offsetY + leading);
				ct.setLeading(leading);
				ct.alignment = alignment;
				ct.runDirection = rtl;
				ct.setText(phrase);
				ct.go();
			}
			else {
				if (usize == 0) {
					var maxCalculatedSize: Number = h / (ufont.getFontDescriptor(BaseFont.BBOXURX, 1) - ufont.getFontDescriptor(BaseFont.BBOXLLY, 1));
					changeFontSize(phrase, 1);
					var wd: Number = ColumnText.getWidth(phrase, rtl, 0);
					if (wd == 0)
						usize = maxCalculatedSize;
					else
						usize = Math.min(maxCalculatedSize, (box.width - extraMarginLeft - 4 * offsetX) / wd);
					if (usize < 4)
						usize = 4;
				}
				changeFontSize(phrase, usize);
				var offsetY: Number = offX + ((box.height - 2*offX) - ufont.getFontDescriptor(BaseFont.ASCENT, usize)) / 2;
				if (offsetY < offX)
					offsetY = offX;
				if (offsetY - offX < -ufont.getFontDescriptor(BaseFont.DESCENT, usize)) {
					var ny: Number = -ufont.getFontDescriptor(BaseFont.DESCENT, usize) + offX;
					var dy: Number = box.height - offX - ufont.getFontDescriptor(BaseFont.ASCENT, usize);
					offsetY = Math.min(ny, Math.max(offsetY, dy));
				}
				if ((options & COMB) != 0 && maxCharacterLength > 0) {
					var textLen: int = Math.min(maxCharacterLength, ptext.length);
					var position: int = 0;
					if (alignment == Element.ALIGN_RIGHT)
						position = maxCharacterLength - textLen;
					else if (alignment == Element.ALIGN_CENTER)
						position = (maxCharacterLength - textLen) / 2;
					var step: Number = (box.width - extraMarginLeft) / maxCharacterLength;
					var start: Number = step / 2 + position * step;
					if (textColor == null)
						app.setGrayFill(0);
					else
						app.setColorFill(textColor);
					app.beginText();
					for ( var k: int = 0; k < phrase.size; ++k )
					{
						var ck: Chunk = Chunk( phrase.getValue(k) );
						var bf: BaseFont = ck.font.baseFont;
						app.setFontAndSize(bf, usize);
						var sb: String = ck.append("");
						for (var j: int = 0; j < sb.length; ++j) {
							var c: String = sb.substring(j, j + 1);
							var wd: Number = bf.getWidthPoint(c, usize);
							app.setTextMatrix(extraMarginLeft + start - wd / 2, offsetY - extraMarginTop);
							app.showText(c);
							start += step;
						}
					}
					app.endText();
				}
				else {
					var x: Number;
					switch (alignment) {
						case Element.ALIGN_RIGHT:
							x = extraMarginLeft + box.width - (2 * offsetX);
							break;
						case Element.ALIGN_CENTER:
							x = extraMarginLeft + (box.width / 2);
							break;
						default:
							x = extraMarginLeft + (2 * offsetX);
					}
					ColumnText.showTextAligned( app, alignment, phrase, x, offsetY - extraMarginTop, 0, rtl, 0);
				}
			}
			app.restoreState();
			app.endVariableText();
			return app;
		}
		
		public static function removeCRLF( text: String ): String
		{
			return text.replace(/(\r\n|\r|\n)/g, ' ');
		}
		
		public static function obfuscatePassword( text: String ): String
		{
			return text.replace(/.*/,'*');
		}
		
		private function composePhrase( text: String, ufont: BaseFont, color: RGBColor, fontSize: Number ): Phrase
		{
			var phrase: Phrase = null;
			if( extensionFont == null && (substitutionFonts == null || (substitutionFonts.length == 0)))
				phrase = Phrase.fromChunk( new Chunk( text, Font.fromBaseFont( ufont, fontSize, 0, color)));
			else {
				var fs: FontSelector = new FontSelector();
				fs.addFont( Font.fromBaseFont( ufont, fontSize, 0, color ) );
				if (extensionFont != null)
					fs.addFont( Font.fromBaseFont( extensionFont, fontSize, 0, color ) );
				if (substitutionFonts != null) {
					for (var k: int = 0; k < substitutionFonts.length; ++k)
						fs.addFont( Font.fromBaseFont( substitutionFonts[k], fontSize, 0, color));
				}
				phrase = fs.process(text);
			}
			return phrase;
		}

		static private function changeFontSize( p: Phrase, size: Number ): void
		{
			for ( var k: int = 0; k < p.size; ++k )
				Chunk( p.getValue( k ) ).font.size = size;
		}

		static private function checkRTL( text: String ): Boolean
		{
			if ( text == null || text.length == 0 )
				return false;
			var cc: Vector.<int> = StringUtils.toCharArray( text );

			for ( var k: int = 0; k < cc.length; ++k )
			{
				var c: int = cc[k];

				if ( c >= 0x590 && c < 0x0780 )
					return true;
			}
			return false;
		}
	}
}