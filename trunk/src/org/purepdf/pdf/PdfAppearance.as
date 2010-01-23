package org.purepdf.pdf
{
	import it.sephiroth.utils.HashMap;
	
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.errors.NonImplementatioError;
	import org.purepdf.pdf.fonts.BaseFont;
	import org.purepdf.utils.pdf_core;

	public class PdfAppearance extends PdfTemplate
	{
		public static var _stdFieldFontNames: HashMap;
		
		public static function get stdFieldFontNames(): HashMap
		{
			if( _stdFieldFontNames == null )
				initFieldFontNames();
			return _stdFieldFontNames;
		}
		
		private static function initFieldFontNames(): void
		{
			_stdFieldFontNames = new HashMap();
			_stdFieldFontNames.put("Courier-BoldOblique", new PdfName("CoBO"));
			_stdFieldFontNames.put("Courier-Bold", new PdfName("CoBo"));
			_stdFieldFontNames.put("Courier-Oblique", new PdfName("CoOb"));
			_stdFieldFontNames.put("Courier", new PdfName("Cour"));
			_stdFieldFontNames.put("Helvetica-BoldOblique", new PdfName("HeBO"));
			_stdFieldFontNames.put("Helvetica-Bold", new PdfName("HeBo"));
			_stdFieldFontNames.put("Helvetica-Oblique", new PdfName("HeOb"));
			_stdFieldFontNames.put("Helvetica", PdfName.HELV);
			_stdFieldFontNames.put("Symbol", new PdfName("Symb"));
			_stdFieldFontNames.put("Times-BoldItalic", new PdfName("TiBI"));
			_stdFieldFontNames.put("Times-Bold", new PdfName("TiBo"));
			_stdFieldFontNames.put("Times-Italic", new PdfName("TiIt"));
			_stdFieldFontNames.put("Times-Roman", new PdfName("TiRo"));
			_stdFieldFontNames.put("ZapfDingbats", PdfName.ZADB);
			_stdFieldFontNames.put("HYSMyeongJo-Medium", new PdfName("HySm"));
			_stdFieldFontNames.put("HYGoThic-Medium", new PdfName("HyGo"));
			_stdFieldFontNames.put("HeiseiKakuGo-W5", new PdfName("KaGo"));
			_stdFieldFontNames.put("HeiseiMin-W3", new PdfName("KaMi"));
			_stdFieldFontNames.put("MHei-Medium", new PdfName("MHei"));
			_stdFieldFontNames.put("MSung-Light", new PdfName("MSun"));
			_stdFieldFontNames.put("STSong-Light", new PdfName("STSo"));
			_stdFieldFontNames.put("MSungStd-Light", new PdfName("MSun"));
			_stdFieldFontNames.put("STSongStd-Light", new PdfName("STSo"));
			_stdFieldFontNames.put("HYSMyeongJoStd-Medium", new PdfName("HySm"));
			_stdFieldFontNames.put("KozMinPro-Regular", new PdfName("KaMi"));
		}
		
		public function PdfAppearance($writer:PdfWriter=null)
		{
			super($writer);
			separator = 32;
		}
		
		override public function setFontAndSize( bf: BaseFont, size: Number): void
		{
			checkWriter();
			state.size = size;
			if (bf.fontType == BaseFont.FONT_TYPE_DOCUMENT) {
				throw new NonImplementatioError("Document font not yet supported");
			} else
			{
				state.fontDetails = writer.pdf_core::addSimpleFont(bf);
			}
			var psn: PdfName = stdFieldFontNames.getValue( bf.getPostscriptFontName() ) as PdfName;
			if (psn == null) 
			{
				if ( bf.subset && bf.fontType == BaseFont.FONT_TYPE_TTUNI )
					psn = state.fontDetails.fontName;
				else {
					psn = new PdfName( bf.getPostscriptFontName() );
					state.fontDetails.subset = false;
				}
			}
			var prs: PageResources = pageResources;
			prs.addFont(psn, state.fontDetails.indirectReference);
			content.append_bytes(psn.getBytes()).append_char(' ').append_number(size).append_string(" Tf").append_separator();
		}
		
		override public function duplicate(): PdfContentByte 
		{
			var tpl: PdfAppearance = new PdfAppearance( writer );
			tpl.pdf = pdf;
			tpl.thisReference = thisReference;
			tpl.pageResources = pageResources;
			tpl.bBox = RectangleElement.clone(bBox);
			tpl.group = group;
			tpl.layer = layer;
			if (matrix != null) {
				tpl.matrix = new PdfArray(matrix);
			}
			tpl.separator = separator;
			return tpl;
		}
		
		public static function createAppearance( writer: PdfWriter,  width: Number,  height: Number ): PdfAppearance
		{
			return _createAppearance( writer, width, height, null );
		}
		
		private static function _createAppearance(writer: PdfWriter, width: Number, height: Number, forcedName: PdfName ): PdfAppearance
		{
			var template: PdfAppearance = new PdfAppearance(writer);
			template.width = width;
			template.height = height;
			writer.pdf_core::addDirectTemplateSimple( template, forcedName );
			return template;
		}
	}
}