package org.purepdf.pdf
{
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import it.sephiroth.utils.HashMap;
	import it.sephiroth.utils.IObject;
	import it.sephiroth.utils.collections.iterators.Iterator;
	import it.sephiroth.utils.hashLib;
	
	import org.purepdf.Font;
	import org.purepdf.colors.RGBColor;
	import org.purepdf.elements.Anchor;
	import org.purepdf.elements.Chunk;
	import org.purepdf.elements.Element;
	import org.purepdf.elements.IElement;
	import org.purepdf.elements.IElementListener;
	import org.purepdf.elements.ILargeElement;
	import org.purepdf.elements.Meta;
	import org.purepdf.elements.Paragraph;
	import org.purepdf.elements.Phrase;
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.elements.Section;
	import org.purepdf.elements.images.ImageElement;
	import org.purepdf.errors.ConversionError;
	import org.purepdf.errors.DocumentError;
	import org.purepdf.errors.NonImplementatioError;
	import org.purepdf.errors.RuntimeError;
	import org.purepdf.events.PageEvent;
	import org.purepdf.pdf.fonts.BaseFont;
	import org.purepdf.utils.iterators.VectorIterator;
	import org.purepdf.utils.pdf_core;

	[Event( name="closeDocument", type="org.purepdf.events.PageEvent" )]
	[Event( name="endPage", type="org.purepdf.events.PageEvent" )]
	[Event( name="startPage", type="org.purepdf.events.PageEvent" )]
	[Event( name="openDocument", type="org.purepdf.events.PageEvent" )]

	public class PdfDocument extends EventDispatcher implements IObject, IElementListener
	{
		internal static var compress: Boolean = false;

		protected var _duration: int = -1;
		protected var _hashCode: int;
		protected var _pageResources: PageResources;
		protected var _pageSize: RectangleElement;
		protected var _transition: PdfTransition = null;
		protected var _writer: PdfWriter;
		protected var alignment: int = Element.ALIGN_LEFT;
		protected var anchorAction: PdfAction = null;
		protected var annotationsImp: PdfAnnotationsImp;
		protected var boxSize: HashMap = new HashMap();
		protected var closed: Boolean;
		protected var currentHeight: Number = 0;
		protected var currentOutline: PdfOutline;
		protected var firstPageEvent: Boolean = true;
		protected var graphics: PdfContentByte;
		protected var imageEnd: Number = -1;
		protected var imageWait: ImageElement;
		protected var indentation: Indentation = new Indentation();
		protected var info: PdfInfo = new PdfInfo();
		protected var isSectionTitle: Boolean = false;
		protected var lastElementType: int = -1;
		protected var leading: Number = 0;
		protected var leadingCount: int = 0;
		protected var line: PdfLine = null;
		protected var lines: Vector.<PdfLine> = new Vector.<PdfLine>();
		protected var localDestinations: *;
		protected var marginBottom: Number = 36.0;
		protected var marginLeft: Number = 36.0;
		protected var marginMirroring: Boolean = false;
		protected var marginMirroringTopBottom: Boolean = false;
		protected var marginRight: Number = 36.0;
		protected var marginTop: Number = 36.0;
		protected var markPoint: int;
		protected var nextMarginBottom: Number = 36.0;
		protected var nextMarginLeft: Number = 36.0;
		protected var nextMarginRight: Number = 36.0;
		protected var nextMarginTop: Number = 36.0;
		protected var nextPageSize: RectangleElement;
		protected var opened: Boolean;
		protected var pageEmpty: Boolean = true;
		protected var pageN: int = 0;
		protected var rootOutline: PdfOutline;
		protected var strictImageSequence: Boolean = false;
		protected var text: PdfContentByte;
		protected var textEmptySize: int;
		protected var thisBoxSize: HashMap = new HashMap();
		protected var viewerPreferences: PdfViewerPreferencesImp = new PdfViewerPreferencesImp();

		public function PdfDocument( size: RectangleElement )
		{
			_pageSize = size;
			super();
			addProducer();
			addCreationDate();
		}

		/**
		 * Don't use this directly if you are 100% sure what
		 * you're doing. Use addElement() instead
		 *  
		 * @see addElement()
		 */
		public function add( element: IElement ): Boolean
		{
			if ( _writer != null && _writer.isPaused() )
				return false;

			switch ( element.type )
			{
				case Element.PRODUCER:
					info.addProducer();
					break;
				case Element.CREATIONDATE:
					info.addCreationDate();
					break;
				case Element.AUTHOR:
					info.addAuthor( Meta( element ).getContent() );
					break;
				case Element.TITLE:
					info.addTitle( Meta( element ).getContent() );
					break;
				case Element.SUBJECT:
					info.addSubject( Meta( element ).getContent() );
					break;
				case Element.CREATOR:
					info.addCreator( Meta( element ).getContent() );
					break;
				case Element.KEYWORDS:
					info.addKeywords( Meta( element ).getContent() );
					break;
				case Element.RECTANGLE:
					var rectangle: RectangleElement = RectangleElement( element );
					graphics.rectangle( rectangle );
					pageEmpty = false;
					break;
				case Element.JPEG:
				case Element.JPEG2000:
				case Element.JBIG2:
				case Element.IMGRAW:
				case Element.IMGTEMPLATE:
					addImage( ImageElement( element ) );
					break;

				case Element.PARAGRAPH:
					leadingCount++;
					var paragraph: Paragraph = Paragraph( element );
					addSpacing( paragraph.spacingBefore, leading, paragraph.font );
					alignment = paragraph.alignment;
					leading = paragraph.totalLeading;
					carriageReturn();

					if ( currentHeight + line.height + leading > indentTop - indentBottom )
						newPage();

					indentation.indentLeft += paragraph.indentationLeft;
					indentation.indentRight += paragraph.indentationRight;
					carriageReturn();

					if ( paragraph.keeptogether )
					{
						throw new NonImplementatioError();
					}
					else
					{
						line.extraIndent = paragraph.firstLineIndent;
						element.process( this );
						carriageReturn();
						addSpacing( paragraph.spacingAfter, paragraph.totalLeading, paragraph.font );
					}

					alignment = Element.ALIGN_LEFT;
					indentation.indentLeft -= paragraph.indentationLeft;
					indentation.indentRight -= paragraph.indentationRight;
					carriageReturn();
					leadingCount--;
					break;

				case Element.PHRASE:
					leadingCount++;
					leading = Phrase( element ).leading;
					element.process( this );
					leadingCount--;
					break;

				case Element.CHUNK:
					if ( line == null )
						carriageReturn();

					var chunk: PdfChunk = PdfChunk.createFromChunk( Chunk( element ), anchorAction );
					var overflow: PdfChunk;

					while ( ( overflow = line.add( chunk ) ) != null )
					{
						carriageReturn();
						chunk = overflow;
						chunk.trimFirstSpace();
					}
					pageEmpty = false;

					if ( chunk.isAttribute( Chunk.NEWPAGE ) )
						newPage();
					break;
				
				case Element.SECTION:
				case Element.CHAPTER:
					_addSection( Section(element) );
					break;
				
				case Element.ANCHOR:
					_addAnchor( Anchor(element) );
					break;

				default:
					trace( "PdfDocument.add. Invalid type: " + element.type );
					throw new DocumentError( 'PdfDocument.add. Invalid type: ' + element.type );
			}
			lastElementType = element.type;
			return true;
		}

		public function addAnnotation( annot: PdfAnnotation ): void
		{
			pageEmpty = false;

			if ( annot.writer == null )
				annot.writer = _writer;
			annotationsImp.addAnnotation( annot );
		}

		public function addAuthor( value: String ): Boolean
		{
			return add( new Meta( Element.AUTHOR, value ) );
		}

		public function addCreator( creator: String ): Boolean
		{
			return add( new Meta( Element.CREATOR, creator ) );
		}

		public function addElement( element: IElement ): Boolean
		{
			if ( closed )
				throw new Error( "document is closed" );

			if ( !opened && element.isContent )
				throw new Error( "document is not opened" );
			var success: Boolean = false;
			success = add( element );

			if ( element is ILargeElement )
			{
				var e: ILargeElement = ( element as ILargeElement );

				if ( !e.isComplete )
					e.flushContent();
			}
			return success;
		}

		public function addKeywords( keywords: String ): Boolean
		{
			return add( new Meta( Element.KEYWORDS, keywords ) );
		}

		public function addSubject( subject: String ): Boolean
		{
			return add( new Meta( Element.SUBJECT, subject ) );
		}

		public function addTitle( title: String ): Boolean
		{
			return add( new Meta( Element.TITLE, title ) );
		}

		public function bottom( margin: Number=0 ): Number
		{
			return _pageSize.getBottom( marginBottom + margin );
		}

		/**
		 * Close the document
		 */
		public function close(): void
		{
			if ( closed )
				return;
			var wasImage: Boolean = imageWait != null;
			newPage();

			if ( imageWait != null || wasImage )
				newPage();

			if ( annotationsImp.hasUnusedAnnotations() )
			{
				throw new RuntimeError( "not all annotation could be added to the document" );
			}
			dispatchEvent( new PageEvent( PageEvent.CLOSE_DOCUMENT ) );

			writer.addLocalDestinations( localDestinations );
			calculateOutlineCount();
			writeOutlines();

			if ( !closed )
			{
				opened = false;
				closed = true;
			}
			_writer.close();
		}

		/**
		 * Sets the display duration for the page (for presentations)
		 * @param seconds   the number of seconds to display the page
		 */
		public function set duration( seconds: int ): void
		{
			if ( seconds > 0 )
				_duration = seconds;
			else
				_duration = -1;
		}

		internal function getCatalog( pages: PdfIndirectReference ): PdfCatalog
		{
			trace( 'PdfDocument.getCatalog. to be implemented' );
			var catalog: PdfCatalog = new PdfCatalog( pages, _writer );

			// 1 outlines
			if( rootOutline.kids.length > 0 )
			{
				catalog.put( PdfName.PAGEMODE, PdfName.USEOUTLINES );
				catalog.put( PdfName.OUTLINES, rootOutline.indirectReference );
			}
			
			// 2 version
			_writer.getPdfVersion().addToCatalog( catalog );

			// 3 preferences
			viewerPreferences.addToCatalog( catalog );

			// 4 pagelables
			// 5 named objects
			// 6 actions
			// 7 portable collections
			// 8 acroform
			
			return catalog;
		}

		public function getDefaultColorSpace(): PdfDictionary
		{
			return _writer.getDefaultColorSpace();
		}

		public function getDirectContent(): PdfContentByte
		{
			return _writer.getDirectContent();
		}

		public function getInfo(): PdfInfo
		{
			return info;
		}

		public function getPageNumber(): int
		{
			return pageN;
		}

		public function hashCode(): int
		{
			if ( isNaN( _hashCode ) )
				_hashCode = hashLib.hashCode( getQualifiedClassName( this ), 36 );
			return _hashCode;
		}

		public function isOpen(): Boolean
		{
			return opened;
		}

		public function isPageEmpty(): Boolean
		{
			return _writer == null || ( _writer.getDirectContent().size() == 0 && _writer.getDirectContentUnder().size() == 0 && ( pageEmpty
				|| _writer.isPaused() ) );
		}

		public function left( margin: Number=0 ): Number
		{
			return _pageSize.getLeft( marginLeft + margin );
		}

		/**
		 * Use this method to lock a content group
		 * The state of a locked group can not be changed using the user
		 * interface of a viewer application
		 */
		public function lockLayer( layer: PdfLayer ): void
		{
			_writer.lockLayer( layer );
		}

		/**
		 * make a new page
		 */
		public function newPage(): Boolean
		{
			lastElementType = -1;

			if ( isPageEmpty() )
			{
				setNewPageSizeAndMargins();
				return false;
			}

			if ( !opened || closed )
			{
				throw new Error( "Document is not opened" );
			}
			dispatchEvent( new PageEvent( PageEvent.END_PAGE ) );

			flushLines();

			// 1
			var rotation: int = _pageSize.rotation;

			// 2
			pageResources.addDefaultColorDiff( writer.getDefaultColorSpace() );

			if ( writer.isRgbTransparencyBlending() )
			{
				var dcs: PdfDictionary = new PdfDictionary();
				dcs.put( PdfName.CS, PdfName.DEVICERGB );
				pageResources.addDefaultColorDiff( dcs );
			}

			var resources: PdfDictionary = _pageResources.getResources();

			// 3
			var page: PdfPage = new PdfPage( PdfRectangle.create( _pageSize, rotation ), thisBoxSize, resources, rotation );
			page.put( PdfName.TABS, _writer.getTabs() );

			// 4
			if ( _transition != null )
			{
				page.put( PdfName.TRANS, _transition.getTransitionDictionary() );
				_transition = null;
			}

			if ( _duration > 0 )
			{
				page.put( PdfName.DUR, new PdfNumber( _duration ) );
				_duration = 0;
			}
			
			// 5 we check if the userunit is defined
			if( writer.userunit > 0 )
				page.put( PdfName.USERUNIT, new PdfNumber( writer.userunit ) );

			// 6
			if ( annotationsImp.hasUnusedAnnotations() )
			{
				var array: PdfArray = annotationsImp.rotateAnnotations( _writer, _pageSize );

				if ( array.size() != 0 )
					page.put( PdfName.ANNOTS, array );
			}

			if ( text.size() > textEmptySize )
			{
				text.endText();
			}
			else
			{
				text = null;
			}
			_writer.add( page, new PdfContents( _writer.getDirectContentUnder(), graphics, text, _writer.getDirectContent(), _pageSize ) );
			// initialize the new page
			initPage();
			return true;
		}

		/**
		 * open the document
		 *
		 */
		public function open(): void
		{
			if ( !opened )
			{
				opened = true;
				pageSize = _pageSize;
				setMargins( marginLeft, marginRight, marginTop, marginBottom );
				_writer.open();
				rootOutline = new PdfOutline( _writer );
				currentOutline = rootOutline;
				initPage();
			}
			else
			{
				throw new Error( "Document is already opened" );
			}
		}

		public function get pageResources(): PageResources
		{
			return _pageResources;
		}

		/**
		 * Return the current pagesize
		 *
		 */
		public function get pageSize(): RectangleElement
		{
			return _pageSize;
		}

		/**
		 * Set the pagesize
		 *
		 */
		public function set pageSize( value: RectangleElement ): void
		{
			if ( _writer != null && _writer.isPaused() )
				return;

			nextPageSize = RectangleElement.clone( value );
		}

		public function right( margin: Number=0 ): Number
		{
			return _pageSize.getRight( marginRight + margin );
		}

		public function setDefaultColorSpace( key: PdfName, value: PdfObject ): void
		{
			_writer.setDefaultColorSpace( key, value );
		}

		public function setMargins( marginLeft: Number, marginRight: Number, marginTop: Number, marginBottom: Number ): Boolean
		{
			if ( _writer != null && _writer.isPaused() )
			{
				return false;
			}
			nextMarginLeft = marginLeft;
			nextMarginRight = marginRight;
			nextMarginTop = marginTop;
			nextMarginBottom = marginBottom;
			return true;
		}

		public function setPdfVersion( value: String ): void
		{
			_writer.setPdfVersion( value );
		}

		
		/**
		 * <p>Use this method to set the user unit</p>
		 * <p>A UserUnit is a value that defines the default user space unit</p>
		 * <p>The minimum UserUnit is 1 (1 unit = 1/72 inch).</p>
		 * <p>The maximum UserUnit is 75,000.</p>
		 * <p>Remember that you need to set the pdf version to 1.6</p>
		 * @throws DocumentError
		 * @since 1.6
		 */
		public function set userunit( value: Number ): void
		{
			writer.userunit = value;
		}
		
		public function get userunit(): Number
		{
			return writer.userunit;
		}
		
		/**
		 * Set the view preferences for this document
		 *
		 * @see org.purepdf.pdf.PdfViewPreferences
		 */
		public function setViewerPreferences( preferences: int ): void
		{
			viewerPreferences.setViewerPreferences( preferences );
		}

		public function top( margin: Number=0 ): Number
		{
			return _pageSize.getTop( marginTop + margin );
		}

		/**
		 * Set the transition for the page
		 */
		public function set transition( value: PdfTransition ): void
		{
			_transition = value;
		}

		public function get writer(): PdfWriter
		{
			return _writer;
		}


		/**
		 * Adds extra space.
		 * This method should probably be rewritten.
		 */
		protected function addSpacing( extraspace: Number, oldleading: Number, f: Font ): void
		{
			if ( extraspace == 0 )
				return;

			if ( pageEmpty )
				return;

			if ( currentHeight + line.height + leading > indentTop - indentBottom )
				return;
			leading = extraspace;
			carriageReturn();

			if ( f.isUnderline || f.isStrikethru )
			{
				f = f.clone() as Font;
				var style: int = f.style;
				style &= ~Font.UNDERLINE;
				style &= ~Font.STRIKETHRU;
				f.style = style;
			}
			var space: Chunk = new Chunk( " ", f );
			space.process( this );
			carriageReturn();
			leading = oldleading;
		}

		protected function carriageReturn(): void
		{
			if ( lines == null )
				lines = new Vector.<PdfLine>();

			if ( line != null )
			{
				if ( currentHeight + line.height + leading < indentTop - indentBottom )
				{
					if ( line.size() > 0 )
					{
						currentHeight += line.height;
						lines.push( line );
						pageEmpty = false;
					}
				}
				else
				{
					newPage();
				}
			}

			if ( imageEnd > -1 && currentHeight > imageEnd )
			{
				imageEnd = -1;
				indentation.imageIndentRight = 0;
				indentation.imageIndentLeft = 0;
			}
			line = new PdfLine( indentLeft, indentRight, alignment, leading );
		}

		protected function flushLines(): Number
		{
			if ( lines == null )
				return 0;

			if ( line != null && line.size() > 0 )
			{
				lines.push( line );
				line = new PdfLine( indentLeft, indentRight, alignment, leading );
			}

			if ( lines.length == 0 )
				return 0;


			var currentValues: Vector.<Object> = new Vector.<Object>( 2 );
			var currentFont: PdfFont = null;
			var displacement: Number = 0;
			var l: PdfLine;
			var lastBaseFactor: Number = 0;
			currentValues[ 1 ] = lastBaseFactor;

			for ( var i: Iterator = new VectorIterator( Vector.<Object>( lines ) ); i.hasNext();  )
			{
				l = PdfLine( i.next() );

				var moveTextX: Number = l.indentLeft - indentLeft + indentation.indentLeft + indentation.listIndentLeft + indentation.sectionIndentLeft;
				text.moveText( moveTextX, -l.height );

				if ( l.listSymbol != null )
				{
					throw new NonImplementatioError();
						//ColumnText.showTextAligned(graphics, Element.ALIGN_LEFT, new Phrase(l.listSymbol()), text.getXTLM() - l.listIndent(), text.getYTLM(), 0);
				}

				currentValues[ 0 ] = currentFont;
				writeLineToContent( l, text, graphics, currentValues, writer.spaceCharRatio );

				currentFont = PdfFont( currentValues[ 0 ] );
				displacement += l.height;
				text.moveText( -moveTextX, 0 );

			}

			lines = new Vector.<PdfLine>();
			return displacement;
		}

		protected function get indentBottom(): Number
		{
			return bottom( indentation.indentBottom );
		}

		protected function get indentLeft(): Number
		{
			return left( indentation.indentLeft + indentation.listIndentLeft + indentation.imageIndentLeft + indentation.sectionIndentLeft );
		}

		protected function get indentRight(): Number
		{
			return right( indentation.indentRight + indentation.sectionIndentRight + indentation.imageIndentRight );
		}

		protected function get indentTop(): Number
		{
			return top( indentation.indentTop );
		}

		protected function initPage(): void
		{
			pageN++;
			annotationsImp.resetAnnotations();
			_pageResources = new PageResources();
			_writer.resetContent();
			graphics = new PdfContentByte( _writer );
			text = new PdfContentByte( _writer );
			text.reset();
			text.beginText();
			textEmptySize = text.size();
			markPoint = 0;
			setNewPageSizeAndMargins();
			imageEnd = -1;
			currentHeight = 0;
			thisBoxSize = new HashMap();

			if ( _pageSize.backgroundColor != null || _pageSize.hasBorders() || _pageSize.borderColor != null )
			{
				add( _pageSize );
			}
			var oldleading: Number = leading;
			var oldAlignment: int = alignment;
			text.moveText( left(), top() );
			pageEmpty = true;

			try
			{
				if ( imageWait != null )
				{
					add( imageWait );
					imageWait = null;
				}
			}
			catch ( e: Error )
			{
				throw new ConversionError( e );
			}
			leading = oldleading;
			alignment = oldAlignment;
			carriageReturn();

			if ( firstPageEvent )
				dispatchEvent( new PageEvent( PageEvent.OPEN_DOCUMENT ) );
			dispatchEvent( new PageEvent( PageEvent.START_PAGE ) );
			firstPageEvent = false;
		}

		/**
		 * Adds the current line to the list of lines and also adds an empty line.
		 */
		protected function newLine(): void
		{
			lastElementType = -1;
			carriageReturn();

			if ( lines != null && !( lines.length == 0 ) )
			{
				lines.push( line );
				currentHeight += line.height;
			}
			line = new PdfLine( indentLeft, indentRight, alignment, leading );
		}

		protected function setNewPageSizeAndMargins(): void
		{
			_pageSize = nextPageSize;

			if ( marginMirroring && ( getPageNumber() & 1 ) == 0 )
			{
				marginRight = nextMarginLeft;
				marginLeft = nextMarginRight;
			}
			else
			{
				marginLeft = nextMarginLeft;
				marginRight = nextMarginRight;
			}

			if ( marginMirroringTopBottom && ( getPageNumber() & 1 ) == 0 )
			{
				marginTop = nextMarginBottom;
				marginBottom = nextMarginTop;
			}
			else
			{
				marginTop = nextMarginTop;
				marginBottom = nextMarginBottom;
			}
		}


		internal function addCreationDate(): Boolean
		{
			return add( new Meta( Element.CREATIONDATE, PdfInfo.getCreationDate() ) );
		}

		internal function addProducer(): Boolean
		{
			return add( new Meta( Element.PRODUCER, PdfWriter.VERSION ) );
		}

		internal function addWriter( w: PdfWriter ): void
		{
			if ( _writer == null )
			{
				_writer = w;
				annotationsImp = new PdfAnnotationsImp( _writer );
			}
		}

		internal function calculateOutlineCount(): void
		{
			if ( rootOutline.kids.length == 0 )
				return;
			traverseOutlineCount( rootOutline );
		}

		internal function outlineTree( outline: PdfOutline ): void
		{
			outline.indirectReference = writer.getPdfIndirectReference();

			if ( outline.parent != null )
				outline.put( PdfName.PARENT, outline.parent.indirectReference );
			var kids: Vector.<Object> = Vector.<Object>( outline.kids );
			var k: int;
			var size: int = kids.length;

			for ( k = 0; k < size; ++k )
				outlineTree( PdfOutline( kids[ k ] ) );

			for ( k = 0; k < size; ++k )
			{
				if ( k > 0 )
					PdfOutline( kids[ k ] ).put( PdfName.PREV, PdfOutline( kids[ k - 1 ] ).indirectReference );

				if ( k < size - 1 )
					PdfOutline( kids[ k ] ).put( PdfName.NEXT, PdfOutline( kids[ k + 1 ] ).indirectReference );
			}

			if ( size > 0 )
			{
				outline.put( PdfName.FIRST, PdfOutline( kids[ 0 ] ).indirectReference );
				outline.put( PdfName.LAST, PdfOutline( kids[ size - 1 ] ).indirectReference );
			}

			for ( k = 0; k < size; ++k )
			{
				var kid: PdfOutline = PdfOutline( kids[ k ] );
				writer.pdf_core::addToBody1( kid, kid.indirectReference );
			}
		}

		internal function traverseOutlineCount( outline: PdfOutline ): void
		{
			var kids: Vector.<PdfOutline> = outline.kids;
			var parent: PdfOutline = outline.parent;

			if ( kids.length == 0 )
			{
				if ( parent != null )
					parent.count = parent.count + 1;
			}
			else
			{
				for ( var k: int = 0; k < kids.length; ++k )
					traverseOutlineCount( PdfOutline( kids[ k ] ) );

				if ( parent != null )
				{
					if ( outline.isOpen() )
					{
						parent.count = outline.count + parent.count + 1;
					}
					else
					{
						parent.count = parent.count + 1;
						outline.count = -outline.count;
					}
				}
			}
		}

		/**
		 * Writes a text line to the document. It takes care of all the attributes.
		 * @throws DocumentError
		 * @throws Error
		 */
		internal function writeLineToContent( line: PdfLine, text: PdfContentByte, graphics: PdfContentByte, currentValues: Vector.<Object>
			, ratio: Number ): void
		{
			var currentFont: PdfFont = PdfFont( currentValues[ 0 ] );
			var lastBaseFactor: Number = Number( currentValues[ 1 ] );
			var chunk: PdfChunk;
			var numberOfSpaces: int;
			var lineLen: int;
			var isJustified: Boolean;
			var hangingCorrection: Number = 0;
			var hScale: Number = 1;
			var lastHScale: Number = Number.NaN;
			var baseWordSpacing: Number = 0;
			var baseCharacterSpacing: Number = 0;
			var glueWidth: Number = 0;

			numberOfSpaces = line.numberOfSpaces
			lineLen = line.lengthUtf32;
			isJustified = line.hasToBeJustified() && ( numberOfSpaces != 0 || lineLen > 1 );
			var separatorCount: int = line.separatorCount;

			if ( separatorCount > 0 )
			{
				glueWidth = line.widthLeft / separatorCount;
			}
			else if ( isJustified )
			{
				throw new NonImplementatioError( "line justification not et implemented" );
			}

			var lastChunkStroke: int = line.lastStrokeChunk;
			var chunkStrokeIdx: int = 0;
			var xMarker: Number = text.xTLM;
			var baseXMarker: Number = xMarker;
			var yMarker: Number = text.yTLM;
			var adjustMatrix: Boolean = false;
			var tabPosition: Number = 0;
			var subtract: Number;
			var obj: Vector.<Object>;

			var k: int;

			for ( var j: Iterator = line.iterator(); j.hasNext();  )
			{
				chunk = PdfChunk( j.next() );
				var color: RGBColor = chunk.color;
				hScale = 1;

				if ( chunkStrokeIdx <= lastChunkStroke )
				{
					var width: Number = 0;
					if( isJustified )
					{
						throw new NonImplementatioError();
					} else
					{
						width = chunk.width;
					}
					
					if( chunk.isStroked() )
					{
						var nextChunk: PdfChunk = line.getChunk( chunkStrokeIdx + 1);
						if( chunk.isSeparator() )
						{
							throw new NonImplementatioError();						
						}
						
						if( chunk.isTab() )
						{
							throw new NonImplementatioError();
						}
						
						if( chunk.isAttribute( Chunk.BACKGROUND ) )
						{
							subtract = lastBaseFactor;
							if (nextChunk != null && nextChunk.isAttribute(Chunk.BACKGROUND))
								subtract = 0;
							if (nextChunk == null)
								subtract += hangingCorrection;
							var fontSize: Number = chunk.font.size;
							var ascender: Number = chunk.font.font.getFontDescriptor( BaseFont.ASCENT, fontSize);
							var descender: Number = chunk.font.font.getFontDescriptor( BaseFont.DESCENT, fontSize);
							var bgr: Vector.<Object> = Vector.<Object>( chunk.getAttribute(Chunk.BACKGROUND) );
							graphics.setFillColor( bgr[0] as RGBColor );
							var extra: Vector.<Number> = Vector.<Number>(bgr[1]);
							graphics.rectangle( xMarker - extra[0],
								yMarker + descender - extra[1] + chunk.getTextRise(),
								width - subtract + extra[0] + extra[2],
								ascender - descender + extra[1] + extra[3]);
							graphics.fill();
							graphics.setGrayFill(0);
						}
						
						if( chunk.isAttribute( Chunk.UNDERLINE ) )
						{
							subtract = lastBaseFactor;
							if( nextChunk != null && nextChunk.isAttribute(Chunk.UNDERLINE))
								subtract = 0;
							if (nextChunk == null)
								subtract += hangingCorrection;
							var unders: Vector.<Vector.<Object>> = Vector.<Vector.<Object>>( chunk.getAttribute(Chunk.UNDERLINE) );
							var scolor: RGBColor = null;
							for( k = 0; k < unders.length; ++k )
							{
								obj = unders[k];
								scolor = RGBColor(obj[0]);
								var ps: Vector.<Number> = Vector.<Number>(obj[1]);
								if (scolor == null)
									scolor = color;
								if (scolor != null)
									graphics.setStrokeColor( scolor );
								var fsize: Number = chunk.font.size;
								graphics.setLineWidth( ps[0] + fsize * ps[1] );
								var shift: Number = ps[2] + fsize * ps[3];
								var cap2: int = ps[4];
								if (cap2 != 0)
									graphics.setLineCap( cap2 );
								graphics.moveTo( xMarker, yMarker + shift );
								graphics.lineTo( xMarker + width - subtract, yMarker + shift );
								graphics.stroke();
								if (scolor != null)
									graphics.resetStroke();
								if (cap2 != 0)
									graphics.setLineCap( 0 );
							}
							graphics.setLineWidth(1);
						}
						
						if( chunk.isAttribute( Chunk.ACTION ) )
						{
							subtract = lastBaseFactor;
							if( nextChunk != null && nextChunk.isAttribute( Chunk.ACTION ) )
								subtract = 0;
							if( nextChunk == null )
								subtract += hangingCorrection;
							text.addAnnotation( PdfAnnotation.createAction( writer, xMarker, yMarker, xMarker + width - subtract, yMarker + chunk.font.size, PdfAction(chunk.getAttribute( Chunk.ACTION )) ) );
						}
						
						if( chunk.isAttribute( Chunk.REMOTEGOTO ) )
						{
							throw new NonImplementatioError();
						}
						
						if( chunk.isAttribute( Chunk.LOCALGOTO ) )
						{
							throw new NonImplementatioError();
						}
						
						if( chunk.isAttribute( Chunk.LOCALDESTINATION ) )
						{
							throw new NonImplementatioError();
						}
						
						if( chunk.isAttribute( Chunk.GENERICTAG ) )
						{
							throw new NonImplementatioError();
						}
						
						if( chunk.isAttribute( Chunk.PDFANNOTATION ) )
						{
							throw new NonImplementatioError();
						}
						
						var params: Vector.<Number> = chunk.getAttribute( Chunk.SKEW ) as Vector.<Number>;
						var hs: Number;
						var _hs: Object =  chunk.getAttribute(Chunk.HSCALE);
						
						if( _hs != null ) hs = Number( _hs );
						
						if( params != null || !isNaN(hs) )
						{
							var b: Number = 0, c: Number = 0;
							if (params != null)
							{
								b = params[0];
								c = params[1];
							}
							
							if( !isNaN(hs))
								hScale = Number(hs);
							text.setTextMatrix( hScale, b, c, 1, xMarker, yMarker );
						}
						
						if( chunk.isAttribute(Chunk.CHAR_SPACING) )
						{
							var cs: Number = Number( chunk.getAttribute(Chunk.CHAR_SPACING) );
							text.setCharacterSpacing(cs);
						}
						
						if( chunk.isImage() )
						{
							throw new NonImplementatioError();
						}
					}
					
					xMarker += width;
					++chunkStrokeIdx;
				}

				if ( chunk.font.compareTo( currentFont ) != 0 )
				{
					currentFont = chunk.font;
					text.setFontAndSize( currentFont.font, currentFont.size );
				}

				var rise: Number = 0;
				var textRender: Vector.<Object> = chunk.getAttribute( Chunk.TEXTRENDERMODE ) as Vector.<Object>;
				var tr: int = 0;
				var strokeWidth: Number = 1;
				var strokeColor: RGBColor = null;
				var fr: Object = ( chunk.getAttribute( Chunk.SUBSUPSCRIPT ) );

				if ( textRender != null )
				{
					throw new NonImplementatioError( "textrenderer not yet supported" );
				}

				if ( fr != null )
					rise = Number( fr );

				if ( color != null )
					text.setFillColor( color );

				if ( rise != 0 )
					text.setTextRise( rise );

				if ( chunk.isImage() )
					adjustMatrix = true;
				else if ( chunk.isHorizontalSeparator() )
				{
					throw new NonImplementatioError();
				}
				else if ( chunk.isTab() )
				{
					throw new NonImplementatioError();
				}
				else if ( isJustified && numberOfSpaces > 0 && chunk.isSpecialEncoding() )
				{
					throw new NonImplementatioError();
				}
				else
				{
					if ( isJustified && hScale != lastHScale )
					{
						lastHScale = hScale;
						text.setWordSpacing( baseWordSpacing / hScale );
						text.setCharacterSpacing( baseCharacterSpacing / hScale + text.getCharacterSpacing() );
					}
					text.showText( chunk.toString() );
				}

				if ( rise != 0 )
					text.setTextRise( 0 );

				if ( color != null )
					text.resetFill();

				if ( tr != PdfContentByte.TEXT_RENDER_MODE_FILL )
					text.setTextRenderingMode( PdfContentByte.TEXT_RENDER_MODE_FILL );

				if ( strokeColor != null )
					text.resetStroke();

				if ( strokeWidth != 1 )
					text.setLineWidth( 1 );

				if ( chunk.isAttribute( Chunk.SKEW ) || chunk.isAttribute( Chunk.HSCALE ) )
				{
					adjustMatrix = true;
					text.setTextMatrix( xMarker, yMarker );
				}

				if ( chunk.isAttribute( Chunk.CHAR_SPACING ) )
				{
					text.setCharacterSpacing( baseCharacterSpacing );
				}
			}

			if ( isJustified )
			{
				text.setWordSpacing( 0 );
				text.setCharacterSpacing( 0 );

				if ( line.isNewlineSplit() )
					lastBaseFactor = 0;
			}

			if ( adjustMatrix )
				text.moveText( baseXMarker - text.xTLM, 0 );
			currentValues[ 0 ] = currentFont;
			currentValues[ 1 ] = lastBaseFactor;
		}

		internal function writeOutlines(): void
		{
			if ( rootOutline.kids.length == 0 )
				return;

			outlineTree( rootOutline );
			writer.pdf_core::addToBody1( rootOutline, rootOutline.indirectReference );
		}

		private function addImage( image: ImageElement ): void
		{
			if ( image.hasAbsoluteY )
			{
				graphics.addImage( image );
				pageEmpty = false;
				return;
			}

			if ( currentHeight != 0 && indentTop - currentHeight - image.scaledHeight < indentBottom )
			{
				if ( !strictImageSequence && imageWait == null )
				{
					imageWait = image;
					return;
				}
				newPage();

				if ( currentHeight != 0 && indentTop - currentHeight - image.scaledHeight < indentBottom )
				{
					imageWait = image;
					return;
				}
			}
			pageEmpty = false;

			if ( image == imageWait )
				imageWait = null;
			var textwrap: Boolean = ( image.alignment & ImageElement.TEXTWRAP ) == ImageElement.TEXTWRAP && !( ( image.alignment & ImageElement
				.MIDDLE ) == ImageElement.MIDDLE );
			var underlying: Boolean = ( image.alignment & ImageElement.UNDERLYING ) == ImageElement.UNDERLYING;
			var diff: Number = leading / 2;

			if ( textwrap )
				diff += leading;
			var lowerleft: Number = indentTop - currentHeight - image.scaledHeight - diff;
			var mt: Vector.<Number> = image.matrix;
			var startPosition: Number = indentLeft - mt[ 4 ];

			if ( ( image.alignment & ImageElement.RIGHT ) == ImageElement.RIGHT )
				startPosition = indentRight - image.scaledWidth - mt[ 4 ];

			if ( ( image.alignment & ImageElement.MIDDLE ) == ImageElement.MIDDLE )
				startPosition = indentLeft + ( ( indentRight - indentLeft - image.scaledWidth ) / 2 ) - mt[ 4 ];

			if ( image.hasAbsoluteX )
				startPosition = image.absoluteX;

			if ( textwrap )
			{
				if ( imageEnd < 0 || imageEnd < currentHeight + image.scaledHeight + diff )
					imageEnd = currentHeight + image.scaledHeight + diff;

				if ( ( image.alignment & ImageElement.RIGHT ) == ImageElement.RIGHT )
					indentation.imageIndentRight += image.scaledWidth + image.indentationLeft;
				else
					indentation.imageIndentLeft += image.scaledWidth + image.indentationRight;
			}
			else
			{
				if ( ( image.alignment & ImageElement.RIGHT ) == ImageElement.RIGHT )
					startPosition -= image.indentationRight;
				else if ( ( image.alignment & ImageElement.MIDDLE ) == ImageElement.MIDDLE )
					startPosition += image.indentationLeft - image.indentationRight;
				else
					startPosition += image.indentationLeft;
			}
			graphics.addImage3( image, mt[ 0 ], mt[ 1 ], mt[ 2 ], mt[ 3 ], startPosition, lowerleft - mt[ 5 ] );

			if ( !( textwrap || underlying ) )
			{
				currentHeight += image.scaledHeight + diff;
				flushLines();
				text.moveText( 0, -( image.scaledHeight + diff ) );
				newLine();
			}
		}

		private function addViewerPreference( key: PdfName, value: PdfObject ): void
		{
			viewerPreferences.addViewerPreference( key, value );
		}
		
		// -------------
		// Helper methods for the main method add
		// -------------
		
		
		// Element.ANCHOR
		private function _addAnchor( anchor: Anchor ): void
		{
			leadingCount++;
			var url: String = anchor.reference;
			leading = anchor.leading;
			if( url != null )
				anchorAction = new PdfAction( url );
			anchor.process( this );
			anchorAction = null;
			leadingCount--;
		}
		
		
		private function _addSection( section: Section ): void
		{
			var hasTitle: Boolean = section.notAddedYet && section.title != null;
			
			if( section.triggerNewPage )
				newPage();
			
			if( hasTitle )
			{
				var fith: Number = indentTop - currentHeight;
				var rotation: int = pageSize.rotation;
				if( rotation == 90 || rotation == 180 )
					fith = pageSize.height - fith;
				
				var destination: PdfDestination = PdfDestination.create( PdfDestination.FITH, fith );
				while( currentOutline.level >= section.depth )
					currentOutline = currentOutline.parent;
				
				var outline: PdfOutline = PdfOutline.create( currentOutline, destination, section.getBookmarkTitle(), section.bookmarkOpen );
				currentOutline = outline;
			}
			
			carriageReturn();
			indentation.sectionIndentLeft += section.indentationLeft;
			indentation.sectionIndentRight += section.indentationRight;
			
			if( section.notAddedYet )
				if( section.type == Element.CHAPTER )
					trace('onChapter. to be added');
					//pageEvent.onChapter( writer, this, indentTop() - currentHeight, section.getTitle());
				else
					trace('onSection. to be added');
					//pageEvent.onSection( writer, this, indentTop() - currentHeight, section.getDepth(), section.getTitle());
			
			if( hasTitle )
			{
				isSectionTitle = true;
				add( section.title );
				isSectionTitle = false;
			}
			
			indentation.sectionIndentLeft += section.indentation;
			section.process( this );
			flushLines();
			
			
			indentation.sectionIndentLeft -= (section.indentationLeft + section.indentation);
			indentation.sectionIndentRight -= section.indentationRight;
			
			if( section.isComplete )
				if( section.type == Element.CHAPTER )
					trace('onChapterEnd. to be added');
					//pageEvent.onChapterEnd(writer, this, indentTop() - currentHeight);
				else
					trace('onSectionEnd. to be added');
					//pageEvent.onSectionEnd(writer, this, indentTop() - currentHeight);
				
		}
		
	}
}