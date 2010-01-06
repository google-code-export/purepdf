package org.purepdf.pdf
{
	import flash.events.EventDispatcher;
	import org.purepdf.elements.Element;
	import org.purepdf.elements.ILargeElement;
	import org.purepdf.elements.Meta;
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.elements.images.ImageElement;
	import org.purepdf.errors.NonImplementatioError;
	import org.purepdf.errors.RuntimeError;
	import org.purepdf.events.PageEvent;
	import org.purepdf.utils.collections.HashMap;

	public class PdfDocument extends EventDispatcher
	{
		internal static var compress: Boolean = false;
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
		protected var pageResources: PageResources;
		protected var pageSize: RectangleElement;
		protected var rootOutline: PdfOutline;
		protected var strictImageSequence: Boolean = false;
		protected var text: PdfContentByte;
		protected var textEmptySize: int;
		protected var thisBoxSize: HashMap = new HashMap();
		protected var viewerPreferences: PdfViewerPreferencesImp = new PdfViewerPreferencesImp();
		protected var writer: PdfWriter;

		public function PdfDocument( size: RectangleElement )
		{
			pageSize = size;
			super();
			addProducer();
			addCreationDate();
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
			//if( element is ChapterAutoNumber )
			//	chapternumber = ( element as ChapterAutoNumber ).setAutomaticNumber( chapternumber );
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
			return pageSize.getBottom( marginBottom + margin );
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
			//writer.addLocalDestinations( localDestinations );
			//calculateOutlineCount();
			//writeOutlines();
			writer.close();
		}

		public function getCatalog( pages: PdfIndirectReference ): PdfCatalog
		{
			trace( 'getCatalog. to be implemented' );
			var catalog: PdfCatalog = new PdfCatalog( pages, writer );
			// version
			writer.getPdfVersion().addToCatalog( catalog );
			// preferences
			viewerPreferences.addToCatalog( catalog );
			return catalog;
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

		public function getPageResources(): PageResources
		{
			return pageResources;
		}

		public function getPageSize(): RectangleElement
		{
			return pageSize;
		}

		// REMOVE!
		[Deprecated]
		public function getWriter(): PdfWriter
		{
			return writer;
		}

		public function isOpen(): Boolean
		{
			return opened;
		}

		public function isPageEmpty(): Boolean
		{
			return writer == null || ( writer.getDirectContent().size() == 0 && writer.getDirectContentUnder().size() == 0 && ( pageEmpty || writer.isPaused() ) );
		}

		public function left( margin: Number=0 ): Number
		{
			return pageSize.getLeft( marginLeft + margin );
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
			//flushLines();
			var rotation: int = pageSize.getRotation();
			var resources: PdfDictionary = pageResources.getResources();
			var page: PdfPage = new PdfPage( PdfRectangle.create( pageSize, rotation ), thisBoxSize, resources, rotation );
			page.put( PdfName.TABS, writer.getTabs() );

			if ( annotationsImp.hasUnusedAnnotations() )
			{
				var array: PdfArray = annotationsImp.rotateAnnotations( writer, pageSize );

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
			writer.add( page, new PdfContents( writer.getDirectContentUnder(), graphics, text, writer.getDirectContent(), pageSize ) );
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
				setPageSize( pageSize );
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

		public function right( margin: Number=0 ): Number
		{
			return pageSize.getRight( marginRight + margin );
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

		public function setPageSize( value: RectangleElement ): Boolean
		{
			if ( writer != null && writer.isPaused() )
			{
				return false;
			}
			nextPageSize = RectangleElement.clone( value );
			return true;
		}

		public function setViewerPreferences( preferences: int ): void
		{
			viewerPreferences.setViewerPreferences( preferences );
		}

		public function top( margin: Number=0 ): Number
		{
			return pageSize.getTop( marginTop + margin );
		}

		protected function carriageReturn(): void
		{
			trace( 'carriageReturn. to be implemented' );
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
			pageResources = new PageResources();
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

			if ( pageSize.getBackgroundColor() != null || pageSize.hasBorders() || pageSize.getBorderColor() != null )
			{
				add( pageSize );
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
		 * @throws DocumentException on error
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
			pageSize = nextPageSize;

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

		internal function getBoxSize( boxName: String ): RectangleElement
		{
			var r: PdfRectangle = thisBoxSize.getValue( boxName ) as PdfRectangle;

			if ( r != null )
				return r.getRectangle();
			return null;
		}

		private function addImage( image: ImageElement ): void
		{
			if ( image.hasAbsoluteY )
			{
				graphics.addImage( image );
				pageEmpty = false;
				return;
			}

			if ( currentHeight != 0 && indentTop - currentHeight - image.getScaledHeight() < indentBottom )
			{
				if ( !strictImageSequence && imageWait == null )
				{
					imageWait = image;
					return;
				}
				newPage();

				if ( currentHeight != 0 && indentTop - currentHeight - image.getScaledHeight() < indentBottom )
				{
					imageWait = image;
					return;
				}
			}
			pageEmpty = false;

			if ( image == imageWait )
				imageWait = null;
			var textwrap: Boolean = ( image.alignment & ImageElement.TEXTWRAP ) == ImageElement.TEXTWRAP && !( ( image.alignment & ImageElement.MIDDLE ) == ImageElement.MIDDLE );
			var underlying: Boolean = ( image.alignment & ImageElement.UNDERLYING ) == ImageElement.UNDERLYING;
			var diff: Number = leading / 2;

			if ( textwrap )
				diff += leading;
			var lowerleft: Number = indentTop - currentHeight - image.getScaledHeight() - diff;
			var mt: Vector.<Number> = image.matrix;
			var startPosition: Number = indentLeft - mt[ 4 ];

			if ( ( image.alignment & ImageElement.RIGHT ) == ImageElement.RIGHT )
				startPosition = indentRight - image.getScaledWidth() - mt[ 4 ];

			if ( ( image.alignment & ImageElement.MIDDLE ) == ImageElement.MIDDLE )
				startPosition = indentLeft + ( ( indentRight - indentLeft - image.getScaledWidth() ) / 2 ) - mt[ 4 ];

			if ( image.hasAbsoluteX )
				startPosition = image.absoluteX;

			if ( textwrap )
			{
				if ( imageEnd < 0 || imageEnd < currentHeight + image.getScaledHeight() + diff )
					imageEnd = currentHeight + image.getScaledHeight() + diff;

				if ( ( image.alignment & ImageElement.RIGHT ) == ImageElement.RIGHT )
					indentation.imageIndentRight += image.getScaledWidth() + image.indentationLeft;
				else
					indentation.imageIndentLeft += image.getScaledWidth() + image.indentationRight;
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
				currentHeight += image.getScaledHeight() + diff;
				flushLines();
				text.moveText( 0, -( image.getScaledHeight() + diff ) );
				newLine();
			}
		}

		private function addViewerPreference( key: PdfName, value: PdfObject ): void
		{
			viewerPreferences.addViewerPreference( key, value );
		}
	}
}