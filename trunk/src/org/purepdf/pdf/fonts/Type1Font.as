package org.purepdf.pdf.fonts
{
	import flash.utils.ByteArray;
	
	import it.sephiroth.utils.HashMap;
	
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.purepdf.errors.DocumentError;
	import org.purepdf.errors.NonImplementatioError;
	import org.purepdf.io.LineReader;
	import org.purepdf.pdf.ByteBuffer;
	import org.purepdf.pdf.PdfEncodings;
	import org.purepdf.utils.Bytes;
	import org.purepdf.utils.StringTokenizer;
	import org.purepdf.utils.StringUtils;

	public class Type1Font extends BaseFont
	{
		private static const PFB_TYPES: Vector.<int> = Vector.<int>( [ 1, 2, 1 ] );
		protected var pfb: Vector.<int>;
		private var Ascender: int = 800;
		private var CapHeight: int = 700;
		private var CharMetrics: HashMap = new HashMap();
		private var CharacterSet: String;
		private var Descender: int = -200;
		private var EncodingScheme: String = "FontSpecific";
		private var FamilyName: String;
		private var FontName: String;
		private var FullName: String;
		private var IsFixedPitch: Boolean = false;
		private var ItalicAngle: Number = 0.0;
		private var KernPairs: HashMap = new HashMap();
		private var StdHW: int;
		private var StdVW: int = 80;
		private var UnderlinePosition: int = -100;
		private var UnderlineThickness: int = 50;
		private var Weight: String = "";
		private var XHeight: int = 480;
		private var builtinFont: Boolean = false;
		private var fileName: String;
		private var llx: int = -50;
		private var lly: int = -200;
		private var urx: int = 1000;
		private var ury: int = 900;
		
		private static var logger: ILogger = LoggerFactory.getClassLogger( Type1Font );

		public function Type1Font( afmFile: String, enc: String, emb: Boolean, ttfAfm: Vector.<int>, pfb: Vector.<int>, forceRead: Boolean )
		{
			if (emb && ttfAfm != null && pfb == null)
				throw new DocumentError("two byte arrays are needed. if the type1 font is embedded");
			if (emb && ttfAfm != null)
				this.pfb = pfb;
			
			_encoding = enc;
			embedded = emb;
			fileName = afmFile;
			_fontType = FONT_TYPE_T1;
			
			if( builtinFonts14.containsKey( afmFile ) )
			{
				embedded = false;
				builtinFont = true;
				
				var byte: ByteArray = FontsResourceFactory.getInstance().getFontFile( afmFile + ".afm" );

				if( byte == null )
					throw new DocumentError( afmFile + " not found in resources" );
				
				process( new LineReader( byte ) );
			} else
			{
				throw new DocumentError( afmFile + " is not an amf or pfm recognized font file");
			}
			
			EncodingScheme = StringUtils.trim( EncodingScheme );
			
			if( EncodingScheme == "AdobeStandardEncoding" || EncodingScheme == "StandardEncoding" )
				fontSpecific = false;
			
			if( !StringUtils.startsWith( encoding, "#" ) )
				PdfEncodings.convertToBytes(" ", enc );
			createEncoding();
		}
		
		override protected function getRawWidth(c:int, name:String) : int
		{
			var metrics: Vector.<Object>;
			if( name == null )
			{
				metrics = CharMetrics.getValue(c) as Vector.<Object>;
			} else
			{
				if( name == notdef)
					return 0;
				metrics = CharMetrics.getValue( name ) as Vector.<Object>;
			}
			
			if( metrics != null )
				return metrics[1] as int;
			return 0;
		}
		
		override protected function getRawCharBBox( c: int, name: String ): Vector.<int>
		{
			var metrics: Vector.<Object>;
			if( name == null ) 
			{
				metrics = CharMetrics.getValue( c ) as Vector.<Object>;
			} else
			{
				if( name == notdef )
					return null;
				metrics = CharMetrics.getValue( name ) as Vector.<Object>;
			}
			if( metrics != null )
				return metrics[3] as Vector.<int>;
			return null;
		}
		
		
		protected function createEncoding(): void
		{
			var k: int;
			if( StringUtils.startsWith( encoding, "#" ) )
			{
				throw new NonImplementatioError();
			} else if( fontSpecific )
			{
				for( k = 0; k < 256; ++k )
				{
					widths[k] = getRawWidth(k, null);
					charBBoxes[k] = getRawCharBBox(k, null);
				}
			} else {
				var s: String;
				var name: String;
				var c: int;
				var b: Bytes = new Bytes(1);
				for( k = 0; k < 256; ++k )
				{
					b[0] = ByteBuffer.intToByte(k);
					s = PdfEncodings.convertToString( b, encoding );
					if( s.length > 0 )
						c = s.charCodeAt(0);
					else
						c = 63;	// '?'
					
					name = GlyphList.unicode2name(c);
					
					if( name == null )
						name = notdef;
					
					differences[k] = name;
					unicodeDifferences[k] = c;
					widths[k] = getRawWidth(c, name);
					charBBoxes[k] = getRawCharBBox(c, name);
				}
			}
		}
		
		/**
		 * Reads the font metrics
		 * 
		 * @param rf ByteArray containing the AFM file
		 * @throws DocumentError
		 * @throws IOError
		 */
		private function process( rf: LineReader ): void
		{
			var line: String;
			var isMetrics: Boolean = false;
			var tokens: StringTokenizer;
			var ident: String;
			
			while( ( line = rf.readLine() ) != null )
			{
				tokens = new StringTokenizer( line );
				
				if( !tokens.hasMoreTokens() )
					continue;
				
				ident = tokens.nextToken();
				
				switch( ident )
				{
					case "FontName": 
						FontName = tokens.nextToken();
						break;
					
					case "FullName":
						FullName = tokens.nextToken();
						break;
					
					case "FamilyName":
						FamilyName = tokens.nextToken();
						break;
					
					case "Weight":
						Weight = tokens.nextToken();
						break;
					
					case "ItalicAngle":
						ItalicAngle = parseFloat( tokens.nextToken() );
						break;
					
					case "IsFixedPitch":
						IsFixedPitch = tokens.nextToken() == "true";
						break;
					
					case "CharacterSet":
						CharacterSet = tokens.nextToken();
						break;
					
					case "FontBBox":
						llx = parseFloat( tokens.nextToken() );
						lly = parseFloat( tokens.nextToken() );
						urx = parseFloat( tokens.nextToken() );
						ury = parseFloat( tokens.nextToken() );
						break;
					
					case "UnderlinePosition":
						UnderlinePosition = parseFloat( tokens.nextToken() );
						break;
					
					case "UnderlineTickness":
						UnderlineThickness = parseFloat( tokens.nextToken() );
						break;
					
					case "EncodingScheme":
						EncodingScheme = tokens.nextToken();
						break;
					
					case "CapHeight":
						CapHeight = parseFloat( tokens.nextToken() );
						break;
					
					case "XHeight":
						XHeight = parseFloat( tokens.nextToken() );
						break;
					
					case "Ascender":
						Ascender = parseFloat( tokens.nextToken() );
						break;
					
					case "Descender":
						Descender = parseFloat( tokens.nextToken() );
						break;
					
					case "StdHW":
						StdHW = parseFloat( tokens.nextToken() );
						break;
					
					case "StdVW":
						StdVW = parseFloat( tokens.nextToken() );
						break;
					
					case "StartCharMetrics":
						isMetrics = true;
						break;
				}
				
				if( isMetrics ) break;
			}
			
			if( !isMetrics )
				throw new DocumentError("missing StartCharMetrics");

			while( ( line = rf.readLine() ) != null )
			{
				tokens = new StringTokenizer( line );
				if( !tokens.hasMoreTokens() )
					continue;
				
				ident = tokens.nextToken();
				
				if( ident == "EndCharMetrics" )
				{
					isMetrics = false;
					break;
				}
				
				var C: int = -1;
				var WX: int = 250;
				var N: String = "";
				var B: Vector.<int>;
				
				tokens = new StringTokenizer( line, /\s?;\s?/g );
				while( tokens.hasMoreTokens() )
				{
					var tokc: StringTokenizer = new StringTokenizer( tokens.nextToken() );
					
					if( !tokc.hasMoreTokens() )
						continue;
					
					ident = tokc.nextToken();
					
					if( ident == "C" )
						C = parseInt( tokc.nextToken() );
					else if( ident == "WX" )
						WX = parseFloat( tokc.nextToken() );
					else if( ident == "N" )
						N = tokc.nextToken();
					else if( ident == "B" )
						B = Vector.<int>([ parseInt( tokc.nextToken() ), 
							parseInt( tokc.nextToken() ),
							parseInt( tokc.nextToken() ),
							parseInt( tokc.nextToken() ) ]);
				}
				
				var metrics: Vector.<Object> = Vector.<Object>([ C, WX, N, B ]);
				if( C >= 0 )
					CharMetrics.put( C, metrics );
				CharMetrics.put( N, metrics );
			}
			
			if( isMetrics )
				throw new DocumentError("missing EndCharMetrics");
			
			if( !CharMetrics.containsKey("nonbreakingspace") )
			{
				var space: Vector.<Object> = CharMetrics.getValue("space") as Vector.<Object>;
				if( space != null )
					CharMetrics.put("nonbreakingspace", space );
			}
			
			while( ( line = rf.readLine() ) != null )
			{
				tokens = new StringTokenizer( line );
				if( !tokens.hasMoreTokens() )
					continue;
				
				ident = tokens.nextToken();
				if( ident == "EndFontMetrics" )
					return;
				if( ident == "StartKernPairs" )
				{
					isMetrics = true;
					break;
				}
			}
			
			if( !isMetrics )
				throw new DocumentError("Missing EndFontMetrics");
			
			while( ( line = rf.readLine() ) != null )
			{
				tokens = new StringTokenizer(line);
				if( !tokens.hasMoreTokens() )
					continue;
				
				ident = tokens.nextToken();
				
				if( ident == "KPX" )
				{
					var first: String = tokens.nextToken();
					var second: String = tokens.nextToken();
					var width: int = parseInt( tokens.nextToken() );
					var relateds: Vector.<Object> = KernPairs.getValue(first) as Vector.<Object>;
					if( relateds == null )
					{
						KernPairs.put( first, Vector.<Object>([second, width]));
					} else {
						var n: int = relateds.length;
						var relateds2: Vector.<Object>;
						relateds2 = relateds.concat();
						relateds2[n] = second;
						relateds2[n+1] = width;
						KernPairs.put( first, relateds2 );
					}	
				} else if( ident == "EndKernPairs" )
				{
					isMetrics = false;
					break;
				}
			}
			
			if( isMetrics )
				throw new DocumentError("missing EndKernPairs");
			
			
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}