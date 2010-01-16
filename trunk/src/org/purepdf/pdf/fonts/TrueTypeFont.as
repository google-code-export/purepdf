package org.purepdf.pdf.fonts
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import it.sephiroth.utils.HashMap;
	
	import org.purepdf.errors.DocumentError;
	import org.purepdf.errors.NonImplementatioError;
	import org.purepdf.pdf.PdfEncodings;
	import org.purepdf.utils.StringUtils;

	public class TrueTypeFont extends BaseFont
	{
		private static const codePages: Vector.<String> = Vector.<String>( [ "1252 Latin 1", "1250 Latin 2: Eastern Europe", "1251 Cyrillic", "1253 Greek", "1254 Turkish", "1255 Hebrew", "1256 Arabic", "1257 Windows Baltic", "1258 Vietnamese", null, null, null, null, null, null, null, "874 Thai", "932 JIS/Japan", "936 Chinese: Simplified chars--PRC and Singapore", "949 Korean Wansung", "950 Chinese: Traditional chars--Taiwan and Hong Kong", "1361 Korean Johab", null, null, null, null, null, null, null, "Macintosh Character Set (US Roman)", "OEM Character Set", "Symbol Character Set", null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, "869 IBM Greek", "866 MS-DOS Russian", "865 MS-DOS Nordic", "864 Arabic", "863 MS-DOS Canadian French", "862 Hebrew", "861 MS-DOS Icelandic", "860 MS-DOS Portuguese", "857 IBM Turkish", "855 IBM Cyrillic; primarily Russian", "852 Latin 2", "775 MS-DOS Baltic", "737 Greek; former 437 G", "708 Arabic; ASMO 708", "850 WE/Latin 1", "437 US" ] );
		protected var justNames: Boolean = false;
		protected var tables: HashMap;
		protected var fileName: String;
		protected var cff: Boolean = false;
		protected var cffOffset: int = 0;
		protected var cffLength: int = 0;
		protected var directoryOffset: int = 0;
		protected var ttcIndex: String;
		protected var style: String = "";
		protected var head: FontHeader = new FontHeader();
		protected var hhea: HorizontalHeader = new HorizontalHeader();
		protected var os_2: WindowsMetrics = new WindowsMetrics();
		protected var GlyphWidths: Vector.<int>;
		protected var bboxes: Vector.<Vector.<int>>;
		protected var cmap10: HashMap;
		protected var cmap31: HashMap;
		protected var cmapExt: HashMap;
		protected var kerning: Dictionary = new Dictionary();
		protected var fontName: String;
		protected var fullName: Vector.<Vector.<String>>;
		protected var allNameEntries: Vector.<Vector.<String>>;
		protected var familyName: Vector.<Vector.<String>>;
		protected var italicAngle: Number = 0;
		protected var isFixedPitch: Boolean = false;
		protected var underlinePosition: int = 0;
		protected var underlineThickness: int = 0;
		protected var rf: ByteArray;

		/** Creates a new TrueType font.
		 * @param enc the encoding to be applied to this font
		 * @param emb true if the font is to be embedded in the PDF
		 * @param ttfAfm
		 * @throws DocumentError
		 * @throws IOError
		 */
		public function TrueTypeFont( $ttFile: String, $enc: String, $emb: Boolean, $ttfAfm: Vector.<int>, $justNames: Boolean, $forceRead: Boolean)
		{
			justNames = $justNames;
			var nameBase: String = getBaseName( $ttFile );
			var ttcName: String = getTTCName( nameBase );
			
			if( nameBase.length < $ttFile.length )
				style = $ttFile.substring( nameBase.length );
			
			_encoding = $enc;
			embedded = $emb;
			fileName = ttcName;
			_fontType = FONT_TYPE_TT;
			ttcIndex = "";
			
			if( ttcName.length < nameBase.length )
				ttcIndex = nameBase.substring( ttcName.length + 1);
			
			if( StringUtils.endsWith( fileName.toLowerCase(), ".ttf") || StringUtils.endsWith( fileName.toLowerCase(), ".otf") 
				|| StringUtils.endsWith( fileName.toLowerCase(), ".ttc") )
			{
				rf = FontsResourceFactory.getInstance().getFontFile( fileName );
				rf.position = 0;
				process( $forceRead );
				
				if( !justNames && embedded && os_2.fsType == 2 )
					throw new DocumentError( fileName + " cannot be embedded due to licensing restrictions" );
			}
			else
				throw new DocumentError( fileName + " is not a ttf otf or ttc font file" );
			
			if ( !StringUtils.startsWith( encoding, "#") )
				PdfEncodings.convertToBytes(" ", $enc ); // check if the encoding exists
			createEncoding();
		}
		
		/**
		 * Read the font data
		 * 
		 * @throws DocumentError
		 * @throws IOError
		 */
		private function process( preload: Boolean ): void
		{
			tables = new HashMap();
			try 
			{
				if( ttcIndex.length > 0 ) {
					var dirIdx: int = parseInt( ttcIndex );
					if( dirIdx < 0 )
						throw new DocumentError( "the font index must be positive" );
					var mainTag: String = readStandardString( 4 );
					if( !mainTag == "ttcf" )
						throw new DocumentError( fileName + " is not a valid ttc file" );

					rf.position += 4;
					var dirCount: int = rf.readInt();
					if( dirIdx >= dirCount )
						throw new DocumentError( "the font index must be between " + (dirCount-1) + " and " + dirIdx );
					rf.position += dirIdx*4;
					directoryOffset = rf.readInt();
				}
				
				rf.position = directoryOffset;
				var ttId: int = rf.readInt();
				if (ttId != 0x00010000 && ttId != 0x4F54544F)
					throw new DocumentError( fileName + "is not a valid ttf or otf file" );
				var num_tables: int = rf.readUnsignedShort();
				rf.position += 6;
				
				for( var k: int = 0; k < num_tables; ++k )
				{
					var tag: String = readStandardString( 4 );
					rf.position += 4;
					var table_location: Vector.<int> = new Vector.<int>(2, true);
					table_location[0] = rf.readInt();
					table_location[1] = rf.readInt();
					tables.put( tag, table_location );
				}
				
				checkCff();
				fontName = getBaseFont();
				fullName = getNames(4); //full name
				familyName = getNames(1); //family name
				allNameEntries = getAllNames();
				
				if( !justNames )
				{
					fillTables();
					readGlyphWidths();
					readCMaps();
					/*readKerning();
					readBbox();
					GlyphWidths = null;*/
				}
			}
			finally
			{
				if (rf != null) {
					if (!embedded)
						rf = null;
				}
			}
		}
		
		/** 
		 * Reads the several maps from the table 'cmap'. The maps of interest are 1.0 for symbolic
		 * fonts and 3.1 for all others. A symbolic font is defined as having the map 3.0.
		 * @throws DocumentError
		 * @throws EOFError
		 */
		private function readCMaps(): void
		{
			throw new NonImplementatioError();
		}
		
		/** 
		 * Reads the glyphs widths. The widths are extracted from the table 'hmtx'.
		 * The glyphs are normalized to 1000 units.
		 * @throws DocumentError
		 * @throws EOFError
		 */
		protected function readGlyphWidths(): void
		{
			var table_location: Vector.<int>;
			table_location = tables.getValue("hmtx") as Vector.<int>;
			if (table_location == null)
				throw new DocumentError( "table hmtx does not exist in " + (fileName + style));
			rf.position = table_location[0];
			GlyphWidths = new Vector.<int>( hhea.numberOfHMetrics, true );
			for( var k: int = 0; k < hhea.numberOfHMetrics; ++k ) 
			{
				GlyphWidths[k] = (rf.readUnsignedShort() * 1000) / head.unitsPerEm;
				rf.readUnsignedShort();
			}
		}
		
		/**
		 * Reads the tables 'head', 'hhea', 'OS/2' and 'post' filling several variables.
		 * @throws DocumentError
		 * @throws EOFError
		 */
		private function fillTables(): void
		{
			var table_location: Vector.<int>;
			table_location = tables.getValue("head") as Vector.<int>;
			if (table_location == null)
				throw new DocumentError( "table head does not exist in " + (fileName + style));
			rf.position = table_location[0] + 16;
			head.flags = rf.readUnsignedShort();
			head.unitsPerEm = rf.readUnsignedShort();
			rf.position += 16;
			head.xMin = rf.readShort();
			head.yMin = rf.readShort();
			head.xMax = rf.readShort();
			head.yMax = rf.readShort();
			head.macStyle = rf.readUnsignedShort();
			
			table_location = tables.getValue("hhea") as Vector.<int>;
			if (table_location == null)
				throw new DocumentError( "table hhea does not exist in " + (fileName + style));
			rf.position = table_location[0] + 4;
			hhea.Ascender = rf.readShort();
			hhea.Descender = rf.readShort();
			hhea.LineGap = rf.readShort();
			hhea.advanceWidthMax = rf.readUnsignedShort();
			hhea.minLeftSideBearing = rf.readShort();
			hhea.minRightSideBearing = rf.readShort();
			hhea.xMaxExtent = rf.readShort();
			hhea.caretSlopeRise = rf.readShort();
			hhea.caretSlopeRun = rf.readShort();
			rf.position += 12;
			hhea.numberOfHMetrics = rf.readUnsignedShort();
			
			table_location = tables.getValue("OS/2") as Vector.<int>;
			if (table_location == null)
				throw new DocumentError( "table OS/2 does not exist in " + (fileName + style));
			rf.position = table_location[0];
			var version: int = rf.readUnsignedShort();
			os_2.xAvgCharWidth = rf.readShort();
			os_2.usWeightClass = rf.readUnsignedShort();
			os_2.usWidthClass = rf.readUnsignedShort();
			os_2.fsType = rf.readShort();
			os_2.ySubscriptXSize = rf.readShort();
			os_2.ySubscriptYSize = rf.readShort();
			os_2.ySubscriptXOffset = rf.readShort();
			os_2.ySubscriptYOffset = rf.readShort();
			os_2.ySuperscriptXSize = rf.readShort();
			os_2.ySuperscriptYSize = rf.readShort();
			os_2.ySuperscriptXOffset = rf.readShort();
			os_2.ySuperscriptYOffset = rf.readShort();
			os_2.yStrikeoutSize = rf.readShort();
			os_2.yStrikeoutPosition = rf.readShort();
			os_2.sFamilyClass = rf.readShort();
			rf.readBytes( os_2.panose.buffer, 0, os_2.panose.length );
			rf.position += 16;
			rf.readBytes( os_2.achVendID.buffer, 0, os_2.achVendID.length );
			os_2.fsSelection = rf.readUnsignedShort();
			os_2.usFirstCharIndex = rf.readUnsignedShort();
			os_2.usLastCharIndex = rf.readUnsignedShort();
			os_2.sTypoAscender = rf.readShort();
			os_2.sTypoDescender = rf.readShort();
			if (os_2.sTypoDescender > 0)
				os_2.sTypoDescender = -os_2.sTypoDescender;
			os_2.sTypoLineGap = rf.readShort();
			os_2.usWinAscent = rf.readUnsignedShort();
			os_2.usWinDescent = rf.readUnsignedShort();
			os_2.ulCodePageRange1 = 0;
			os_2.ulCodePageRange2 = 0;
			if (version > 0) {
				os_2.ulCodePageRange1 = rf.readInt();
				os_2.ulCodePageRange2 = rf.readInt();
			}
			if (version > 1) {
				rf.position += 2;
				os_2.sCapHeight = rf.readShort();
			}
			else
				os_2.sCapHeight = int(0.7 * head.unitsPerEm);
			
			table_location = tables.getValue("post") as Vector.<int>;
			if (table_location == null) {
				italicAngle = -Math.atan2(hhea.caretSlopeRun, hhea.caretSlopeRise) * 180 / Math.PI;
				return;
			}
			rf.position = table_location[0] + 4;
			var mantissa: int = rf.readShort();
			var fraction: int = rf.readUnsignedShort();
			italicAngle = mantissa + fraction / 16384.0;
			underlinePosition = rf.readShort();
			underlineThickness = rf.readShort();
			isFixedPitch = rf.readInt() != 0;
		}
		
		/** 
		 * Extracts all the names of the names table
		 * @throws DocumentError
		 * @throws IOError
		 * @throws EOFError
		 */    
		private function getAllNames(): Vector.<Vector.<String>>
		{
			var k: int;
			var table_location: Vector.<int>;
			table_location = tables.getValue("name") as Vector.<int>;
			if (table_location == null)
				throw new DocumentError("table name does not exists in " + ( fileName + style ) );
			rf.position = table_location[0] + 2;
			var numRecords: int = rf.readUnsignedShort();
			var startOfStorage: int = rf.readUnsignedShort();
			var names: Vector.<Vector.<String>> = new Vector.<Vector.<String>>();
			for( k = 0; k < numRecords; ++k )
			{
				var platformID: int = rf.readUnsignedShort();
				var platformEncodingID: int = rf.readUnsignedShort();
				var languageID: int = rf.readUnsignedShort();
				var nameID: int = rf.readUnsignedShort();
				var length: int = rf.readUnsignedShort();
				var offset: int = rf.readUnsignedShort();
				var pos: int = rf.position;
				rf.position = (table_location[0] + startOfStorage + offset);
				var name: String;
				if( platformID == 0 || platformID == 3 || (platformID == 2 && platformEncodingID == 1) )
					name = readUnicodeString(length);
				else
					name = readStandardString(length);

				names.push( Vector.<String>([ nameID.toString(), platformID.toString(), platformEncodingID.toString(), languageID.toString(), name]));
				rf.position = pos;
			}
			var thisName: Vector.<Vector.<String>> = new Vector.<Vector.<String>>( names.length, true );
			for( k = 0; k < names.length; ++k )
				thisName[k] = names[k];
			return thisName;
		}
		
		/** 
		 * Extracts the names of the font in all the languages available.
		 * @param id the name id to retrieve
		 * @throws DocumentException on error
		 * @throws EOFError
		 * @throws IOError
		 */    
		private function getNames( id: int ): Vector.<Vector.<String>>
		{
			var k: int;
			var table_location: Vector.<int>;
			table_location = tables.getValue("name") as Vector.<int>;
			if (table_location == null)
				throw new DocumentError("table name does not exists in " + fileName );
			rf.position = table_location[0] + 2; 
			var numRecords: int = rf.readUnsignedShort();
			var startOfStorage: int = rf.readUnsignedShort();
			var names: Vector.<Vector.<String>> = new Vector.<Vector.<String>>();
			for( k = 0; k < numRecords; ++k )
			{
				var platformID: int = rf.readUnsignedShort();
				var platformEncodingID: int = rf.readUnsignedShort();
				var languageID: int = rf.readUnsignedShort();
				var nameID: int = rf.readUnsignedShort();
				var length: int = rf.readUnsignedShort();
				var offset: int = rf.readUnsignedShort();
				if( nameID == id )
				{
					var pos: int = rf.position;
					rf.position = (table_location[0] + startOfStorage + offset);
					var name: String;
					if( platformID == 0 || platformID == 3 || (platformID == 2 && platformEncodingID == 1) )
						name = readUnicodeString(length);
					else
						name = readStandardString(length);
					names.push( Vector.<String>([ platformID.toString(), platformEncodingID.toString(), languageID.toString(), name]));
					rf.position = pos;
				}
			}
			var thisName: Vector.<Vector.<String>> = new Vector.<Vector.<String>>( names.length, true );
			
			for( k = 0; k < names.length; ++k )
				thisName[k] = names[k];
			return thisName;
		}
		
		/**
		 * Gets the Postscript font name.
		 * @throws DocumentError
		 * @throws IOError
		 */
		private function getBaseFont(): String
		{
			var table_location: Vector.<int>;
			table_location = tables.getValue("name") as Vector.<int>;
			if( table_location == null )
				throw new DocumentError( "table does not exist in " + ( fileName + style) );
			rf.position = table_location[0] + 2;
			var numRecords: int = rf.readUnsignedShort();
			var startOfStorage: int = rf.readUnsignedShort();
			for( var k: int = 0; k < numRecords; ++k )
			{
				var platformID: int = rf.readUnsignedShort();
				var platformEncodingID: int = rf.readUnsignedShort();
				var languageID: int = rf.readUnsignedShort();
				var nameID: int = rf.readUnsignedShort();
				var length: int = rf.readUnsignedShort();
				var offset: int = rf.readUnsignedShort();
				if( nameID == 6 )
				{
					rf.position = table_location[0] + startOfStorage + offset;
					if( platformID == 0 || platformID == 3 )
						return readUnicodeString( length );
					else
						return readStandardString( length );
				}
			}

			return fileName.replace(/ /g, '-');
		}
		
		private function checkCff(): void
		{
			var table_location: Vector.<int>;
			table_location = tables.getValue("CFF ") as Vector.<int>;
			if (table_location != null) 
			{
				cff = true;
				cffOffset = table_location[0];
				cffLength = table_location[1];
			}
		}
		
		/** 
		 * Gets the name from a composed TTC file name.
		 */    
		protected static function getTTCName( name: String ): String
		{
			var idx: int = name.toLowerCase().indexOf(".ttc,");
			if (idx < 0)
				return name;
			else
				return name.substring(0, idx + 4);
		}
		
		/** 
		 * Reads a String from the font file as bytes using the Cp1252 encoding
		 * @throws IOError
		 */
		protected function readStandardString( length: int ): String
		{
			return rf.readMultiByte( length, "windows-1252" );
		}
		
		/**
		 * @throws EOFError
		 */
		protected function readUnicodeString( length: int ): String
		{
			return rf.readMultiByte( length, "unicode" );
		}
	}
}

