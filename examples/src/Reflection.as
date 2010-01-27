package
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.getClassByAlias;
	import flash.utils.Timer;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import flashx.textLayout.operations.SplitParagraphOperation;
	
	import it.sephiroth.utils.Entry;
	import it.sephiroth.utils.HashMap;
	import it.sephiroth.utils.collections.iterators.Iterator;
	
	import org.purepdf.Font;
	import org.purepdf.codecs.TIFFEncoder;
	import org.purepdf.colors.CMYKColor;
	import org.purepdf.colors.ExtendedColor;
	import org.purepdf.colors.GrayColor;
	import org.purepdf.colors.PatternColor;
	import org.purepdf.colors.RGBColor;
	import org.purepdf.colors.ShadingColor;
	import org.purepdf.colors.SpotColor;
	import org.purepdf.elements.Anchor;
	import org.purepdf.elements.Chapter;
	import org.purepdf.elements.ChapterAutoNumber;
	import org.purepdf.elements.Chunk;
	import org.purepdf.elements.Element;
	import org.purepdf.elements.HeaderFooter;
	import org.purepdf.elements.List;
	import org.purepdf.elements.ListItem;
	import org.purepdf.elements.Paragraph;
	import org.purepdf.elements.Phrase;
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.elements.Section;
	import org.purepdf.pdf.ArabicLigaturizer;
	import org.purepdf.pdf.BidiLine;
	import org.purepdf.pdf.BidiOrder;
	import org.purepdf.pdf.BidiOrderTypes;
	import org.purepdf.pdf.ByteBuffer;
	import org.purepdf.pdf.ColorDetails;
	import org.purepdf.pdf.ColumnText;
	import org.purepdf.pdf.DefaultSplitCharacter;
	import org.purepdf.pdf.FontSelector;
	import org.purepdf.pdf.GraphicState;
	import org.purepdf.pdf.Indentation;
	import org.purepdf.pdf.PageResources;
	import org.purepdf.pdf.PageSize;
	import org.purepdf.pdf.PdfAcroForm;
	import org.purepdf.pdf.PdfAction;
	import org.purepdf.pdf.PdfAnnotation;
	import org.purepdf.pdf.PdfAnnotationsImp;
	import org.purepdf.pdf.PdfAppearance;
	import org.purepdf.pdf.PdfArray;
	import org.purepdf.pdf.PdfBlendMode;
	import org.purepdf.pdf.PdfBody;
	import org.purepdf.pdf.PdfBoolean;
	import org.purepdf.pdf.PdfBorderArray;
	import org.purepdf.pdf.PdfCatalog;
	import org.purepdf.pdf.PdfChunk;
	import org.purepdf.pdf.PdfColor;
	import org.purepdf.pdf.PdfContentByte;
	import org.purepdf.pdf.PdfContents;
	import org.purepdf.pdf.PdfCopyFieldsImp;
	import org.purepdf.pdf.PdfCrossReference;
	import org.purepdf.pdf.PdfDashPattern;
	import org.purepdf.pdf.PdfDestination;
	import org.purepdf.pdf.PdfDictionary;
	import org.purepdf.pdf.PdfDocument;
	import org.purepdf.pdf.PdfEncodings;
	import org.purepdf.pdf.PdfEncryption;
	import org.purepdf.pdf.PdfFont;
	import org.purepdf.pdf.PdfFormXObject;
	import org.purepdf.pdf.PdfFunction;
	import org.purepdf.pdf.PdfGState;
	import org.purepdf.pdf.PdfImage;
	import org.purepdf.pdf.PdfIndirectObject;
	import org.purepdf.pdf.PdfIndirectReference;
	import org.purepdf.pdf.PdfInfo;
	import org.purepdf.pdf.PdfLayer;
	import org.purepdf.pdf.PdfLayerMembership;
	import org.purepdf.pdf.PdfLine;
	import org.purepdf.pdf.PdfLiteral;
	import org.purepdf.pdf.PdfNull;
	import org.purepdf.pdf.PdfNumber;
	import org.purepdf.pdf.PdfOCProperties;
	import org.purepdf.pdf.PdfObject;
	import org.purepdf.pdf.PdfOutline;
	import org.purepdf.pdf.PdfPCell;
	import org.purepdf.pdf.PdfPRow;
	import org.purepdf.pdf.PdfPTable;
	import org.purepdf.pdf.PdfPage;
	import org.purepdf.pdf.PdfPages;
	import org.purepdf.pdf.PdfPattern;
	import org.purepdf.pdf.PdfPatternPainter;
	import org.purepdf.pdf.PdfReader;
	import org.purepdf.pdf.PdfRectangle;
	import org.purepdf.pdf.PdfResources;
	import org.purepdf.pdf.PdfShading;
	import org.purepdf.pdf.PdfSpotColor;
	import org.purepdf.pdf.PdfStream;
	import org.purepdf.pdf.PdfString;
	import org.purepdf.pdf.PdfTemplate;
	import org.purepdf.pdf.PdfTextArray;
	import org.purepdf.pdf.PdfTrailer;
	import org.purepdf.pdf.PdfTransition;
	import org.purepdf.pdf.PdfTransparencyGroup;
	import org.purepdf.pdf.PdfVersion;
	import org.purepdf.pdf.PdfViewPreferences;
	import org.purepdf.pdf.PdfViewerPreferencesImp;
	import org.purepdf.pdf.PdfWriter;
	import org.purepdf.pdf.fonts.BaseFont;
	import org.purepdf.pdf.fonts.FontsResourceFactory;
	import org.purepdf.resources.BuiltinFonts;
	import org.purepdf.utils.StringUtils;

	public class Reflection extends DefaultBasicExample
	{
		private var chapterFont: Font;
		private var sectionFont: Font;
		private var titleFont: Font;
		private var defaultFont: Font;
		private var methodsFont: Font;
		private var methodsParamFont: Font;
		private var paramFont: Font;
		private var mainFont: Font;
		private var linkFont: Font;
		private var publicMethodsFont: Font;
		
		private var myriadpro_bold: BaseFont;
		private var minionpro_regular: BaseFont;
		private var myriadpro_regular: BaseFont;
		
		private var queue: HashMap;
		private var processed: HashMap;
		private var timer: Timer;
		
		[Embed(source="/Library/Fonts/MyriadPro-Semibold.otf", mimeType="application/octet-stream")] private var font1: Class;
		[Embed(source="/Library/Fonts/MinionPro-Regular.otf", mimeType="application/octet-stream")] private var font2: Class;
		[Embed(source="/Library/Fonts/MyriadPro-Regular.otf", mimeType="application/octet-stream")] private var font3: Class;
		
		public function Reflection(d_list:Array=null)
		{
			super(d_list);
			registerDefaultFont();
			
			FontsResourceFactory.getInstance().registerFont( "MyriadPro-Semibold.otf", new font1() );
			FontsResourceFactory.getInstance().registerFont( "MinionPro-Regular.otf", new font2() );
			FontsResourceFactory.getInstance().registerFont( "MyriadPro-Regular.otf", new font3() );
			
			minionpro_regular = BaseFont.createFont( "MinionPro-Regular.otf", BaseFont.WINANSI, false, true );
			myriadpro_regular = BaseFont.createFont( "MyriadPro-Regular.otf", BaseFont.WINANSI, false, true );
			myriadpro_bold = BaseFont.createFont( "MyriadPro-Semibold.otf", BaseFont.WINANSI, false, true );
			
			titleFont = new Font(-1, 24, Font.BOLD, null, myriadpro_bold );
			mainFont = new Font(-1, 32, Font.NORMAL, null, myriadpro_regular );
			chapterFont = new Font(-1, 24, -1, null, myriadpro_bold );
			sectionFont = new Font(-1, 14, -1, null, myriadpro_regular );
			
			linkFont = new Font(-1, 10, Font.UNDERLINE, RGBColor.BLUE, minionpro_regular );
			defaultFont = new Font(-1, 8, -1, null, minionpro_regular );
			methodsFont = new Font(-1, 12, -1, null, minionpro_regular );
			methodsParamFont = new Font(-1, 10, -1, RGBColor.DARK_GRAY, minionpro_regular );
			paramFont = new Font( -1, 8, Font.NORMAL, RGBColor.GRAY, minionpro_regular );
			publicMethodsFont = new Font( -1, 11, Font.NORMAL, RGBColor.BLACK, minionpro_regular );
			
			queue = new HashMap( 200 );
			processed = new HashMap( 200 );
			
			timer = new Timer( 10, 1 );
			timer.addEventListener( TimerEvent.TIMER_COMPLETE, onTimerComplete );
			
			push_class( TIFFEncoder, CMYKColor, ExtendedColor, GrayColor, PatternColor, RGBColor, ShadingColor, SpotColor, Element, 
				PdfViewPreferences,
				PdfViewerPreferencesImp,
				PdfVersion,
				PdfTransparencyGroup,
				PdfTransition,
				PdfTrailer,
				PdfTextArray,
				PdfTemplate,
				PdfString,
				PdfStream,
				PdfSpotColor, PdfShading, PdfResources, PdfRectangle,
				PdfReader, PdfPTable, PdfPRow, PdfPCell, PdfPatternPainter, PdfPattern, PdfPages, PdfPage,
				PdfOutline, PdfOCProperties, PdfObject, PdfNumber, PdfNull, PdfLiteral, PdfLine, PdfLayerMembership,
				PdfLayer, PdfInfo, PdfIndirectObject, PdfImage, PdfGState, PdfFunction, PdfFormXObject, PdfFont, PdfEncryption,
				PdfEncodings, PdfDictionary, PdfDestination, PdfDashPattern, PdfCrossReference, PdfCopyFieldsImp, PdfContents,
				PdfContentByte, PdfColor, PdfChunk, PdfCatalog, PdfBorderArray, PdfBoolean, PdfBody, PdfBlendMode, PdfArray,
				PdfAppearance, PdfAnnotationsImp, PdfAnnotation, PdfAction, PdfAcroForm, PageSize, PageResources,
				Indentation, FontSelector, DefaultSplitCharacter, ColumnText, ColorDetails,
				ByteBuffer, BidiOrder, BidiOrderTypes, BidiLine, ArabicLigaturizer,
				PdfIndirectReference, PdfDocument, PdfWriter );
		}
		
		private function push_class( ...rest: Array ): void
		{
			for each( var c: Class in rest )
			{
				push_queue( getQualifiedClassName( c ) );
			}
		}
		
		private function push_queue( cname: String ): void
		{
			if( !processed.containsKey( cname ) && StringUtils.startsWith( cname, "org.purepdf." ) )
			{
				var def: Object;
				try
				{
					def = getDefinitionByName( cname );
				} catch( e: ReferenceError ){}
				
				if( def )
				{
					queue.put( cname, def );
				}
			}
		}
		
		override protected function execute(event:Event=null):void
		{
			super.execute();
			
			createDocument();
			
			var f: Font = new Font( -1, 14, -1, RGBColor.GRAY, minionpro_regular );
			var footer: HeaderFooter = new HeaderFooter( new Phrase("", f ), null, true );
			footer.alignment = Element.ALIGN_CENTER;
			footer.borderSides = RectangleElement.NO_BORDER;
			document.setFooter( footer );
			
			f = new Font( -1, 10, -1, new GrayColor(.7), minionpro_regular );
			var header: HeaderFooter = new HeaderFooter( new Phrase("http://code.google.com/p/purepdf | ", f ), null, true );
			header.alignment = Element.ALIGN_RIGHT;
			header.borderSides = RectangleElement.TOP;
			header.borderColor = new GrayColor(.7);
			header.borderWidth = .1
			document.setHeader( header );
			
			
			document.setMargins( 72, 72, 72, 72 );
			document.open();
			
			var title: Paragraph = new Paragraph("purepdf Reference\n\n", mainFont );
			document.add( title );
			
			timer.start();
		}
		
		private function onTimerComplete( event: TimerEvent ): void
		{
			process_queue();
		}
		
		private var section_count: int = 0;
		
		private function process_element( element: XML ): void
		{
			var other_class: String;
			var node: XML;
			var k: int;
			var package_name: String = element.@name.toString().split("::").shift();
			var class_name: String = extractRealClassName( element.@name.toString() );
			var name: String;
			var type: String;
			var list: List;
			var section: Section;
			var paragraph: Paragraph;
			
			
			var chapter: Chapter = new Chapter( new Paragraph( " " + element.@name.toString(), chapterFont ), ++section_count );
			chapter.bookmarkTitle = class_name;
			chapter.bookmarkOpen = true;
			chapter.triggerNewPage = false;
			
			// extends
			if( element.factory.extendsClass.length() > 0 )
			{
				paragraph = new Paragraph("Extends: ", publicMethodsFont );
				
				var extended_classes: Vector.<String> = new Vector.<String>();
				for( k = 0; k < element.factory.extendsClass.length(); ++k )
				{
					node = element.factory.extendsClass[k];
					type = extractRealClassName( node.@type.toString() );
					push_queue( node.@type.toString() );
					extended_classes.push( type );
					
				}
				var phrase: Phrase = new Phrase( extended_classes.join(", ") + "\n", methodsFont );
				paragraph.add( phrase );
				chapter.add( paragraph );
			} else {
				paragraph = new Paragraph( null, publicMethodsFont );
			}
			
			var link: Anchor = new Anchor( class_name + ".as", linkFont );
			link.reference = "http://purepdf.googlecode.com/svn/trunk/" + package_name.split(".").join("/") + class_name + ".as";
			var linkparagraph: Phrase = new Phrase("See online: ", publicMethodsFont );
			paragraph.add( linkparagraph );
			paragraph.add( link );
			paragraph.add( "\n" );
			
			// constants
			if( element.constant.length() > 0 )
			{
				section = chapter.addSection1( new Paragraph( " Public constants", sectionFont ) );
				section.indentation = 20;
				paragraph = new Paragraph(null, defaultFont );
				
				for( k = 0; k < element.constant.length(); ++k )
				{
					node = element.constant[k];
					type = extractRealClassName( node.@type.toString() );
					name = node.@name.toString();
					
					var p: Phrase = new Phrase( "- ", defaultFont );
					p.add( new Phrase( name + ": ", defaultFont ) );
					p.add( new Phrase( type + "\n", paramFont ) );
					paragraph.add( p );
				}
				
				paragraph.add("\n");
				section.add( paragraph );
			}
			
			// --------------
			// accessors
			// --------------
			if( element.factory.accessor.length() > 0 )
			{
				section = chapter.addSection1(new Paragraph(" Public properties", sectionFont) );
				section.indentation = 20;
				paragraph = new Paragraph( null, defaultFont );
				var accType: String;
				
				for( k = 0; k < element.factory.accessor.length(); ++k )
				{
					node = element.factory.accessor[k];
					type = extractRealClassName( node.@type.toString() );
					name = node.@name.toString();
					accType = node.@access.toString();
					
					var phrase: Phrase = new Phrase( "- ", methodsFont );
					phrase.add( new Phrase( name, methodsFont ) );
					phrase.add( new Phrase( " [" + accType + "] ", paramFont ) );
					phrase.add( new Phrase( type + "\n", defaultFont ) );
					paragraph.add( phrase );
				}
				
				paragraph.add("\n");
				section.add( paragraph );
			}
			
			
			// ----------------
			// public methods
			// ----------------
			if( element.factory.method.length() > 0 )
			{
				section = chapter.addSection1( new Paragraph(" Public methods", sectionFont) );
				section.indentation = 20;
				paragraph = new Paragraph( null, defaultFont );
				
				var ctor_added: Boolean = false;
				for( k = 0; k < element.factory.method.length(); ++k )
				{
					if( k == 0 && !ctor_added && element.factory.constructor.length() > 0 )
					{
						node = element.factory.constructor[0];
						name = class_name;
						ctor_added = true;
						k = 0;
					} else
					{
						node = element.factory.method[k];
						name = node.@name.toString();
					}
					
					// method name
					var method: Phrase = new Phrase( "- " + name, methodsFont );
					var method_subject: String = " (";
	
					if( node.parameter.length() > 0 )
					{
						method_subject += " ";
						for( var j: int = 0; j < node.parameter.length(); ++j )
						{
							var pnode: XML = node.parameter[j];
							push_queue( pnode.@type.toString() );
							
							method_subject += extractRealClassName( pnode.@type.toString() );
							if( j < node.parameter.length() - 1 )
								method_subject += ", ";
						}
					}
					method_subject += " ) ";
					
					// return type
					if( node.@returnType )
					{
						method_subject += extractRealClassName( node.@returnType.toString() );
						push_queue( node.@returnType.toString() );
					}
					
					method.add( new Paragraph( method_subject, methodsParamFont ) );
					paragraph.add( method );
					paragraph.add( Chunk.NEWLINE );
				}
				
				section.add( paragraph );
				section.add( Chunk.NEWLINE );
				section.add( Chunk.NEWLINE );
			}
			
			document.add( chapter );
			
			// check new files
			push_queue( element.@base.toString() );
			
			for( k = 0; k < element.factory.extendsClass.length(); ++k )
			{
				node = element.factory.extendsClass[k];
				push_queue( node.@type.toString() );
			}
			
			timer.reset();
			timer.start();
		}
		
		private function extractRealClassName( s: String ): String
		{
			var index: int = s.indexOf("::");
			if( index > -1 )
				return s.substr( index + 2 );
			return s;
		}
		
		private function process_queue(): void
		{
			var iterator: Iterator;
			
			trace( queue.size(), processed.size() );
			if( queue.size() > 0 )
			{
				iterator = queue.entrySet().iterator();
				var next: Entry = iterator.next() as Entry;
				
				queue.remove( next.key );
				processed.put( next.key, 1 );
				var x: XML = describeType( next.value );
				if( x )
				{
					trace( "\n>>>>> " + next.value );
					process_element( x );
				}
				
				
			} else {
				timer.stop();
				complete();
			}
		}
		
		private function complete(): void
		{
			trace('FINISH!!!');
			
			//document.add( mainChapter );
			document.close();
			save();
		}
	}
}