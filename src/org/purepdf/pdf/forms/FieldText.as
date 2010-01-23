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
	import org.purepdf.pdf.PdfAnnotation;
	import org.purepdf.pdf.PdfAppearance;
	import org.purepdf.pdf.PdfArray;
	import org.purepdf.pdf.PdfBorderDictionary;
	import org.purepdf.pdf.PdfDashPattern;
	import org.purepdf.pdf.PdfName;
	import org.purepdf.pdf.PdfNumber;
	import org.purepdf.pdf.PdfString;
	import org.purepdf.pdf.PdfWriter;
	import org.purepdf.pdf.fonts.BaseFont;
	import org.purepdf.utils.StringUtils;

	public class FieldText extends FieldBase
	{
		private var _choicesExport: Vector.<String>;
		private var choiceSelections: Vector.<int> = new Vector.<int>();
		private var _choices: Vector.<String>;
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
		public function getListField(): PdfFormField
		{
			return _getChoiceField(true);
		}
		
		private function getTopChoice(): int
		{
			if (choiceSelections == null || choiceSelections.length ==0) {
				return 0;
			}
			
			var firstValue: int = choiceSelections[0];
			
			var topChoice: int = 0;
			if (choices != null) {
				topChoice = firstValue;
				topChoice = Math.min( topChoice, _choices.length );
				topChoice = Math.max( 0, topChoice);
			}
			return topChoice;
		}
		
		/**
		 * 
		 * @throws DocumentError
		 */
		protected function _getChoiceField( isList: Boolean): PdfFormField
		{
			options &= (~MULTILINE) & (~COMB);
			var uchoices: Vector.<String> = choices;
			if (uchoices == null)
				uchoices = new Vector.<String>();
			
			var topChoice: int = getTopChoice();
			
			if (text == null)
				text = "";
			
			if (topChoice >= 0)
				text = uchoices[topChoice];
			
			var field: PdfFormField = null;
			var mix: Vector.<Vector.<String>> = null;
			var k: int;
			
			if ( _choicesExport == null) {
				if (isList)
					field = PdfFormField.createList(writer, uchoices, topChoice);
				else
					field = PdfFormField.createCombo(writer, (options & EDIT) != 0, uchoices, topChoice);
			}
			else {
				mix = new Vector.<Vector.<String>>(uchoices.length,true);
				for ( k = 0; k < mix.length; ++k)
				{
					mix[k] = new Vector.<String>(2,true);
					mix[k][0] = mix[k][1] = uchoices[k];
				}
				var top: int = Math.min(uchoices.length, _choicesExport.length);
				for ( k = 0; k < top; ++k) {
					if (_choicesExport[k] != null)
						mix[k][0] = _choicesExport[k];
				}
				if (isList)
					field = PdfFormField.createLists(writer, mix, topChoice);
				else
					field = PdfFormField.createCombos(writer, (options & EDIT) != 0, mix, topChoice);
			}
			field.setWidget( box, PdfAnnotation.HIGHLIGHT_INVERT );
			if (rotation != 0)
				field.mkRotation = rotation;
			if (fieldName != null) {
				field.fieldName = fieldName;
				if (uchoices.length > 0) {
					if (mix != null) {
						if (choiceSelections.length < 2) {
							field.valueAsString = mix[topChoice][0];
							field.defaultValueAsString = mix[topChoice][0];
						} else {
							writeMultipleValues( field, mix);
						}
					} else {
						if (choiceSelections.length < 2) {
							field.valueAsString = text;
							field.defaultValueAsString = text;
						} else {
							writeMultipleValues( field, null );
						}
					}
				}
				if ((options & READ_ONLY) != 0)
					field.fieldFlags = PdfFormField.FF_READ_ONLY;
				if ((options & REQUIRED) != 0)
					field.fieldFlags = PdfFormField.FF_REQUIRED;
				if ((options & DO_NOT_SPELL_CHECK) != 0)
					field.fieldFlags = PdfFormField.FF_DONOTSPELLCHECK;
				if ((options & MULTISELECT) != 0) {
					field.fieldFlags = PdfFormField.FF_MULTISELECT;
				}
			}
			
			field.borderStyle = new PdfBorderDictionary(borderWidth, borderStyle, new PdfDashPattern(3));
			var tp: PdfAppearance;
			if (isList) {
				tp = getListAppearance();
				if (topFirst > 0)
					field.put(PdfName.TI, new PdfNumber(topFirst));
			}
			else
				tp = getAppearance();
			field.setAppearance(PdfAnnotation.APPEARANCE_NORMAL, tp);
			var da: PdfAppearance = tp.duplicate() as PdfAppearance;
			da.setFontAndSize(getRealFont(), fontSize);
			if (textColor == null)
				da.setGrayFill(0);
			else
				da.setColorFill(textColor);
			field.defaultAppearanceString = da;
			if (borderColor != null)
				field.mkBorderColor = borderColor;
			if (backgroundColor != null)
				field.mkBackgroundColor = backgroundColor;
			switch (visibility) {
				case HIDDEN:
					field.flags = PdfAnnotation.FLAGS_PRINT | PdfAnnotation.FLAGS_HIDDEN;
					break;
				case VISIBLE_BUT_DOES_NOT_PRINT:
					break;
				case HIDDEN_BUT_PRINTABLE:
					field.flags = PdfAnnotation.FLAGS_PRINT | PdfAnnotation.FLAGS_NOVIEW;
					break;
				default:
					field.flags = PdfAnnotation.FLAGS_PRINT;
					break;
			}
			return field;
		}
		
		/**
		 * 
		 * @throws DocumentError
		 */
		private function getListAppearance(): PdfAppearance
		{
			var app: PdfAppearance = getBorderAppearance();
			if (choices == null || choices.length == 0) {
				return app;
			}
			app.beginVariableText();
			
			var topChoice: int = getTopChoice();
			
			var ufont: BaseFont = getRealFont();
			var usize: Number = fontSize;
			if (usize == 0)
				usize = 12;
			
			var borderExtra: Boolean = borderStyle == PdfBorderDictionary.STYLE_BEVELED || borderStyle == PdfBorderDictionary.STYLE_INSET;
			var h: Number = box.height - borderWidth * 2;
			var offsetX: Number = borderWidth;
			if (borderExtra) {
				h -= borderWidth * 2;
				offsetX *= 2;
			}
			
			var leading: Number = ufont.getFontDescriptor(BaseFont.BBOXURY, usize) - ufont.getFontDescriptor(BaseFont.BBOXLLY, usize);
			var maxFit: int = (h / leading) + 1;
			var first: int = 0;
			var last: int = 0;
			first = topChoice;
			last = first + maxFit;
			if (last > choices.length)
				last = choices.length;
			topFirst = first;
			app.saveState();
			app.rectangle( offsetX, offsetX, box.width - 2 * offsetX, box.height - 2 * offsetX);
			app.clip();
			app.newPath();
			var fcolor: RGBColor = (textColor == null) ? GrayColor.GRAYBLACK : textColor;
			
			
			app.setColorFill(new RGBColor(10, 36, 106));
			for (var curVal: int = 0; curVal < choiceSelections.length; ++curVal) {
				var curChoice: int = choiceSelections[curVal]; 
				if (curChoice >= first && curChoice <= last) {
					app.rectangle(offsetX, offsetX + h - (curChoice - first + 1) * leading, box.width - 2 * offsetX, leading);
					app.fill();
				}
			}
			var xp: Number = offsetX * 2;
			var yp: Number = offsetX + h - ufont.getFontDescriptor(BaseFont.BBOXURY, usize);
			for ( var idx: int = first; idx < last; ++idx, yp -= leading) 
			{
				var ptext: String = choices[idx];
				var rtl: int = checkRTL(ptext) ? PdfWriter.RUN_DIRECTION_LTR : PdfWriter.RUN_DIRECTION_NO_BIDI;
				ptext = removeCRLF(ptext);
				var textCol: RGBColor = (choiceSelections.indexOf( idx ) > -1 ) ? GrayColor.GRAYWHITE : fcolor;
				var phrase: Phrase = composePhrase(ptext, ufont, textCol, usize);
				ColumnText.showTextAligned(app, Element.ALIGN_LEFT, phrase, xp, yp, 0, rtl, 0);
			}
			app.restoreState();
			app.endVariableText();
			return app;
		}
		
		private function writeMultipleValues( field: PdfFormField, mix: Vector.<Vector.<String>> ): void
		{
			var indexes: PdfArray = new PdfArray();
			var values: PdfArray = new PdfArray();
			for( var i: int = 0; i < choiceSelections.length; ++i)
			{
				var idx: int = choiceSelections[i];
				indexes.add( new PdfNumber( idx ) );
				
				if (mix != null)
					values.add( new PdfString( mix[idx][0] ) );
				else if (choices != null)
					values.add( new PdfString( choices[ idx ] ) );
			}
			
			field.put( PdfName.V, values );
			field.put( PdfName.I, indexes );
			
		}

		public function get choices():Vector.<String>
		{
			return _choices;
		}

		public function set choices(value:Vector.<String>):void
		{
			_choices = value;
		}

		public function get choicesExport():Vector.<String>
		{
			return _choicesExport;
		}

		public function set choicesExport(value:Vector.<String>):void
		{
			_choicesExport = value;
		}

		/**
		 * Return a new FieldText
		 * @throws DocumentError
		 */
		public function getTextField(): PdfFormField
		{
			if (maxCharacterLength <= 0)
				options &= ~COMB;
			if ((options & COMB) != 0)
				options &= ~MULTILINE;
			var field: PdfFormField = PdfFormField.createTextField( writer, false, false, maxCharacterLength );
			field.setWidget( box, PdfAnnotation.HIGHLIGHT_INVERT );
			switch (alignment) {
				case Element.ALIGN_CENTER:
					field.quadding = PdfFormField.Q_CENTER;
					break;
				case Element.ALIGN_RIGHT:
					field.quadding = PdfFormField.Q_RIGHT;
					break;
			}
			if (rotation != 0)
				field.mkRotation = rotation;
			if (fieldName != null) {
				field.fieldName = fieldName;
				if ( text != "" )
					field.valueAsString = text;
				if (defaultText != null)
					field.defaultValueAsString = defaultText;
				if ((options & READ_ONLY) != 0)
					field.fieldFlags = PdfFormField.FF_READ_ONLY;
				if ((options & REQUIRED) != 0)
					field.fieldFlags = PdfFormField.FF_REQUIRED;
				if ((options & MULTILINE) != 0)
					field.fieldFlags = PdfFormField.FF_MULTILINE;
				if ((options & DO_NOT_SCROLL) != 0)
					field.fieldFlags = PdfFormField.FF_DONOTSCROLL;
				if ((options & PASSWORD) != 0)
					field.fieldFlags = PdfFormField.FF_PASSWORD;
				if ((options & FILE_SELECTION) != 0)
					field.fieldFlags = PdfFormField.FF_FILESELECT;
				if ((options & DO_NOT_SPELL_CHECK) != 0)
					field.fieldFlags = PdfFormField.FF_DONOTSPELLCHECK;
				if ((options & COMB) != 0)
					field.fieldFlags = PdfFormField.FF_COMB;
			}
			
			field.borderStyle = new PdfBorderDictionary( borderWidth, borderStyle, new PdfDashPattern(3) );
			var tp: PdfAppearance = getAppearance();
			field.setAppearance( PdfAnnotation.APPEARANCE_NORMAL, tp);
			var da: PdfAppearance = tp.duplicate() as PdfAppearance;
			da.setFontAndSize(getRealFont(), fontSize);
			if (textColor == null)
				da.setGrayFill(0);
			else
				da.setColorFill(textColor);
			field.defaultAppearanceString = da;
			if (borderColor != null)
				field.mkBorderColor = borderColor;
			if (backgroundColor != null)
				field.mkBackgroundColor = backgroundColor;
			switch (visibility) {
				case HIDDEN:
					field.flags = PdfAnnotation.FLAGS_PRINT | PdfAnnotation.FLAGS_HIDDEN;
					break;
				case VISIBLE_BUT_DOES_NOT_PRINT:
					break;
				case HIDDEN_BUT_PRINTABLE:
					field.flags = PdfAnnotation.FLAGS_PRINT | PdfAnnotation.FLAGS_NOVIEW;
					break;
				default:
					field.flags = PdfAnnotation.FLAGS_PRINT;
					break;
			}
			return field;
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