package
{
	import flash.events.Event;
	
	import org.purepdf.Font;
	import org.purepdf.elements.Paragraph;
	import org.purepdf.pdf.fonts.BaseFont;
	import org.purepdf.pdf.fonts.BuiltinCJKFonts;
	import org.purepdf.pdf.fonts.cmaps.CJKFontResourceFactory;
	import org.purepdf.pdf.fonts.cmaps.CMap;
	import org.purepdf.pdf.fonts.cmaps.CMapResourceFactory;
	import org.purepdf.pdf.fonts.cmaps.ICMap;
	import org.purepdf.utils.IProperties;
	import org.purepdf.utils.Properties;

	public class ChineseKoreanJapanese extends DefaultBasicExample
	{
		public function ChineseKoreanJapanese()
		{
			super(null);
			
			var map: ICMap = new CMap( new CMap.Uni_GBUCS2_H() );
			CMapResourceFactory.getInstance().registerCMap( BaseFont.UniGBUCS2_H, map );
			
			var prop: IProperties = new Properties();
			prop.load( new BuiltinCJKFonts.STSONGLIGHT() );
			
			CJKFontResourceFactory.getInstance().registerProperty( "STSong-Light.properties", prop );
		}
		
		override protected function execute(event:Event=null) : void
		{
			super.execute();
			createDocument();
			document.open();
			
			var bf: BaseFont = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED, true );
			var font: Font = new Font( -1. -1, 12, -1, null, bf );
			
			document.add( new Paragraph("\u5341\u950a\u57cb\u4f0f", font));
			
			document.close();
			save();
		}
	}
}