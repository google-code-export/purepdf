package org.purepdf.pdf
{
	import flash.utils.ByteArray;
	
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.purepdf.colors.ExtendedColor;
	import org.purepdf.colors.RGBColor;
	import org.purepdf.colors.SpotColor;
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.elements.images.ImageElement;
	import org.purepdf.errors.NonImplementatioError;
	import org.purepdf.errors.RuntimeError;
	import org.purepdf.utils.Bytes;
	import org.purepdf.utils.assertTrue;
	import org.purepdf.utils.collections.HashMap;
	import org.purepdf.utils.iterators.Iterator;
	import org.purepdf.utils.iterators.VectorIterator;
	import org.purepdf.utils.pdf_core;

	public class PdfWriter
	{
		public static const GENERATION_MAX: int = 65535;
		public static const NAME: String = 'purepdf';
		public static const PDF_VERSION_1_4: PdfName = new PdfName( "1.4" );
		public static const RELEASE: String = '0.0.1_ALPHA';
		public static const VERSION: String = NAME + ' ' + RELEASE;

		public static const VERSION_1_4: String = '4';
		protected var body: PdfBody;
		protected var colorNumber: int = 1;
		protected var compressionLevel: int = PdfStream.NO_COMPRESSION;
		protected var crypto: PdfEncryption;
		protected var currentPageNumber: int = 1;
		protected var defaultColorspace: PdfDictionary = new PdfDictionary();
		protected var defaultPageSize: PageSize;
		protected var directContent: PdfContentByte;
		protected var directContentUnder: PdfContentByte;
		protected var documentColors: HashMap = new HashMap();
		protected var documentExtGState: HashMap = new HashMap();
		protected var documentPatterns: HashMap = new HashMap();

		protected var documentSpotPatterns: HashMap = new HashMap();
		protected var extraCatalog: PdfDictionary;
		protected var formXObjects: HashMap = new HashMap();
		protected var formXObjectsCounter: int = 1;
		protected var fullCompression: Boolean = false;
		protected var group: PdfDictionary;
		protected var imageDictionary: PdfDictionary = new PdfDictionary();
		protected var images: HashMap = new HashMap();
		protected var opened: Boolean = false;

		protected var os: OutputStreamCounter;
		protected var pageReferences: Vector.<PdfIndirectReference> = new Vector.<PdfIndirectReference>();
		protected var patternColorspaceCMYK: ColorDetails;
		protected var patternColorspaceGRAY: ColorDetails;
		protected var patternColorspaceRGB: ColorDetails;
		protected var patternCounter: int = 1;
		protected var paused: Boolean = false;
		protected var pdf: PdfDocument;
		protected var pdf_version: PdfVersion = new PdfVersion();
		protected var prevxref: int = 0;
		protected var rgbTransparencyBlending: Boolean;
		protected var root: PdfPages;
		protected var tabs: PdfName = null;
		protected var xmpMetadata: Bytes = null;

		private var logger: ILogger = LoggerFactory.getClassLogger( PdfWriter );

		public function PdfWriter( instance: SingletonCheck, output: ByteArray, pagesize: RectangleElement )
		{
			assertTrue( instance != null && instance is SingletonCheck, "Use PdfWriter.create to initialize a new instance of purepdf" );

			os = new OutputStreamCounter( output );

			pdf = new PdfDocument( pagesize );
			pdf.addWriter( this );
			root = new PdfPages( this );

			directContent = new PdfContentByte( this );
			directContentUnder = new PdfContentByte( this );
		}

		public function add( page: PdfPage, contents: PdfContents ): PdfIndirectReference
		{
			if ( !opened )
				throw new Error( "Document is not open" );

			var object: PdfIndirectObject;
			object = addToBody( contents );

			page.add( object.getIndirectReference() );

			if ( group != null )
			{
				page.put( PdfName.GROUP, group );
				group = null;
			}
			else if ( rgbTransparencyBlending )
			{
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

		public function addSimpleExtGState( gstate: PdfDictionary ): Vector.<PdfObject>
		{
			if ( !documentExtGState.containsKey( gstate ) )
			{
				var obj: Vector.<PdfObject> = Vector.<PdfObject>( [ new PdfName( "Pr" + ( documentExtGState.size() + 1 ) ), getPdfIndirectReference() ] );
				documentExtGState.put( gstate, obj );
			}
			return documentExtGState.getValue( gstate );
		}

		public function addToBody( object: PdfObject ): PdfIndirectObject
		{
			var iobj: PdfIndirectObject = body.add1( object );
			return iobj;
		}

		public function addToBody1( object: PdfObject, ref: PdfIndirectReference ): PdfIndirectObject
		{
			var iobj: PdfIndirectObject = body.add3( object, ref );
			return iobj;
		}

		public function addToBody2( object: PdfObject, inObjStm: Boolean ): PdfIndirectObject
		{
			var iobj: PdfIndirectObject = body.add2( object, inObjStm );
			return iobj;
		}

		public function close(): void
		{
			if ( opened )
			{
				if ( ( currentPageNumber - 1 ) != pageReferences.length )
					throw new Error( "The page " + pageReferences.length + " was requested, but the document has only " + ( currentPageNumber
						- 1 ) + " pages" );
				pdf.close();

				addSharedObjectsToBody();
				var rootRef: PdfIndirectReference = root.writePageTree();

				var catalog: PdfDictionary = getCatalog( rootRef );

				if ( xmpMetadata != null )
				{
					logger.warn( 'implement this' );
				}

				/*
				   if( isPdfX() )
				   {
				   pdfConformance.completeInfoDictionary( getInfo() );
				   pdfConformance.completeExtraCatalog( getExtraCatalog() );
				   }
				 */

				if ( extraCatalog != null )
					catalog.mergeDifferent( extraCatalog );

				writeOutlines( catalog, false );
				var indirectCatalog: PdfIndirectObject = addToBody2( catalog, false );
				var infoObj: PdfIndirectObject = addToBody2( getInfo(), false );

				// encryption
				var encryption: PdfIndirectReference = null;
				var fileID: PdfObject = null;
				body.flushObjStm();

				if ( crypto != null )
				{
					logger.warn( 'implement this' );
				}
				else
				{
					fileID = PdfEncryption.createInfoId( PdfEncryption.createDocumentId() );
				}

				// write the cross-reference table of the body
				body.writeCrossReferenceTable( os, indirectCatalog.getIndirectReference(), infoObj.getIndirectReference(), encryption
					, fileID, prevxref );

				// full compression
				if ( fullCompression )
				{
					os.writeBytes( getISOBytes( "startxref\n" ) );
					os.writeBytes( getISOBytes( body.offset().toString() ) );
					os.writeBytes( getISOBytes( "\n%%EOF\n" ) );
				}
				else
				{
					var trailer: PdfTrailer = new PdfTrailer( body.size(), body.offset(), indirectCatalog.getIndirectReference(), infoObj
						.getIndirectReference(), encryption, fileID, prevxref );
					trailer.toPdf( this, os );
				}
			}
		}

		/**
		 * Returns the compression level used for streams written by this writer.
		 * @return the compression level (0 = best speed, 9 = best compression, -1 is default)
		 */
		public function getCompressionLevel(): int
		{
			return compressionLevel;
		}

		public function getCurrentPage(): PdfIndirectReference
		{
			return getPageReference( currentPageNumber );
		}

		public function getCurrentPageNumber(): int
		{
			return currentPageNumber;
		}

		public function getDefaultColorSpace(): PdfDictionary
		{
			return defaultColorspace;
		}

		public function getDirectContent(): PdfContentByte
		{
			if ( !opened )
				throw new Error( "Document is not open" );
			return directContent;
		}

		public function getDirectContentUnder(): PdfContentByte
		{
			if ( !opened )
				throw new Error( "Document is not open" );
			return directContentUnder;
		}

		public function getEncryption(): PdfEncryption
		{
			return crypto;
		}

		public function getExtraCatalog(): PdfDictionary
		{
			if ( extraCatalog == null )
				extraCatalog = new PdfDictionary();
			return extraCatalog;
		}

		public function getGroup(): PdfDictionary
		{
			return group;
		}

		public function getImageReference( name: PdfName ): PdfIndirectReference
		{
			return imageDictionary.getValue( name ) as PdfIndirectReference;
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

		public function getOs(): OutputStreamCounter
		{
			return os;
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

			if ( page < 0 )
				throw new ArgumentError( "page number must be >= 1" );

			var ref: PdfIndirectReference;

			if ( page < pageReferences.length )
			{
				ref = pageReferences[ page ] as PdfIndirectReference;

				if ( ref == null )
				{
					ref = body.getPdfIndirectReference();
					pageReferences[ page ] = ref;
				}
			}
			else
			{
				var empty: int = page - pageReferences.length;

				for ( var k: int = 0; k < empty; ++k )
					pageReferences.push( null );

				ref = body.getPdfIndirectReference();
				pageReferences.push( ref );
			}
			return ref;
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

		public function getPdfVersion(): PdfVersion
		{
			return pdf_version;
		}

		public function getTabs(): PdfName
		{
			return tabs;
		}

		public function isFullCompression(): Boolean
		{
			return fullCompression;
		}


		public function isOpen(): Boolean
		{
			return opened;
		}

		public function isPaused(): Boolean
		{
			return paused;
		}

		/**
		 * Gets the transparency blending colorspace.
		 * @return <code>true</code> if the transparency blending colorspace is RGB, <code>false</code>
		 * if it is the default blending colorspace
		 */
		public function isRgbTransparencyBlending(): Boolean
		{
			return rgbTransparencyBlending;
		}

		public function get pdfDocument(): PdfDocument
		{
			return pdf;
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

		/**
		 *
		 * @param key
		 * 		the name of the colorspace. It can be PdfName.DEFAULTGRAY, PdfName.DEFAULTRGB or PdfName.DEFAULTCMYK
		 */
		public function setDefaultColorSpace( key: PdfName, value: PdfObject ): void
		{
			if ( value == null || value.isNull() )
				defaultColorspace.remove( key );
			defaultColorspace.put( key, value );
		}

		public function setEncryption( value: PdfEncryption ): void
		{
			crypto = value;
		}

		public function setGroup( value: PdfDictionary ): void
		{
			group = value;
		}

		/**
		 * Sets the transparency blending colorspace to RGB. The default blending colorspace is
		 * CMYK and will result in faded colors in the screen and in printing. Calling this method
		 * will return the RGB colors to what is expected. The RGB blending will be applied to all subsequent pages
		 * until other value is set.
		 * Note that this is a generic solution that may not work in all cases.
		 * @param rgbTransparencyBlending <code>true</code> to set the transparency blending colorspace to RGB, <code>false</code>
		 * to use the default blending colorspace
		 */
		public function setRgbTransparencyBlending( value: Boolean ): void
		{
			rgbTransparencyBlending = value;
		}

		public function setTabs( value: PdfName ): void
		{
			tabs = value;
		}

		protected function addSharedObjectsToBody(): void
		{
			logger.warn( 'addSharedObjectsToBody. partially implemented' );

			var it: Iterator;

			// 3 add the fonts
			// 4 add the form XObjects
			it = new VectorIterator( formXObjects.getValues() );
			for( it; it.hasNext(); )
			{
				var obj: Vector.<Object> = Vector.<Object>( it.next() );
				var template: PdfTemplate = obj[1] as PdfTemplate;
				if( template != null && template.indirectReference is PRIndirectReference )
					continue;
				if( template != null && template.type == PdfTemplate.TYPE_TEMPLATE )
					addToBody1( template.getFormXObject( compressionLevel ), template.indirectReference );
			}
			
			// 5 add all the dependencies in the imported pages
			// 6 add the spotcolors
			it = new VectorIterator( documentColors.getValues() );

			for ( it; it.hasNext(); )
			{
				var color: ColorDetails = ColorDetails( it.next() );
				addToBody1( color.getSpotColor( this ), color.indirectReference );
			}

			// 7 add the pattern
			it = new VectorIterator( documentPatterns.getKeys() );
			var pat: PdfPatternPainter;
			for( it; it.hasNext(); )
			{
				pat = it.next() as PdfPatternPainter;
				addToBody1( pat.getPattern( compressionLevel ), pat.indirectReference );
			}
			
			// 8 add the shading patterns
			// 9 add the shadings
			// 10 add the extgstate
			it = new VectorIterator( documentExtGState.getKeys() );

			for ( it; it.hasNext();  )
			{
				var gstate: PdfDictionary = it.next();
				var obj: Vector.<PdfObject> = documentExtGState.getValue( gstate );
				addToBody1( gstate, PdfIndirectReference( obj[ 1 ] ) );
			}

			// 11 add the properties
			// 13 add the OCG layers
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

			logger.warn( 'getCatalog. to be implemented' );

			return catalog;
		}

		protected function writeOutlines( catalog: PdfDictionary, namedAsNames: Boolean ): void
		{
			logger.warn( 'writeOutlines. to be implemented' );
		}

		internal function addDirectImageSimple( image: ImageElement ): PdfName
		{
			return addDirectImageSimple2( image, null );
		}

		internal function addDirectImageSimple2( image: ImageElement, fixedRef: PdfIndirectReference ): PdfName
		{
			var name: PdfName;

			if ( images.containsKey( image.mySerialId ) )
			{
				name = images.getValue( image.mySerialId );
			}
			else
			{
				if ( image.isimgtemplate )
				{
					throw new NonImplementatioError();
				}
				else
				{
					var dref: PdfIndirectReference = image.directReference;

					if ( dref != null )
					{
						var rname: PdfName = new PdfName( "img" + images.size() );
						images.put( image.mySerialId, rname );
						imageDictionary.put( rname, dref );
						return rname;
					}

					var maskImage: ImageElement = image.imageMask;
					var maskRef: PdfIndirectReference = null;

					if ( maskImage != null )
					{
						var mname: PdfName = images.getValue( maskImage.mySerialId );
						maskRef = getImageReference( mname );
					}

					var i: PdfImage = new PdfImage( image, "img" + images.size(), maskRef );

					add2( i, fixedRef );
					name = i.name;
				}

				images.put( image.mySerialId, name );
			}

			return name;
		}


		/**
		 * Adds a template to the document but not to the page resources.
		 * @param template the template to add
		 * @param forcedName the template name, rather than a generated one. Can be null
		 * @return the <CODE>PdfName</CODE> for this template
		 */

		internal function addDirectTemplateSimple( template: PdfTemplate, forcedName: PdfName ): PdfName
		{
			var ref: PdfIndirectReference = template.indirectReference;
			var obj: Vector.<Object> = Vector.<Object>( formXObjects.getValue( ref ) );
			var name: PdfName = null;

			if ( obj == null )
			{
				if ( forcedName == null )
				{
					name = new PdfName( "Xf" + formXObjectsCounter );
					++formXObjectsCounter;
				}
				else
					name = forcedName;

				if ( template.type == PdfTemplate.TYPE_IMPORTED )
				{
					// If we got here from PdfCopy we'll have to fill importedPages
					throw new NonImplementatioError();
				}
				formXObjects.put( ref, Vector.<Object>( [ name, template ] ) );
			}
			else
				name = PdfName( obj[ 0 ] );

			return name;
		}

		/**
		 * Adds a SpotColor to the document but not to the page resources.
		 *
		 * @param spc the SpotColor
		 * @return a Vector of Objects where position 0 is a PdfName
		 * and position 1 is an PdfIndirectReference
		 *
		 */
		internal function addSimple( spc: PdfSpotColor ): ColorDetails
		{
			var ret: ColorDetails = documentColors.getValue( spc );

			if ( ret == null )
			{
				ret = new ColorDetails( getColorspaceName(), body.getPdfIndirectReference(), spc );
				documentColors.put( spc, ret );
			}
			return ret;
		}

		pdf_core function addSimplePattern( painter: PdfPatternPainter ): PdfName
		{
			var name: PdfName = documentPatterns.getValue( painter ) as PdfName;

			if ( name == null )
			{
				name = new PdfName( "P" + patternCounter );
				++patternCounter;
				documentPatterns.put( painter, name );
			}

			return name;
		}


		pdf_core function addSimplePatternColorSpace( color: RGBColor ): ColorDetails
		{
			var type: int = ExtendedColor.getType( color );
			var array: PdfArray;

			if ( type == ExtendedColor.TYPE_PATTERN || type == ExtendedColor.TYPE_SHADING )
				throw new RuntimeError( "an uncolored tile pattern can not have another pattern or shading as color" );

			switch ( type )
			{
				case ExtendedColor.TYPE_RGB:
					if ( patternColorspaceRGB == null )
					{
						patternColorspaceRGB = new ColorDetails( getColorspaceName(), body.getPdfIndirectReference(), null );
						array = new PdfArray( PdfName.PATTERN );
						array.add( PdfName.DEVICERGB );
						addToBody1( array, patternColorspaceRGB.indirectReference );
					}
					return patternColorspaceRGB;

				case ExtendedColor.TYPE_CMYK:
					if ( patternColorspaceCMYK == null )
					{
						patternColorspaceCMYK = new ColorDetails( getColorspaceName(), body.getPdfIndirectReference(), null );
						array = new PdfArray( PdfName.PATTERN );
						array.add( PdfName.DEVICECMYK );
						addToBody1( array, patternColorspaceCMYK.indirectReference );
					}
					return patternColorspaceCMYK;
				case ExtendedColor.TYPE_GRAY:
					if ( patternColorspaceGRAY == null )
					{
						patternColorspaceGRAY = new ColorDetails( getColorspaceName(), body.getPdfIndirectReference(), null );
						array = new PdfArray( PdfName.PATTERN );
						array.add( PdfName.DEVICEGRAY );
						addToBody1( array, patternColorspaceGRAY.indirectReference );
					}
					return patternColorspaceGRAY;
				case ExtendedColor.TYPE_SEPARATION:
				{
					var details: ColorDetails = addSimple( SpotColor( color ).pdfSpotColor );
					var patternDetails: ColorDetails = documentSpotPatterns.getValue( details ) as ColorDetails;

					if ( patternDetails == null )
					{
						patternDetails = new ColorDetails( getColorspaceName(), body.getPdfIndirectReference(), null );
						array = new PdfArray( PdfName.PATTERN );
						array.add( details.indirectReference );
						addToBody1( array, patternDetails.indirectReference );
						documentSpotPatterns.put( details, patternDetails );
					}
					return patternDetails;
				}
				default:
					throw new RuntimeError( "invalid color type" );
			}
		}


		internal function getColorspaceName(): PdfName
		{
			return new PdfName( "CS" + ( colorNumber++ ) );
		}

		internal function open(): PdfDocument
		{
			if ( !opened )
			{
				opened = true;
				pdf_version.writeHeader( os );
				body = new PdfBody( this );
			}

			return pdf;
		}

		private function add2( pdfImage: PdfImage, fixedRef: PdfIndirectReference ): PdfIndirectReference
		{
			if ( !imageDictionary.contains( pdfImage.name ) )
			{
				if ( fixedRef is PRIndirectReference )
				{
					throw new NonImplementatioError();
				}

				if ( fixedRef == null )
					fixedRef = addToBody( pdfImage ).getIndirectReference();
				else
					addToBody1( pdfImage, fixedRef );

				imageDictionary.put( pdfImage.name, fixedRef );
				return fixedRef;
			}
			return imageDictionary.getValue( pdfImage.name ) as PdfIndirectReference;
		}

		public static function create( output: ByteArray, pagesize: RectangleElement ): PdfDocument
		{
			var writer: PdfWriter = new PdfWriter( new SingletonCheck(), output, pagesize );
			return writer.pdfDocument;
		}

		public static function getISOBytes( text: String ): Bytes
		{
			if ( text == null )
				return null;
			var len: int = text.length;
			var byte: Bytes = new Bytes();

			for ( var k: int = 0; k < len; ++k )
				byte[ k ] = text.charCodeAt( k );
			return byte;
		}

		public static function getVectorISOBytes( text: String ): Vector.<int>
		{
			if ( text == null )
				return null;
			var len: int = text.length;
			var byte: Vector.<int> = new Vector.<int>();

			for ( var k: int = 0; k < len; ++k )
				byte[ k ] = text.charCodeAt( k );
			return byte;
		}
	}
}

class SingletonCheck
{
}