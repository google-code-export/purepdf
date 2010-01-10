package org.purepdf.pdf
{
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import it.sephiroth.utils.HashMap;
	import it.sephiroth.utils.IObject;
	import it.sephiroth.utils.hashLib;
	
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.purepdf.elements.Element;
	import org.purepdf.elements.ILargeElement;
	import org.purepdf.elements.Meta;
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.elements.images.ImageElement;
	import org.purepdf.errors.NonImplementatioError;
	import org.purepdf.errors.RuntimeError;
	import org.purepdf.events.PageEvent;

	[Event(name="closeDocument",type="org.purepdf.events.PageEvent")]
	[Event(name="endPage",		type="org.purepdf.events.PageEvent")]
	[Event(name="startPage", 	type="org.purepdf.events.PageEvent")]
	[Event(name="openDocument", type="org.purepdf.events.PageEvent")]
	
	public class PdfDocument extends EventDispatcher implements IObject
	{
		internal static var compress: Boolean = false;

		private static var logger: ILogger = LoggerFactory.getClassLogger( PdfDocument );
		protected var _hashCode: int;
		protected var _pageResources: PageResources;
		protected var _pageSize: RectangleElement;
		protected var alignment: int = Element.ALIGN_LEFT;
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
		protected var lastElementType: int = -1;
		protected var leading: Number = 0;
		protected var line: PdfLine = null;
		protected var lines: Vector.<PdfLine> = new Vector.<PdfLine>();
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
		protected var writer: PdfWriter;
		protected var _duration: int = -1;
		protected var _transition: PdfTransition = null;

		public function PdfDocument( size: RectangleElement )
		{
			_pageSize = size;
			super();
			addProducer();
			addCreationDate();
		}
		
		/**
		 * Sets the display duration for the page (for presentations)
		 * @param seconds   the number of seconds to display the page
		 */
		public function set duration( seconds: int ): void
		{
			if( seconds > 0 )
				_duration = seconds;
			else
				_duration = -1;
		}
		
		/**
		 * Set the transition for the page
		 */
		public function set transition( value: PdfTransition ): void
		{
			_transition = value;
		}

		public function addAnnotation( annot: PdfAnnotation ): void
		{
			pageEmpty = false;

			if ( annot.getWriter() == null )
				annot.setWriter( writer );
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

		public function addElement( element: Element ): Boolean
		{
			if ( closed )
				throw new Error( "document is closed" );

			if ( !opened && element.iscontent )
				throw new Error( "document is not opened" );
			var success: Boolean = false;
			success = add( element );

			if ( element is ILargeElement )
			{
				var e: ILargeElement = ( element as ILargeElement );

				if ( !e.iscomplete )
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
		 * close the document
		 *
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

			if ( !closed )
			{
				opened = false;
				closed = true;
			}
			writer.close();
		}

		public function getCatalog( pages: PdfIndirectReference ): PdfCatalog
		{
			logger.warn( 'getCatalog. to be implemented' );
			var catalog: PdfCatalog = new PdfCatalog( pages, writer );

			// version
			writer.getPdfVersion().addToCatalog( catalog );

			// preferences
			viewerPreferences.addToCatalog( catalog );

			return catalog;
		}

		public function getDefaultColorSpace(): PdfDictionary
		{
			return writer.getDefaultColorSpace();
		}

		public function getDirectContent(): PdfContentByte
		{
			return writer.getDirectContent();
		}

		public function getInfo(): PdfInfo
		{
			return info;
		}

		public function getPageNumber(): int
		{
			return pageN;
		}

		public function getWriter(): PdfWriter
		{
			return writer;
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
			return writer == null || ( writer.getDirectContent().size() == 0 && writer.getDirectContentUnder().size() == 0 && ( pageEmpty
				|| writer.isPaused() ) );
		}

		public function left( margin: Number=0 ): Number
		{
			return _pageSize.getLeft( marginLeft + margin );
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
			var rotation: int = _pageSize.getRotation();
			
			// 2
			var resources: PdfDictionary = _pageResources.getResources();
			
			// 3
			var page: PdfPage = new PdfPage( PdfRectangle.create( _pageSize, rotation ), thisBoxSize, resources, rotation );
			page.put( PdfName.TABS, writer.getTabs() );

			// 4
			if( _transition != null )
			{
				page.put( PdfName.TRANS, _transition.getTransitionDictionary() );
				_transition = null;
			}
			
			if( _duration > 0 )
			{
				page.put( PdfName.DUR, new PdfNumber( _duration ) );
				_duration = 0;
			}
			
			if ( annotationsImp.hasUnusedAnnotations() )
			{
				var array: PdfArray = annotationsImp.rotateAnnotations( writer, _pageSize );

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
			writer.add( page, new PdfContents( writer.getDirectContentUnder(), graphics, text, writer.getDirectContent(), _pageSize ) );
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
				writer.open();
				rootOutline = new PdfOutline( writer );
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
			if ( writer != null && writer.isPaused() )
				return;

			nextPageSize = RectangleElement.clone( value );
		}

		public function right( margin: Number=0 ): Number
		{
			return _pageSize.getRight( marginRight + margin );
		}

		public function setDefaultColorSpace( key: PdfName, value: PdfObject ): void
		{
			writer.setDefaultColorSpace( key, value );
		}

		public function setMargins( marginLeft: Number, marginRight: Number, marginTop: Number, marginBottom: Number ): Boolean
		{
			if ( writer != null && writer.isPaused() )
			{
				return false;
			}
			nextMarginLeft = marginLeft;
			nextMarginRight = marginRight;
			nextMarginTop = marginTop;
			nextMarginBottom = marginBottom;
			return true;
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

		protected function carriageReturn(): void
		{
			logger.warn( 'carriageReturn. to be implemented' );
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
			{
				return 0;
			}
			throw new NonImplementatioError();
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
			writer.resetContent();
			graphics = new PdfContentByte( writer );
			text = new PdfContentByte( writer );
			text.reset();
			text.beginText();
			textEmptySize = text.size();
			markPoint = 0;
			setNewPageSizeAndMargins();
			imageEnd = -1;
			currentHeight = 0;
			thisBoxSize = new HashMap();

			if ( _pageSize.getBackgroundColor() != null || _pageSize.hasBorders() || _pageSize.getBorderColor() != null )
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
				throw e;
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

		internal function add( element: Element ): Boolean
		{
			if ( writer != null && writer.isPaused() )
			{
				return false;
			}

			switch ( element.type() )
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
				default:
					throw new Error( 'PdfDocument.add. Invalid type: ' + element.type() );
					return false;
			}
			lastElementType = element.type();
			return true;
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
			if ( writer == null )
			{
				writer = w;
				annotationsImp = new PdfAnnotationsImp( writer );
			}
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
	}
}