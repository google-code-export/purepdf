package org.purepdf.pdf
{
	import flash.utils.ByteArray;
	
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.elements.images.ImageElement;
	import org.purepdf.errors.NonImplementatioError;
	import org.purepdf.utils.Bytes;
	import org.purepdf.utils.assertTrue;
	import org.purepdf.utils.collections.HashMap;
	import org.purepdf.utils.iterators.Iterator;
	import org.purepdf.utils.iterators.VectorIterator;

	public class PdfWriter
	{
		public static const NAME: String = 'purepdf'; 
		public static const RELEASE: String = '0.0.1_ALPHA';
		public static const VERSION: String = NAME + ' ' + RELEASE;
		
		public static const VERSION_1_4: String = '4';
		public static const PDF_VERSION_1_4: PdfName = new PdfName("1.4");
		public static const GENERATION_MAX: int = 65535;
		
		public static const PageLayoutSinglePage: int = 1;
		public static const PageLayoutOneColumn: int = 2;
		public static const PageLayoutTwoColumnLeft: int = 4;
		public static const PageLayoutTwoColumnRight: int = 8;
		public static const PageLayoutTwoPageLeft: int = 16;
		public static const PageLayoutTwoPageRight: int = 32;
		public static const PageModeUseNone: int = 64;
		public static const PageModeUseOutlines: int = 128;
		public static const PageModeUseThumbs: int = 256;
		public static const PageModeFullScreen: int = 512;
		public static const PageModeUseOC: int = 1024;
		public static const PageModeUseAttachments: int = 2048;
		
		public static const HideToolbar: int = 1 << 12;
		public static const HideMenubar: int = 1 << 13;
		public static const HideWindowUI: int = 1 << 14;
		public static const FitWindow: int = 1 << 15;
		public static const CenterWindow: int = 1 << 16;
		public static const DisplayDocTitle: int = 1 << 17;
		public static const NonFullScreenPageModeUseNone: int = 1 << 18;
		public static const NonFullScreenPageModeUseOutlines: int = 1 << 19;
		public static const NonFullScreenPageModeUseThumbs: int = 1 << 20;
		public static const NonFullScreenPageModeUseOC: int = 1 << 21;
		public static const DirectionL2R: int = 1 << 22;
		public static const DirectionR2L: int = 1 << 23;
		public static const PrintScalingNone: int = 1 << 24;
		
		protected var os: OutputStreamCounter;
		protected var pdf: PdfDocument;
		protected var paused: Boolean = false;
		protected var opened: Boolean = false;
		protected var directContent: PdfContentByte;
		protected var directContentUnder: PdfContentByte;
		protected var pdf_version: PdfVersion = new PdfVersion();
		protected var defaultPageSize: PageSize;
		protected var defaultColorspace: PdfDictionary = new PdfDictionary();
		protected var tabs: PdfName = null;
		protected var crypto: PdfEncryption;
		protected var currentPageNumber: int = 1;
		protected var root: PdfPages;
		protected var group: PdfDictionary;
		protected var body: PdfBody;
		protected var compressionLevel: int = PdfStream.NO_COMPRESSION;
		protected var rgbTransparencyBlending: Boolean;
		protected var fullCompression: Boolean = false;
		protected var extraCatalog: PdfDictionary;
		protected var pageReferences: Vector.<PdfIndirectReference> = new Vector.<PdfIndirectReference>();
		protected var prevxref: int = 0;
		protected var xmpMetadata: Bytes = null;
		protected var images: HashMap = new HashMap();
		protected var imageDictionary: PdfDictionary = new PdfDictionary();
		protected var documentExtGState: HashMap = new HashMap();
		
		private var logger: ILogger = LoggerFactory.getClassLogger( PdfWriter );
		
		public function PdfWriter( instance: SingletonCheck, output: ByteArray, pagesize: RectangleElement )
		{
			assertTrue( instance != null && instance is SingletonCheck, "Use PdfWriter.create to initialize a new instance of purepdf");
			
			os = new OutputStreamCounter( output );
			
			pdf = new PdfDocument( pagesize );
			pdf.addWriter( this );
			root = new PdfPages( this );
			
			directContent = new PdfContentByte( this );
			directContentUnder = new PdfContentByte( this );
		}
		
		public static function create( output: ByteArray, pagesize: RectangleElement ): PdfDocument
		{
			var writer: PdfWriter = new PdfWriter( new SingletonCheck(), output, pagesize );
			return writer.pdfDocument;
		}
		
		public function addSimpleExtGState( gstate: PdfDictionary ): Vector.<PdfObject>
		{
			if( !documentExtGState.containsKey( gstate ) )
			{
				var obj: Vector.<PdfObject> = Vector.<PdfObject>([ new PdfName("Pr" + (documentExtGState.size() + 1)), getPdfIndirectReference() ]);
				documentExtGState.put( gstate, obj );
			}
			return documentExtGState.getValue( gstate );
		}
		
		public function close(): void
		{
			if( opened )
			{
				if( (currentPageNumber - 1 ) != pageReferences.length )
					throw new Error("The page " + pageReferences.length + " was requested, but the document has only " + ( currentPageNumber - 1 ) + " pages");
				pdf.close();
				
				addSharedObjectsToBody();
				var rootRef: PdfIndirectReference = root.writePageTree();
				
				var catalog: PdfDictionary = getCatalog( rootRef );
				
				if( xmpMetadata != null )
				{
					trace('implement this');
				}
				
				/*
				if( isPdfX() )
				{
					pdfConformance.completeInfoDictionary( getInfo() );
					pdfConformance.completeExtraCatalog( getExtraCatalog() );
				}
				*/
				
				if( extraCatalog != null )
					catalog.mergeDifferent( extraCatalog );
				
				writeOutlines( catalog, false );
				var indirectCatalog: PdfIndirectObject = addToBody2( catalog, false );
				var infoObj: PdfIndirectObject = addToBody2( getInfo(), false );
				
				// encryption
				var encryption: PdfIndirectReference = null;
				var fileID: PdfObject = null;
				body.flushObjStm();
				
				if( crypto != null )
				{
					trace('implement this');
					//var encryptionObject: PdfIndirectObject = addToBody2( crypto.getEncryptionDictionary(), false );
					//encryption = encryptionObject.getIndirectReference();
					//fileID = crypto.getFileID();
				} else {
					fileID = PdfEncryption.createInfoId( PdfEncryption.createDocumentId() );
				}
				
				// write the cross-reference table of the body
				body.writeCrossReferenceTable( os, indirectCatalog.getIndirectReference(), infoObj.getIndirectReference(), encryption,  fileID, prevxref );
				
				// make the trailer
				// [F2] full compression
				if( fullCompression )
				{
					os.writeBytes( getISOBytes("startxref\n") );
					os.writeBytes( getISOBytes( body.offset().toString() ) );
					os.writeBytes( getISOBytes("\n%%EOF\n") );
				} else {
					var trailer: PdfTrailer = new PdfTrailer( body.size(), body.offset(), indirectCatalog.getIndirectReference(), infoObj.getIndirectReference(), encryption, fileID, prevxref);
					trailer.toPdf( this, os );
				}
				
				//super.close();
			}
		}
		
		/*
		* The Catalog is also called the root object of the document.
		* Whereas the Cross-Reference maps the objects number with the
		* byte offset so that the viewer can find the objects, the
		* Catalog tells the viewer the numbers of the objects needed
		* to render the document.
		*/
		protected function getCatalog( rootObj: PdfIndirectReference ): PdfDictionary
		{
			var catalog: PdfDictionary = pdf.getCatalog( rootObj );
			
			trace('getCatalog. to be implemented');
			
			return catalog;
		}
		
		public function getPdfVersion(): PdfVersion
		{
			return pdf_version;
		}
		
		/**
		 * Use this method to get the info dictionary if you want to
		 * change it directly (add keys and values to the info dictionary).
		 * @return the info dictionary
		 */
		public function getInfo(): PdfDictionary
		{
			return pdf.getInfo();
		}
		
		public function getExtraCatalog(): PdfDictionary
		{
			if( extraCatalog == null )
				extraCatalog = new PdfDictionary();
			return extraCatalog;
		}
		
		protected function addSharedObjectsToBody(): void 
		{
			logger.warn('addSharedObjectsToBody. partially implemented');
			
			var it: Iterator;
			
			// [F3] add the fonts
			// [F4] add the form XObjects
			// [F5] add all the dependencies in the imported pages
			// [F6] add the spotcolors
			// [F7] add the pattern
			// [F8] add the shading patterns
			// [F9] add the shadings
			// [F10] add the extgstate
			
			it = new VectorIterator( documentExtGState.getKeys() );
			for (it; it.hasNext();) {
				var gstate: PdfDictionary = it.next();
				var obj: Vector.<PdfObject> = documentExtGState.getValue( gstate );
				addToBody1( gstate, PdfIndirectReference( obj[1] ) );
			}
			// [F11] add the properties
			// [F13] add the OCG layers
		}
		
		protected function writeOutlines( catalog: PdfDictionary, namedAsNames: Boolean ): void 
		{
			logger.warn('writeOutlines. to be implemented');
		}
		
		/**
		 * Use this to get an <CODE>PdfIndirectReference</CODE> for an object that
		 * will be created in the future.
		 * Use this method only if you know what you're doing!
		 * @return the <CODE>PdfIndirectReference</CODE>
		 */
		
		public function getPdfIndirectReference(): PdfIndirectReference
		{
			return body.getPdfIndirectReference();
		}
		
		/**
		 * Gets the pagenumber of this document.
		 * This number can be different from the real pagenumber,
		 * if you have (re)set the page number previously.
		 * @return a page number
		 */
		
		public function getPageNumber(): int
		{
			return pdf.getPageNumber();
		}
		
		public function getCurrentPage(): PdfIndirectReference
		{
			return getPageReference( currentPageNumber );
		}
		
		public function getCurrentPageNumber(): int
		{
			return currentPageNumber;
		}
		
		/**
		 * Use this method to get a reference to a page existing or not.
		 * If the page does not exist yet the reference will be created
		 * in advance. If on closing the document, a page number greater
		 * than the total number of pages was requested, an exception
		 * is thrown.
		 * @param page the page number. The first page is 1
		 * @return the reference to the page
		 */
		public function getPageReference( page: int ): PdfIndirectReference
		{
			--page;
			if( page < 0 )
				throw new ArgumentError("page number must be >= 1");
			
			var ref: PdfIndirectReference;
			if( page < pageReferences.length )
			{
				ref = pageReferences[ page ] as PdfIndirectReference;
				if( ref == null )
				{
					ref = body.getPdfIndirectReference();
					pageReferences[ page ] = ref;
				}
			} else
			{
				var empty: int = page - pageReferences.length;
				for( var k: int = 0; k < empty; ++k )
					pageReferences.push( null );
				
				ref = body.getPdfIndirectReference();
				pageReferences.push( ref );
			}
			return ref;
		}
		
		/**
		 * Returns the compression level used for streams written by this writer.
		 * @return the compression level (0 = best speed, 9 = best compression, -1 is default)
		 * @since 2.1.3
		 */
		public function getCompressionLevel(): int 
		{
			return compressionLevel;
		}
		
		/**
		 * Use this method to find out if 1.5 compression is on.
		 * @return the 1.5 compression status
		 */
		public function isFullCompression(): Boolean
		{
			return fullCompression;
		}
		
		public function getOs(): OutputStreamCounter
		{
			return os;
		}
		
		/**
		 * Gets the transparency blending colorspace.
		 * @return <code>true</code> if the transparency blending colorspace is RGB, <code>false</code>
		 * if it is the default blending colorspace
		 * @since 2.1.0
		 */
		public function isRgbTransparencyBlending(): Boolean
		{
			return rgbTransparencyBlending;
		}
		
		/**
		 * Sets the transparency blending colorspace to RGB. The default blending colorspace is
		 * CMYK and will result in faded colors in the screen and in printing. Calling this method
		 * will return the RGB colors to what is expected. The RGB blending will be applied to all subsequent pages
		 * until other value is set.
		 * Note that this is a generic solution that may not work in all cases.
		 * @param rgbTransparencyBlending <code>true</code> to set the transparency blending colorspace to RGB, <code>false</code>
		 * to use the default blending colorspace
		 * @since 2.1.0
		 */
		public function setRgbTransparencyBlending( value: Boolean ): void
		{
			rgbTransparencyBlending = value;
		}
		
		public function getGroup(): PdfDictionary
		{
			return group;
		}
		
		public function setGroup( value: PdfDictionary ): void
		{
			group = value;
		}
		
		public function getEncryption(): PdfEncryption
		{
			return crypto;
		}
		
		public function setEncryption( value: PdfEncryption ): void
		{
			crypto = value;
		}
		
		public function setTabs( value: PdfName ): void
		{
			tabs = value;
		}
		
		public function getTabs(): PdfName
		{
			return tabs;
		}
		
		public function getDirectContent(): PdfContentByte
		{
			if( !opened )
				throw new Error("Document is not open");
			return directContent;
		}
		
		public function getDefaultColorSpace(): PdfDictionary
		{
			return defaultColorspace;
		}
		
		public function getDirectContentUnder(): PdfContentByte
		{
			if (!opened)
				throw new Error("Document is not open");
			return directContentUnder;
		}
		
		/**
		 * Resets all the direct contents to empty.
		 * This happens when a new page is started.
		 */
		public function resetContent(): void
		{
			directContent.reset();
			directContentUnder.reset();
		}
		
		public function get pdfDocument(): PdfDocument
		{
			return pdf;
		}
		
		public function isPaused(): Boolean
		{
			return paused;
		}
		
		internal function open(): PdfDocument
		{
			if( !opened )
			{
				opened = true;
				pdf_version.writeHeader( os );
				body = new PdfBody( this );
			}
			
			return pdf;
		}
		
		
		public function isOpen(): Boolean
		{
			return opened;
		}
		
		public static function getISOBytes( text: String ): Bytes
		{
			if( text == null )
				return null;
			var len: int = text.length;
			var byte: Bytes = new Bytes();
			
			for( var k: int = 0; k < len; ++k )
				byte[k] = text.charCodeAt( k ); 
			return byte;
		}
		
		public static function getVectorISOBytes( text: String ): Vector.<int>
		{
			if( text == null )
				return null;
			var len: int = text.length;
			var byte: Vector.<int> = new Vector.<int>();
			
			for( var k: int = 0; k < len; ++k )
				byte[k] = text.charCodeAt( k ); 
			return byte;
		}
		
		/**
		 * Use this method to add a PDF object to the PDF body.
		 * Use this method only if you know what you're doing!
		 * @param object
		 * @return a PdfIndirectObject
		 * @throws IOException
		 */
		public function addToBody( object: PdfObject ): PdfIndirectObject
		{
			var iobj: PdfIndirectObject = body.add1( object );
			return iobj;
		}
		
		/**
		 * Use this method to add a PDF object to the PDF body.
		 * Use this method only if you know what you're doing!
		 * @param object
		 * @param ref
		 * @return a PdfIndirectObject
		 * @throws IOException
		 */
		public function addToBody1( object: PdfObject, ref: PdfIndirectReference ): PdfIndirectObject
		{
			var iobj: PdfIndirectObject = body.add3( object, ref );
			return iobj;
		}
		
		/**
		 * Use this method to add a PDF object to the PDF body.
		 * Use this method only if you know what you're doing!
		 * @param object
		 * @param inObjStm
		 * @return a PdfIndirectObject
		 * @throws IOException
		 */
		public function addToBody2( object: PdfObject, inObjStm: Boolean ): PdfIndirectObject
		{
			var iobj: PdfIndirectObject = body.add2( object, inObjStm );
			return iobj;
		}
		
		public function getImageReference( name: PdfName ): PdfIndirectReference
		{
			return imageDictionary.getValue( name ) as PdfIndirectReference;
		}
		
		/**
		 * Use this method to adds an image to the document
		 * but not to the page resources. It is used with
		 * templates and <CODE>Document.add(Image)</CODE>.
		 * Use this method only if you know what you're doing!
		 * @param image the <CODE>Image</CODE> to add
		 * @return the name of the image added
		 * @throws PdfException on error
		 * @throws DocumentException on error
		 */
		public function addDirectImageSimple( image: ImageElement ): PdfName
		{
			return addDirectImageSimple2( image, null );
		}
		
		/**
		 * Adds an image to the document but not to the page resources.
		 * It is used with templates and <CODE>Document.add(Image)</CODE>.
		 * Use this method only if you know what you're doing!
		 * @param image the <CODE>Image</CODE> to add
		 * @param fixedRef the reference to used. It may be <CODE>null</CODE>,
		 * a <CODE>PdfIndirectReference</CODE> or a <CODE>PRIndirectReference</CODE>.
		 * @return the name of the image added
		 * @throws PdfException on error
		 * @throws DocumentException on error
		 */
		public function addDirectImageSimple2( image: ImageElement, fixedRef: PdfIndirectReference ): PdfName
		{
			var name: PdfName;
			
			if( images.containsKey( image.mySerialId ) )
			{
				name = images.getValue( image.mySerialId );
			} else 
			{
				if( image.isimgtemplate )
				{
					throw new NonImplementatioError();
					/*
					name = new PdfName( "img" + images.length );
					if( image instanceof ImgWMF )
					{
						ImgWMF wmf = (ImgWMF)image;
						wmf.readWMF(PdfTemplate.createTemplate(this, 0, 0));
					}
					*/
				} else
				{
					var dref: PdfIndirectReference = image.getDirectReference();
					if( dref != null )
					{
						var rname: PdfName = new PdfName( "img" + images.size() );
						images.put( image.mySerialId, rname );
						imageDictionary.put( rname, dref );
						return rname;
					}
					
					var maskImage: ImageElement = image.imageMask;
					var maskRef: PdfIndirectReference = null;
					
					if( maskImage != null )
					{
						var mname: PdfName = images.getValue( maskImage.mySerialId );
						maskRef = getImageReference( mname );
					}
					
					var i: PdfImage = new PdfImage( image, "img" + images.size(), maskRef );
					
					/*
					if( image instanceof ImgJBIG2 )
					{
						throw new NonImplementatioError();
						byte[] globals = ((ImgJBIG2) image).getGlobalBytes();
						if (globals != null) {
							PdfDictionary decodeparms = new PdfDictionary();
							decodeparms.put(PdfName.JBIG2GLOBALS, getReferenceJBIG2Globals(globals));
							i.put(PdfName.DECODEPARMS, decodeparms);
						}
					}
					*/
					
					add2( i, fixedRef );
					name = i.name;
				}
				
				images.put( image.mySerialId, name );
			}
			
			return name;
		}

		
		/**
		 * Writes a <CODE>PdfImage</CODE> to the outputstream.
		 *
		 * @param pdfImage the image to be added
		 * @return a <CODE>PdfIndirectReference</CODE> to the encapsulated image
		 * @throws PdfException when a document isn't open yet, or has been closed
		 */
		
		private function add2( pdfImage: PdfImage, fixedRef: PdfIndirectReference): PdfIndirectReference
		{
			if( !imageDictionary.contains( pdfImage.name ) )
			{
				if( fixedRef is PRIndirectReference )
				{
					throw new NonImplementatioError();
					//var r2: PRIndirectReference = fixedRef;
					//fixedRef = new PdfIndirectReference( 0, getNewObjectNumber( r2.getReader(), r2.getNumber(), r2.getGeneration() ) );
				}
				
				if (fixedRef == null)
					fixedRef = addToBody( pdfImage ).getIndirectReference();
				else
					addToBody1( pdfImage, fixedRef );
				
				imageDictionary.put( pdfImage.name, fixedRef );
				return fixedRef;
			}
			return imageDictionary.getValue( pdfImage.name ) as PdfIndirectReference;
		}
		
		public function add( page: PdfPage, contents: PdfContents ): PdfIndirectReference
		{
			if( !opened )
				throw new Error("Document is not open");
			
			var object: PdfIndirectObject;
			object = addToBody( contents );
			
			page.add( object.getIndirectReference() );
			
			if( group != null ){
				page.put( PdfName.GROUP, group );
				group = null;
			} else if( rgbTransparencyBlending ) {
				var pp: PdfDictionary = new PdfDictionary();
				pp.put( PdfName.TYPE, PdfName.GROUP );
				pp.put( PdfName.S, PdfName.TRANSPARENCY );
				pp.put( PdfName.CS, PdfName.DEVICERGB );
				page.put( PdfName.GROUP, pp );
			}
			
			root.addPage( page );
			currentPageNumber++;
			return null;
		}
	}
}



class SingletonCheck{}