package org.purepdf.elements.images
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	import org.purepdf.codecs.TIFFEncoder;
	import org.purepdf.elements.AnnotationElement;
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.errors.BadElementError;
	import org.purepdf.errors.NonImplementatioError;
	import org.purepdf.pdf.PdfDictionary;
	import org.purepdf.pdf.PdfIndirectReference;
	import org.purepdf.pdf.PdfStream;
	import org.purepdf.pdf.PdfTemplate;
	import org.purepdf.pdf.codec.GifImage;
	import org.purepdf.pdf.codec.PngImage;
	import org.purepdf.pdf.interfaces.IPdfOCG;

	public class ImageElement extends RectangleElement
	{
		public static const AX: int = 0;
		public static const AY: int = 1;
		public static const BX: int = 2;
		public static const BY: int = 3;
		public static const CX: int = 4;
		public static const CY: int = 5;
		public static const DEFAULT: int = 0;
		public static const DX: int = 6;
		public static const DY: int = 7;
		public static const LEFT: int = 0;
		public static const MIDDLE: int = 1;
		public static const ORIGINAL_BMP: int = 4;
		public static const ORIGINAL_GIF: int = 3;
		public static const ORIGINAL_JBIG2: int = 9;
		public static const ORIGINAL_JPEG: int = 1;
		public static const ORIGINAL_JPEG2000: int = 8;
		public static const ORIGINAL_NONE: int = 0;
		public static const ORIGINAL_PNG: int = 2;
		public static const ORIGINAL_PS: int = 7;
		public static const ORIGINAL_TIFF: int = 5;
		public static const ORIGINAL_WMF: int = 6;
		public static const RIGHT: int = 2;
		public static const TEXTWRAP: int = 4;
		public static const UNDERLYING: int = 8;
		protected static var serialId: Number = 0;
		protected var _url: String;
		protected var _XYRatio: Number = 0;
		protected var _absoluteX: Number = NaN;
		protected var _absoluteY: Number = NaN;
		protected var _additional: PdfDictionary;
		protected var _alignment: int;
		protected var _annotation: AnnotationElement = null;
		protected var _bpc: int = 1;
		protected var _colorspace: int = -1;
		protected var _deflated: Boolean = false;
		protected var _imageMask: ImageElement;
		protected var _indentationLeft: Number = 0;
		protected var _indentationRight: Number = 0;
		protected var _interpolation: Boolean;
		protected var _invert: Boolean = false;
		protected var _layer: IPdfOCG;
		protected var _mask: Boolean = false;
		protected var _mySerialId: Number = getSerialId();
		protected var _originalData: ByteArray;
		protected var _originalType: int = ORIGINAL_NONE;
		protected var _rawData: ByteArray;
		protected var _smask: Boolean;
		protected var _transparency: Vector.<int>;
		protected var _type: int;
		protected var alt: String;
		protected var compressionLevel: int = PdfStream.NO_COMPRESSION;
		protected var dpiX: int = 0;
		protected var dpiY: int = 0;
		protected var initialRotation: Number = 0;
		protected var plainHeight: Number;
		protected var plainWidth: Number;
		protected var rotationRadians: Number;
		protected var scaledHeight: Number;
		protected var scaledWidth: Number;
		protected var template: Vector.<PdfTemplate> = new Vector.<PdfTemplate>( 1 );
		private var directReference: PdfIndirectReference;
		private var _widthPercentage: Number = 100;

		public function ImageElement( $url: String )
		{
			super( 0, 0, 0, 0 );
			_url = $url;
			_alignment = DEFAULT;
			rotationRadians = 0;
		}

		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
		}

		public function get absoluteX(): Number
		{
			return _absoluteX;
		}

		public function get absoluteY(): Number
		{
			return _absoluteY;
		}

		public function get additional(): PdfDictionary
		{
			return _additional;
		}

		public function set additional( value: PdfDictionary ): void
		{
			_additional = value;
		}

		public function get alignment(): int
		{
			return _alignment;
		}

		public function set alignment( value: int ): void
		{
			_alignment = value;
		}

		public function get annotation(): AnnotationElement
		{
			return _annotation;
		}
		
		public function set annotation( value: AnnotationElement ): void
		{
			_annotation = value;
		}

		public function get bpc(): int
		{
			return _bpc;
		}

		public function get colorspace(): int
		{
			return _colorspace;
		}

		public function get deflated(): Boolean
		{
			return _deflated;
		}

		public function set deflated( value: Boolean ): void
		{
			_deflated = value;
		}

		public function getCompressionLevel(): int
		{
			return compressionLevel;
		}

		public function getDirectReference(): PdfIndirectReference
		{
			return directReference;
		}

		/**
		 * Get the current Image rotation in radians
		 *
		 * @return rotation in radians
		 */
		public function getImageRotation(): Number
		{
			var d: Number = Math.PI * 2;
			var rot: Number = ( rotationRadians - initialRotation ) % d;

			if ( rot < 0 )
				rot += d;
			return rot;
		}

		public function getScaledHeight(): Number
		{
			return scaledHeight;
		}

		public function getScaledWidth(): Number
		{
			return scaledWidth;
		}

		public function get hasAbsoluteX(): Boolean
		{
			return !isNaN( absoluteX );
		}

		public function get hasAbsoluteY(): Boolean
		{
			return !isNaN( absoluteY );
		}

		public function get imageMask(): ImageElement
		{
			return _imageMask;
		}

		public function set imageMask( value: ImageElement ): void
		{
			if ( _mask )
				throw new Error( "an image mask cannot contain another image mask" );

			if ( !value.ismask )
				throw new Error( "the image mask is not a valid mask" );
			_imageMask = value;
			_smask = ( value.bpc > 1 && value.bpc <= 8 );
		}

		public function get indentationLeft(): Number
		{
			return _indentationLeft;
		}

		public function get indentationRight(): Number
		{
			return _indentationRight;
		}

		public function get isimgraw(): Boolean
		{
			return _type == IMGRAW;
		}

		public function get isimgtemplate(): Boolean
		{
			return _type == IMGTEMPLATE;
		}

		public function get isinterpolated(): Boolean
		{
			return _interpolation;
		}

		public function get isinverted(): Boolean
		{
			return _invert;
		}
		
		public function set isinverted( value: Boolean ): void
		{
			_invert = value;
		}
				

		public function get ismask(): Boolean
		{
			return _mask;
		}

		public function get issmask(): Boolean
		{
			return _smask;
		}

		public function get layer(): IPdfOCG
		{
			return _layer;
		}

		public function makeMask(): void
		{
			if ( !ismaskcandidate )
				throw new Error( "this image cannot be an image mask" );
			_mask = true;
		}

		public function get matrix(): Vector.<Number>
		{
			var mt: Vector.<Number> = new Vector.<Number>( 8, true );
			var cosX: Number = Math.cos( rotationRadians );
			var sinX: Number = Math.sin( rotationRadians );
			mt[ AX ] = plainWidth * cosX;
			mt[ AY ] = plainWidth * sinX;
			mt[ BX ] = ( -plainHeight ) * sinX;
			mt[ BY ] = plainHeight * cosX;

			if ( rotationRadians < Math.PI / 2 )
			{
				mt[ CX ] = mt[ BX ];
				mt[ CY ] = 0;
				mt[ DX ] = mt[ AX ];
				mt[ DY ] = mt[ AY ] + mt[ BY ];
			}
			else if ( rotationRadians < Math.PI )
			{
				mt[ CX ] = mt[ AX ] + mt[ BX ];
				mt[ CY ] = mt[ BY ];
				mt[ DX ] = 0;
				mt[ DY ] = mt[ AY ];
			}
			else if ( rotationRadians < Math.PI * 1.5 )
			{
				mt[ CX ] = mt[ AX ];
				mt[ CY ] = mt[ AY ] + mt[ BY ];
				mt[ DX ] = mt[ BX ];
				mt[ DY ] = 0;
			}
			else
			{
				mt[ CX ] = 0;
				mt[ CY ] = mt[ AY ];
				mt[ DX ] = mt[ AX ] + mt[ BX ];
				mt[ DY ] = mt[ BY ];
			}
			return mt;
		}

		public function get mySerialId(): Number
		{
			return _mySerialId;
		}

		public function get originalData(): ByteArray
		{
			return _originalData;
		}

		public function set originalData( value: ByteArray ): void
		{
			_originalData = value;
		}

		public function get originalType(): int
		{
			return _originalType;
		}

		public function set originalType( value: int ): void
		{
			_originalType = value;
		}

		public function get rawData(): ByteArray
		{
			return _rawData;
		}

		/**
		 * Set the absolute position of the Image
		 *
		 * @param absX
		 * @param absY
		 */
		public function setAbsolutePosition( absX: Number, absY: Number ): void
		{
			_absoluteX = absX;
			_absoluteY = absY;
		}

		public function setCompressionLevel( value: int ): void
		{
			if ( value < PdfStream.NO_COMPRESSION || value > PdfStream.BEST_COMPRESSION )
				compressionLevel = PdfStream.DEFAULT_COMPRESSION;
			else
				compressionLevel = value;
		}

		public function setDpi( x: int, y: int ): void
		{
			dpiX = x;
			dpiY = y;
		}

		/**
		 * Set the rotation of the Image in radians
		 *
		 * @param r
		 * 			rotation in radians
		 */
		public function setRotation( r: Number ): void
		{
			var d: Number = 2 * Math.PI;
			rotationRadians = ( r + initialRotation ) % d;

			if ( rotationRadians < 0 )
				rotationRadians += d;
			var m: Vector.<Number> = matrix;
			scaledWidth = m[ DX ] - m[ CX ];
			scaledHeight = m[ DY ] - m[ CY ];
		}

		/**
		 * Set the rotation of the Image in degrees
		 *
		 * @param deg
		 * 				rotation in degrees
		 */
		public function setRotationDegrees( deg: Number ): void
		{
			setRotation( deg / 180 * Math.PI );
		}

		public function get templateData(): PdfTemplate
		{
			return template[ 0 ];
		}

		public function get transparency(): Vector.<int>
		{
			return _transparency;
		}

		public function set transparency( value: Vector.<int> ): void
		{
			_transparency = value;
		}

		override public function type(): int
		{
			return _type;
		}

		public function get xyratio(): Number
		{
			return _XYRatio;
		}

		public function set xyratio( value: Number ): void
		{
			_XYRatio = value;
		}

		private function get ismaskcandidate(): Boolean
		{
			if ( _type == IMGRAW )
			{
				if ( _bpc > 0xFF )
				{
					return true;
				}
			}
			return _colorspace == 1;
		}

		/**
		 * Create a new ImageElement instance from the passed image data
		 * Currently allowed image types are: jpeg, png, gif (and animated gif), tiff
		 * 
		 */
		public static function getInstance( buffer: ByteArray ): ImageElement
		{
			buffer.position = 0;
			var c1: uint = buffer.readUnsignedByte();
			var c2: uint = buffer.readUnsignedByte();
			var c3: uint = buffer.readUnsignedByte();
			var c4: uint = buffer.readUnsignedByte();

			// GIF
			if ( c1 == "G".charCodeAt( 0 ) && c2 == "I".charCodeAt( 0 ) && c3 == "F".charCodeAt( 0 ) )
			{
				var gif: GifImage = new GifImage( buffer );
				return gif.getImage();
			}

			// JPEG
			if ( c1 == 0xFF && c2 == 0xD8 )
			{
				return new Jpeg( buffer );
			}

			// PNG
			if ( c1 == PngImage.PNGID[ 0 ] && c2 == PngImage.PNGID[ 1 ] && c3 == PngImage.PNGID[ 2 ] && c4 == PngImage.PNGID[ 3 ] )
			{
				return PngImage.getImage( buffer );
			}
			
			// TIFF
			if( ( c1 == 'M'.charCodeAt(0) && c2 == 'M'.charCodeAt(0) && c3 == 0 && c4 == 42 ) || (c1 == 'I'.charCodeAt(0) && c2 == 'I'.charCodeAt(0) && c3 == 42 && c4 == 0)) 
			{
			}
			
			throw new Error( "byte array is not a recognized image format" );
			return null;
		}

		public static function getRawInstance( width: int, height: int, components: int, bpc: int, data: ByteArray, transparency: Vector.<int>=null ): ImageElement
		{
			if ( transparency != null && transparency.length != components * 2 )
				throw new BadElementError( "transparency length must be equal to components*2" );

			if ( components == 1 && bpc == 1 )
			{
				throw new NonImplementatioError();
			}
			var img: ImageElement = new ImageRaw( width, height, components, bpc, data );
			img.transparency = transparency;
			return img;
		}
		
		/**
		 * Create an ImageElement instance from a BitmapData
		 * 
		 */
		public static function getBitmapDataInstance( data: BitmapData ): ImageElement
		{
			var bytes: ByteArray = TIFFEncoder.encode( data );
			return ImageElement.getRawInstance( data.width, data.height, 3, 8, bytes );
		}

		/** Creates a new serial id. */
		protected static function getSerialId(): Number
		{
			++serialId;
			return serialId;
		}
		
		/**
		 * Scale the Image to an absolute width and height
		 * 
		 * @param newWidth
		 * 					the new image width
		 * @param newHeight
		 * 					the new image height
		 */
		public function scaleAbsolute( newWidth: Number, newHeight: Number ): void
		{
			plainWidth = newWidth;
			plainHeight = newHeight;
			var m: Vector.<Number> = matrix;
			scaledWidth = m[DX] - m[CX];
			scaledHeight = m[DY] - m[CY];
			setWidthPercentage( 0 );
		}
		
		/**
		 * Scale the image to an absolute height
		 * 
		 * @param newHeight
		 */
		public function scaleAbsoluteHeight( newHeight: Number ): void
		{
			plainHeight = newHeight;
			var m: Vector.<Number> = matrix;
			scaledWidth = m[DX] - m[CX];
			scaledHeight = m[DY] - m[CY];
			setWidthPercentage( 0 );
		}
		
		/**
		 * Scale the image to an absolute width
		 * 
		 * @param newWidth
		 */
		public function scaleAbsoluteWidth( newWidth: Number ): void
		{
			plainWidth = newWidth;
			var m: Vector.<Number> = matrix;
			scaledWidth = m[DX] - m[CX];
			scaledHeight = m[DY] - m[CY];
			setWidthPercentage( 0 );
		}
		
		/**
		 * Scale the width and the height of the Image to an absolute percentage
		 * 
		 * @param percentX
		 * @param percentY
		 */
		public function scalePercent( percentX: Number, percentY: Number ):void
		{
			plainWidth = ( getWidth() * percentX) / 100;
			plainHeight = (getHeight() * percentY) / 100;
			var m: Vector.<Number> = matrix;
			scaledWidth = m[DX] - m[CX];
			scaledHeight = m[DY] - m[CY];
			setWidthPercentage( 0 );
		}
		
		/**
		 * Scales the Image to fit an absolute width and height.
		 * 
		 * @param fitWidth
		 * @param fitHeight
		 */
		public function scaleToFit( fitWidth: Number, fitHeight: Number ): void
		{
			scalePercent( 100, 100 );
			var percentX: Number = (fitWidth * 100) / getScaledWidth();
			var percentY: Number = (fitHeight * 100) / getScaledHeight();
			scalePercent( percentX < percentY ? percentX : percentY, percentX < percentY ? percentX : percentY );
			setWidthPercentage( 0 );
		}
		
		public function setWidthPercentage( value: Number ): void
		{
			_widthPercentage = value;
		}
		
		public function getWidthPercentage(): Number
		{
			return _widthPercentage;
		}
	}
}