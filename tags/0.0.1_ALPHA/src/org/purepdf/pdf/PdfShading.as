package org.purepdf.pdf
{
	import flash.errors.IllegalOperationError;
	
	import it.sephiroth.utils.ObjectHash;
	
	import org.purepdf.colors.CMYKColor;
	import org.purepdf.colors.ExtendedColor;
	import org.purepdf.colors.GrayColor;
	import org.purepdf.colors.RGBColor;
	import org.purepdf.colors.SpotColor;
	import org.purepdf.utils.pdf_core;

	public class PdfShading extends ObjectHash
	{
		protected var _antiAlias: Boolean = false;

		protected var _bBox: Vector.<Number>;
		protected var _colorDetails: ColorDetails;
		protected var _shading: PdfDictionary;
		protected var _shadingName: PdfName;
		protected var _shadingReference: PdfIndirectReference;
		protected var _shadingType: int;
		protected var _writer: PdfWriter;

		private var _cspace: RGBColor;
		
		use namespace pdf_core;

		public function PdfShading( $writer: PdfWriter )
		{
			super();
			_writer = $writer;
		}

		public function addToBody(): void
		{
			if ( _bBox != null )
				_shading.put( PdfName.BBOX, new PdfArray( _bBox ) );

			if ( _antiAlias )
				_shading.put( PdfName.ANTIALIAS, PdfBoolean.PDF_TRUE );
			_writer.addToBody1( _shading, shadingReference );
		}

		public function get antiAlias(): Boolean
		{
			return _antiAlias;
		}

		public function set antiAlias( value: Boolean ): void
		{
			_antiAlias = value;
		}

		public function get bBox(): Vector.<Number>
		{
			return _bBox;
		}

		public function set bBox( value: Vector.<Number> ): void
		{
			if ( value.length != 4 )
				throw new ArgumentError( "value must have a length of 4" );
			_bBox = value;
		}

		public function get colorSpace(): RGBColor
		{
			return _cspace;
		}

		public function setName( number: int ): void
		{
			_shadingName = new PdfName( "Sh" + number );
		}

		public function get shadingName(): PdfName
		{
			return _shadingName;
		}

		public function get shadingReference(): PdfIndirectReference
		{
			if ( _shadingReference == null )
				_shadingReference = _writer.getPdfIndirectReference();
			return _shadingReference;
		}

		internal function get colorDetails(): ColorDetails
		{
			return _colorDetails;
		}

		pdf_core function set colorSpace( color: RGBColor ): void
		{
			_cspace = color;
			var type: int = ExtendedColor.getType( color );
			var cs: PdfObject = null;

			switch ( type )
			{
				case ExtendedColor.TYPE_GRAY:
					cs = PdfName.DEVICEGRAY;
					break;

				case ExtendedColor.TYPE_CMYK:
					cs = PdfName.DEVICECMYK;
					break;

				case ExtendedColor.TYPE_SEPARATION:
					var spot: SpotColor = SpotColor( color );
					_colorDetails = writer.pdf_core::addSimple( spot.pdfSpotColor );
					cs = colorDetails.indirectReference;
					break;

				case ExtendedColor.TYPE_PATTERN:
				case ExtendedColor.TYPE_SHADING:
					throwColorSpaceErrror();

				default:
					cs = PdfName.DEVICERGB;
					break;
			}

			_shading.put( PdfName.COLORSPACE, cs );
		}

		internal function get writer(): PdfWriter
		{
			return _writer;
		}

		public static function checkCompatibleColors( c1: RGBColor, c2: RGBColor ): void
		{
			var type1: int = ExtendedColor.getType( c1 );
			var type2: int = ExtendedColor.getType( c2 );

			if ( type1 != type2 )
				throw new ArgumentError( "colors must be of the same type" );

			if ( type1 == ExtendedColor.TYPE_SEPARATION && SpotColor( c1 ).pdfSpotColor != SpotColor( c2 ).pdfSpotColor )
				throw new ArgumentError( "spot color must be the same. Only tint can vary" );

			if ( type1 == ExtendedColor.TYPE_PATTERN || type1 == ExtendedColor.TYPE_SHADING )
				throwColorSpaceErrror();
		}

		public static function getColorArray( color: RGBColor ): Vector.<Number>
		{
			var type: int = ExtendedColor.getType( color );

			switch ( type )
			{
				case ExtendedColor.TYPE_GRAY:
					return Vector.<Number>( [ GrayColor( color ).gray ] );

				case ExtendedColor.TYPE_CMYK:
					var cmyk: CMYKColor = CMYKColor( color );
					return Vector.<Number>( [ cmyk.cyan, cmyk.magenta, cmyk.yellow, cmyk.black ] );

				case ExtendedColor.TYPE_SEPARATION:
					return Vector.<Number>( [ SpotColor( color ).tint ] );

				case ExtendedColor.TYPE_RGB:
				{
					return Vector.<Number>( [ color.red / 255, color.green / 255, color.blue / 255 ] );
				}
			}
			throwColorSpaceErrror();
			return null;
		}

		public static function simpleAxial( writer: PdfWriter, x0: Number, y0: Number, x1: Number, y1: Number, startColor: RGBColor, endColor: RGBColor
			, extendStart: Boolean=true, extendEnd: Boolean=true ): PdfShading
		{
			checkCompatibleColors( startColor, endColor );
			var fn: PdfFunction = PdfFunction.type2( writer, Vector.<Number>( [ 0, 1 ] ), null, getColorArray( startColor ), getColorArray( endColor )
				, 1 );

			return type2( writer, startColor, Vector.<Number>( [ x0, y0, x1, y1 ] ), null, fn, Vector.<Boolean>( [ extendStart, extendEnd ] ) );
		}

		public static function simpleRadial( writer: PdfWriter, x0: Number, y0: Number, r0: Number, x1: Number, y1: Number, r1: Number
			, startColor: RGBColor, endColor: RGBColor, extendStart: Boolean=true, extendEnd: Boolean=true ): PdfShading
		{
			checkCompatibleColors( startColor, endColor );
			var fn: PdfFunction = PdfFunction.type2( writer, Vector.<Number>( [ 0, 1 ] ), null, getColorArray( startColor ), getColorArray( endColor )
				, 1 );
			return type3( writer, startColor, Vector.<Number>( [ x0, y0, r0, x1, y1, r1 ] ), null, fn, Vector.<Boolean>( [ extendStart, extendEnd ] ) );
		}

		public static function throwColorSpaceErrror(): void
		{
			throw new IllegalOperationError( "A tiling or shading pattern must be used as a color space in a shading pattern" );
		}

		public static function type1( writer: PdfWriter, cs: RGBColor, domain: Vector.<Number>, tMatrix: Vector.<Number>, fn: PdfFunction ): PdfShading
		{
			var sp: PdfShading = new PdfShading( writer );
			sp._shading = new PdfDictionary();
			sp._shadingType = 1;
			sp._shading.put( PdfName.SHADINGTYPE, new PdfNumber( sp._shadingType ) );
			sp.pdf_core::colorSpace = cs;

			if ( domain != null )
				sp._shading.put( PdfName.DOMAIN, new PdfArray( domain ) );

			if ( tMatrix != null )
				sp._shading.put( PdfName.MATRIX, new PdfArray( tMatrix ) );

			sp._shading.put( PdfName.FUNCTION, fn.reference );
			return sp;
		}

		public static function type2( writer: PdfWriter, cs: RGBColor, coords: Vector.<Number>, domain: Vector.<Number>, fn: PdfFunction
			, extend: Vector.<Boolean> ): PdfShading
		{
			var sp: PdfShading = new PdfShading( writer );
			sp._shading = new PdfDictionary();
			sp._shadingType = 2;
			sp._shading.put( PdfName.SHADINGTYPE, new PdfNumber( sp._shadingType ) );
			sp.pdf_core::colorSpace = cs;
			sp._shading.put( PdfName.COORDS, new PdfArray( coords ) );

			if ( domain != null )
				sp._shading.put( PdfName.DOMAIN, new PdfArray( domain ) );
			sp._shading.put( PdfName.FUNCTION, fn.reference );

			if ( extend != null && ( extend[ 0 ] || extend[ 1 ] ) )
			{
				var array: PdfArray = new PdfArray( extend[ 0 ] ? PdfBoolean.PDF_TRUE : PdfBoolean.PDF_FALSE );
				array.add( extend[ 1 ] ? PdfBoolean.PDF_TRUE : PdfBoolean.PDF_FALSE );
				sp._shading.put( PdfName.EXTEND, array );
			}
			return sp;
		}

		public static function type3( writer: PdfWriter, cs: RGBColor, coords: Vector.<Number>, domain: Vector.<Number>, fn: PdfFunction
			, extend: Vector.<Boolean> ): PdfShading
		{
			var sp: PdfShading = type2( writer, cs, coords, domain, fn, extend );
			sp._shadingType = 3;
			sp._shading.put( PdfName.SHADINGTYPE, new PdfNumber( sp._shadingType ) );
			return sp;
		}
	}
}