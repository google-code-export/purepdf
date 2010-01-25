package org.purepdf.resources
{
	public class BuiltinCJKFonts
	{
			[Embed(source="properties/STSong-Light.properties", mimeType="application/octet-stream")]  
			public static var STSong_Light: Class;
			
			[Embed(source="properties/STSongStd-Light.properties", mimeType="application/octet-stream")]  
			public static var STSongStd_Light: Class;
			
			[Embed(source="properties/HeiseiKakuGo-W5.properties", mimeType="application/octet-stream")]  
			public static var HeiseiKakuGo_W5: Class;
			[Embed(source="properties/HeiseiMin-W3.properties", mimeType="application/octet-stream")]  
			public static var HeiseiMin_W3: Class;
			
			[Embed(source="properties/HYGoThic-Medium.properties", mimeType="application/octet-stream")]  
			public static var HYGoThic_Medium: Class;
			
			[Embed(source="properties/HYSMyeongJo-Medium.properties", mimeType="application/octet-stream")]  
			public static var HYSMyeongJo_Medium: Class;
			
			[Embed(source="properties/HYSMyeongJoStd-Medium.properties", mimeType="application/octet-stream")]  
			public static var HYSMyeongJoStd_Medium: Class;
			
			[Embed(source="properties/KozMinPro-Regular.properties", mimeType="application/octet-stream")]  
			public static var KozMinPro_Regular: Class;
			
			[Embed(source="properties/MHei-Medium.properties", mimeType="application/octet-stream")]  
			public static var MHei_Medium: Class;
			
			[Embed(source="properties/MSung-Light.properties", mimeType="application/octet-stream")]  
			public static var MSung_Light: Class;
			
			[Embed(source="properties/MSungStd-Light.properties", mimeType="application/octet-stream")]  
			public static var MSungStd_Light: Class;
			
			public static function getFontName( cls: Class ): String
			{
				if( cls == STSong_Light ) 		return "STSong-Light";
				if( cls == STSongStd_Light ) 	return "STSongStd-Light";
				if( cls == HeiseiKakuGo_W5 ) 	return "HeiseiKakuGo-W5";
				if( cls == HeiseiMin_W3 ) 		return "HeiseiMin-W3";
				if( cls == HYGoThic_Medium ) 	return "HYGoThic-Medium";
				if( cls == HYSMyeongJo_Medium ) return "HYSMyeongJo-Medium";
				if( cls == HYSMyeongJoStd_Medium ) return "HYSMyeongJoStd-Medium";
				if( cls == KozMinPro_Regular ) 	return "KozMinPro-Regular";
				if( cls == MHei_Medium ) 		return "MHei-Medium";
				if( cls == MSung_Light ) 		return "MSung-Light";
				if( cls == MSungStd_Light ) 	return "MSungStd-Light";
				return null;
			}
	}
}