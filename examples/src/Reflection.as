package
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.getClassByAlias;
	import flash.text.engine.FontDescription;
	import flash.utils.Timer;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import flashx.textLayout.operations.SplitParagraphOperation;
	import flashx.textLayout.utils.CharacterUtil;
	
	import it.sephiroth.utils.Entry;
	import it.sephiroth.utils.HashMap;
	import it.sephiroth.utils.collections.iterators.Iterator;
	
	import org.purepdf.Font;
	import org.purepdf.FontFactoryImp;
	import org.purepdf.IClonable;
	import org.purepdf.IComparable;
	import org.purepdf.IFontProvider;
	import org.purepdf.IIterable;
	import org.purepdf.ISplitCharacter;
	import org.purepdf.codecs.TIFFEncoder;
	import org.purepdf.colors.CMYKColor;
	import org.purepdf.colors.ExtendedColor;
	import org.purepdf.colors.GrayColor;
	import org.purepdf.colors.PatternColor;
	import org.purepdf.colors.RGBColor;
	import org.purepdf.colors.ShadingColor;
	import org.purepdf.colors.SpotColor;
	import org.purepdf.elements.Anchor;
	import org.purepdf.elements.Annotation;
	import org.purepdf.elements.Chapter;
	import org.purepdf.elements.ChapterAutoNumber;
	import org.purepdf.elements.Chunk;
	import org.purepdf.elements.Element;
	import org.purepdf.elements.ElementTags;
	import org.purepdf.elements.GreekList;
	import org.purepdf.elements.HeaderFooter;
	import org.purepdf.elements.List;
	import org.purepdf.elements.ListItem;
	import org.purepdf.elements.MarkedObject;
	import org.purepdf.elements.MarkedSection;
	import org.purepdf.elements.Meta;
	import org.purepdf.elements.MultiColumnText;
	import org.purepdf.elements.Paragraph;
	import org.purepdf.elements.Phrase;
	import org.purepdf.elements.ReadOnlyRectangle;
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.elements.RomanList;
	import org.purepdf.elements.Section;
	import org.purepdf.elements.SimpleCell;
	import org.purepdf.elements.SimpleTable;
	import org.purepdf.elements.images.ImageElement;
	import org.purepdf.elements.images.ImageRaw;
	import org.purepdf.elements.images.ImageTemplate;
	import org.purepdf.elements.images.ImageWMF;
	import org.purepdf.elements.images.Jpeg;
	import org.purepdf.errors.AssertionError;
	import org.purepdf.errors.BadElementError;
	import org.purepdf.errors.CastTypeError;
	import org.purepdf.errors.ConversionError;
	import org.purepdf.errors.DocumentError;
	import org.purepdf.errors.IllegalPdfSyntaxError;
	import org.purepdf.errors.IllegalStateError;
	import org.purepdf.errors.IndexOutOfBoundsError;
	import org.purepdf.errors.NonImplementatioError;
	import org.purepdf.errors.NullPointerError;
	import org.purepdf.errors.RuntimeError;
	import org.purepdf.errors.UnsupportedOperationError;
	import org.purepdf.events.ChapterEvent;
	import org.purepdf.events.ChunkEvent;
	import org.purepdf.events.PageEvent;
	import org.purepdf.events.ParagraphEvent;
	import org.purepdf.events.SectionEvent;
	import org.purepdf.factories.FontFactory;
	import org.purepdf.factories.GreekAlphabetFactory;
	import org.purepdf.factories.RomanAlphabetFactory;
	import org.purepdf.factories.RomanDigit;
	import org.purepdf.factories.RomanNumberFactory;
	import org.purepdf.html.Markup;
	import org.purepdf.io.ByteArrayInputStream;
	import org.purepdf.io.DataInputStream;
	import org.purepdf.io.FilterInputStream;
	import org.purepdf.io.InputStream;
	import org.purepdf.io.LineReader;
	import org.purepdf.io.OutputStreamCounter;
	import org.purepdf.io.zip.InflaterInputStream;
	import org.purepdf.lang.Character;
	import org.purepdf.lang.CharacterDataLatin1;
	import org.purepdf.lang.SpecialSymbol;
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
	import org.purepdf.pdf.barcode.Barcode;
	import org.purepdf.pdf.barcode.BarcodeEAN;
	import org.purepdf.pdf.barcode.BarcodeEANSUPP;
	import org.purepdf.pdf.codec.GifImage;
	import org.purepdf.pdf.codec.PngImage;
	import org.purepdf.pdf.codec.TiffImage;
	import org.purepdf.pdf.events.PdfPCellEventForwarder;
	import org.purepdf.pdf.events.PdfPTableEventForwarder;
	import org.purepdf.pdf.fonts.BaseFont;
	import org.purepdf.pdf.fonts.CJKFont;
	import org.purepdf.pdf.fonts.DocumentFont;
	import org.purepdf.pdf.fonts.FontsResourceFactory;
	import org.purepdf.pdf.fonts.GlyphList;
	import org.purepdf.pdf.fonts.StreamFont;
	import org.purepdf.pdf.fonts.TrueTypeFont;
	import org.purepdf.pdf.fonts.TrueTypeFontSubSet;
	import org.purepdf.pdf.fonts.TrueTypeFontUnicode;
	import org.purepdf.pdf.fonts.cmaps.CJKFontResourceFactory;
	import org.purepdf.pdf.fonts.cmaps.CMapResourceFactory;
	import org.purepdf.pdf.forms.FieldBase;
	import org.purepdf.pdf.forms.FieldText;
	import org.purepdf.pdf.forms.PdfFormField;
	import org.purepdf.resources.BuiltinCJKFonts;
	import org.purepdf.resources.BuiltinFonts;
	import org.purepdf.resources.CMap;
	import org.purepdf.resources.ICMap;
	import org.purepdf.utils.AlchemyUtils;
	import org.purepdf.utils.ByteArrayUtils;
	import org.purepdf.utils.Bytes;
	import org.purepdf.utils.FloatUtils;
	import org.purepdf.utils.IProperties;
	import org.purepdf.utils.IntHashMap;
	import org.purepdf.utils.NumberUtils;
	import org.purepdf.utils.Properties;
	import org.purepdf.utils.StringTokenizer;
	import org.purepdf.utils.StringUtils;
	import org.purepdf.utils.Utilities;
	import org.purepdf.utils.assertTrue;
	import org.purepdf.utils.collections.TreeSet;
	import org.purepdf.utils.iterators.VectorIterator;

	public class Reflection extends DefaultBasicExample
	{
		private var chapterFont: Font;
		private var packageFont: Font;
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
			packageFont = new Font(-1, 12, -1, RGBColor.DARK_GRAY, myriadpro_bold );
			sectionFont = new Font(-1, 14, -1, null, myriadpro_regular );
			
			linkFont = new Font(-1, 12, Font.UNDERLINE, RGBColor.BLUE, myriadpro_bold );
			defaultFont = new Font(-1, 10, -1, null, minionpro_regular );
			methodsFont = new Font(-1, 12, -1, null, minionpro_regular );
			methodsParamFont = new Font(-1, 10, -1, RGBColor.DARK_GRAY, minionpro_regular );
			paramFont = new Font( -1, 8, Font.NORMAL, RGBColor.GRAY, minionpro_regular );
			publicMethodsFont = new Font( -1, 11, Font.NORMAL, RGBColor.BLACK, minionpro_regular );
			
			queue = new HashMap( 200 );
			processed = new HashMap( 200 );
			
			timer = new Timer( 10, 1 );
			timer.addEventListener( TimerEvent.TIMER_COMPLETE, onTimerComplete );
			
			push_class( 
				ImageElement, ImageRaw, ImageTemplate, ImageWMF, Jpeg, Anchor, Annotation, ChapterAutoNumber,
				Chunk, Element, ElementTags, GreekList, HeaderFooter, List, ListItem, MarkedObject, MarkedSection,
				Meta, MultiColumnText, Paragraph, Phrase, ReadOnlyRectangle, RectangleElement, RomanList,
				SimpleCell, SimpleTable, TIFFEncoder, CMYKColor, ExtendedColor, GrayColor, PatternColor, RGBColor, ShadingColor, SpotColor, Element, 
				PdfViewPreferences, Font, IClonable, FontFactoryImp, IComparable, IFontProvider, IIterable, ISplitCharacter, RomanNumberFactory,
				PdfViewerPreferencesImp, AlchemyUtils, ByteArrayUtils, Bytes, FloatUtils, IntHashMap, IProperties, RomanAlphabetFactory, RomanDigit,
				PdfVersion, NumberUtils, Properties, StringTokenizer, StringUtils, Utilities, Markup, FontFactory, GreekAlphabetFactory,
				PdfTransparencyGroup, TreeSet, Barcode, BarcodeEAN, BarcodeEANSUPP, ByteArrayInputStream, DataInputStream, FilterInputStream,
				PdfTransition, VectorIterator, CJKFontResourceFactory, CMapResourceFactory, InputStream, LineReader, OutputStreamCounter,
				PdfTrailer, ICMap, CMap, BuiltinCJKFonts, BuiltinFonts, FieldBase, FieldText, PdfFormField, AssertionError, BadElementError,
				PdfTextArray, org.purepdf.pdf.GraphicState, GifImage, PngImage, TiffImage, InflaterInputStream, CastTypeError, ConversionError,
				PdfTemplate, PdfPCellEventForwarder, PdfPTableEventForwarder, ChapterEvent, ChunkEvent, PageEvent, ParagraphEvent, SectionEvent,
				PdfString, BaseFont, CJKFont, DocumentFont, FontsResourceFactory, GlyphList, StreamFont, DocumentError, IllegalPdfSyntaxError,
				PdfStream, TrueTypeFont, TrueTypeFontSubSet, TrueTypeFontUnicode, IllegalStateError, IndexOutOfBoundsError, NonImplementatioError,
				PdfSpotColor, PdfShading, PdfResources, PdfRectangle, SpecialSymbol, CharacterDataLatin1, Character, CharacterUtil,
				PdfReader, PdfPTable, PdfPRow, PdfPCell, PdfPatternPainter, PdfPattern, PdfPages, PdfPage, NullPointerError, RuntimeError,
				PdfOutline, PdfOCProperties, PdfObject, PdfNumber, PdfNull, PdfLiteral, PdfLine, PdfLayerMembership, UnsupportedOperationError,
				PdfLayer, PdfInfo, PdfIndirectObject, PdfImage, PdfGState, PdfFunction, PdfFormXObject, PdfFont, PdfEncryption,
				PdfEncodings, PdfDictionary, PdfDestination, PdfDashPattern, PdfCrossReference, PdfCopyFieldsImp, PdfContents,
				PdfContentByte, PdfColor, PdfChunk, PdfCatalog, PdfBorderArray, PdfBoolean, PdfBody, PdfBlendMode, PdfArray,
				PdfAppearance, PdfAnnotationsImp, PdfAnnotation, PdfAction, PdfAcroForm, PageSize, PageResources,
				Indentation, FontSelector, DefaultSplitCharacter, ColumnText, ColorDetails,
				ByteBuffer, BidiOrder, BidiOrderTypes, BidiLine, ArabicLigaturizer,
				PdfIndirectReference, PdfDocument );
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
			var header: HeaderFooter = new HeaderFooter( new Phrase("http://code.google.com/p/purepdf  (", f ), new Phrase(")", f ), true );
			header.alignment = Element.ALIGN_RIGHT;
			header.borderSides = RectangleElement.TOP;
			header.borderColor = new GrayColor(.7);
			header.borderWidth = .1
			document.setHeader( header );
			
			
			document.setMargins( 72, 72, 72, 72 );
			document.open();
			
			var title: Paragraph = new Paragraph(null, defaultFont);
			title.add( new Phrase("PUREPDF class list\n", mainFont ));
			title.add( new Phrase("This document has been generated automatically from purepdf using actionscript reflection methods\n\n", defaultFont ) );
			
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
			
			
			send_message( processed.size() + ". " + class_name );
			
			var chapterTitle: Paragraph = new Paragraph( " " + class_name, chapterFont );
			
			var chapter: Chapter = new Chapter( chapterTitle, ++section_count );
			chapter.bookmarkTitle = class_name;
			chapter.bookmarkOpen = false;
			chapter.triggerNewPage = false;
			//chapter.numberDepth = 0;
			
			paragraph = new Paragraph("In package:\t", publicMethodsFont );
			paragraph.add( new Phrase( package_name + "\n", packageFont ) );
			
			// extends
			if( element.factory.extendsClass.length() > 0 )
			{
				var p0: Phrase = new Phrase("Extends:\t", publicMethodsFont );
				
				var extended_classes: Vector.<String> = new Vector.<String>();
				for( k = 0; k < element.factory.extendsClass.length(); ++k )
				{
					node = element.factory.extendsClass[k];
					type = extractRealClassName( node.@type.toString() );
					push_queue( node.@type.toString() );
					extended_classes.push( type );
					
				}
				var phrase: Phrase = new Phrase( extended_classes.join(", ") + "\n", packageFont );
				p0.add( phrase );
				paragraph.add( p0 );
			}
			
			var link: Anchor = new Anchor( class_name + ".as", linkFont );
			link.reference = "http://purepdf.googlecode.com/svn/trunk/" + package_name.split(".").join("/") + "/" + class_name + ".as";
			var linkparagraph: Phrase = new Phrase("See online:\t", publicMethodsFont );
			paragraph.add( linkparagraph );
			paragraph.add( link );
			paragraph.add( "\n" );
			
			chapter.add( paragraph );
			
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
			
			if( queue.size() > 0 )
			{
				iterator = queue.entrySet().iterator();
				var next: Entry = iterator.next() as Entry;
				
				queue.remove( next.key );
				processed.put( next.key, 1 );
				var x: XML = describeType( next.value );
				if( x )
				{
					process_element( x );
				}
				
				
			} else {
				timer.stop();
				complete();
			}
		}
		
		private function complete(): void
		{
			send_message("completed. generating pdf...");
			document.close();
			save();
		}
	}
}