/**
 * Support classes
 */

import org.purepdf.utils.Bytes;

class FontHeader {
	public var flags: int;
	public var unitsPerEm: int;
	public var xMin: int;	// short
	public var yMin: int;	// short
	public var xMax: int;	// short
	public var yMax: int;	// short
	public var macStyle: int;
}

class HorizontalHeader {
	public var Ascender: int;    // short
	public var Descender: int;    // short
	public var LineGap: int;    // short
	public var advanceWidthMax: int;    // int
	public var minLeftSideBearing: int;    // short
	public var minRightSideBearing: int;    // short
	public var xMaxExtent: int;    // short
	public var caretSlopeRise: int;    // short
	public var caretSlopeRun: int;    // short
	public var numberOfHMetrics: int;    // int
}

class WindowsMetrics {
	public var xAvgCharWidth: int;    // short
	public var usWeightClass: int;    // int
	public var usWidthClass: int;    // int
	public var fsType: int;    // short
	public var ySubscriptXSize: int;    // short
	public var ySubscriptYSize: int;    // short
	public var ySubscriptXOffset: int;    // short
	public var ySubscriptYOffset: int;    // short
	public var ySuperscriptXSize: int;    // short
	public var ySuperscriptYSize: int;    // short
	public var ySuperscriptXOffset: int;    // short
	public var ySuperscriptYOffset: int;    // short
	public var yStrikeoutSize: int;    // short
	public var yStrikeoutPosition: int;    // short
	public var sFamilyClass: int;    // short
	public var panose: Bytes = new Bytes(10);
	public var achVendID: Bytes = new Bytes(4);
	public var fsSelection: int;    // int
	public var usFirstCharIndex: int;    // int
	public var usLastCharIndex: int;    // int
	public var sTypoAscender: int;    // short
	public var sTypoDescender: int;    // short
	public var sTypoLineGap: int;    // short
	public var usWinAscent: int;    // int
	public var usWinDescent: int;    // int
	public var ulCodePageRange1: int;    // int
	public var ulCodePageRange2: int;    // int
	public var sCapHeight: int;    // int
}