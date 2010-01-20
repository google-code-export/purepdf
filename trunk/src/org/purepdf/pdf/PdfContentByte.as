package org.purepdf.pdf
{
	import flash.display.JointStyle;
	import flash.geom.Matrix;
	
	import it.sephiroth.utils.ObjectHash;
	
	import org.purepdf.colors.CMYKColor;
	import org.purepdf.colors.ExtendedColor;
	import org.purepdf.colors.GrayColor;
	import org.purepdf.colors.PatternColor;
	import org.purepdf.colors.RGBColor;
	import org.purepdf.colors.ShadingColor;
	import org.purepdf.colors.SpotColor;
	import org.purepdf.elements.Annotation;
	import org.purepdf.elements.Element;
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.elements.images.ImageElement;
	import org.purepdf.errors.IllegalPdfSyntaxError;
	import org.purepdf.errors.NonImplementatioError;
	import org.purepdf.errors.NullPointerError;
	import org.purepdf.errors.RuntimeError;
	import org.purepdf.pdf.fonts.BaseFont;
	import org.purepdf.pdf.interfaces.IPdfOCG;
	import org.purepdf.utils.Bytes;
	import org.purepdf.utils.StringUtils;
	import org.purepdf.utils.assertTrue;
	import org.purepdf.utils.pdf_core;

	public class PdfContentByte extends ObjectHash
	{
		public static const ALIGN_CENTER: int = Element.ALIGN_CENTER;
		public static const ALIGN_LEFT: int = Element.ALIGN_LEFT;
		public static const ALIGN_RIGHT: int = Element.ALIGN_RIGHT;
		public static const LINE_CAP_BUTT: int = 0;
		public static const LINE_CAP_PROJECTING_SQUARE: int = 2;
		public static const LINE_CAP_ROUND: int = 1;
		public static const LINE_JOIN_BEVEL: int = 2;
		public static const LINE_JOIN_MITER: int = 0;
		public static const LINE_JOIN_ROUND: int = 1;
		public static const TEXT_RENDER_MODE_CLIP: int = 7;
		public static const TEXT_RENDER_MODE_FILL: int = 0;
		public static const TEXT_RENDER_MODE_FILL_CLIP: int = 4;
		public static const TEXT_RENDER_MODE_FILL_STROKE: int = 2;
		public static const TEXT_RENDER_MODE_FILL_STROKE_CLIP: int = 6;
		public static const TEXT_RENDER_MODE_INVISIBLE: int = 3;
		public static const TEXT_RENDER_MODE_STROKE: int = 1;
		public static const TEXT_RENDER_MODE_STROKE_CLIP: int = 5;
		private static const unitRect: Vector.<Number> = Vector.<Number>( [ 0, 0, 0, 1, 1, 0, 1, 1 ] );
		protected var content: ByteBuffer = new ByteBuffer();
		protected var inText: Boolean = false;
		protected var layerDepth: Vector.<int>;
		protected var mcDepth: int = 0;
		protected var pdf: PdfDocument;

		protected var separator: int = '\n'.charCodeAt( 0 );
		protected var state: GraphicState = new GraphicState();
		protected var stateList: Vector.<GraphicState> = new Vector.<GraphicState>();
		protected var _writer: PdfWriter;
		
		use namespace pdf_core;

		public function PdfContentByte( $writer: PdfWriter )
		{
			_writer = $writer;
			pdf = _writer.pdfDocument;
		}
		
		public function get writer():PdfWriter
		{
			return _writer;
		}
		
		public function set writer( value: PdfWriter ): void
		{
			_writer = value;
		}

		public function duplicate(): PdfContentByte
		{
			return new PdfContentByte( _writer );
		}

		/**
		 * Adds an <CODE>ImageElement</CODE> to the page. The <CODE>ImageElement</CODE> must have
		 * absolute positioning.
		 *
		 * @param image the <CODE>ImageElement</CODE> object
		 * @see org.purepdf.elements.images.ImageElement
		 */
		public function addImage( image: ImageElement ): void
		{
			addImage1( image, false );
		}
		
		/**
		 * Sets the text rendering mode
		 */
		public function setTextRenderingMode( rendering: int ): void 
		{
			content.append_number( rendering ).append_string( " Tr" ).append_separator();
		}

		
		/**
		 * Change the word spacing
		 */
		public function setWordSpacing( wordSpace: Number ): void
		{
			state.wordSpace = wordSpace;
			content.append_number( wordSpace ).append_string( " Tw" ).append_separator();
		}

		/**
		 * Adds an <CODE>ImageElement</CODE> to the page. The <CODE>ImageElement</CODE> must have
		 * absolute positioning. The image can be placed inline.
		 * @param image the <CODE>ImageElement</CODE> object
		 * @param inlineImage <CODE>true</CODE> to place this image inline, <CODE>false</CODE> otherwise
		 *
		 * @see org.purepdf.elements.images.ImageElement
		 */
		public function addImage1( image: ImageElement, inlineImage: Boolean ): void
		{
			if ( !image.hasAbsoluteY )
				throw new ArgumentError( "image must have absolute position" );
			var matrix: Vector.<Number> = image.matrix;
			matrix[ ImageElement.CX ] = image.absoluteX - matrix[ ImageElement.CX ];
			matrix[ ImageElement.CY ] = image.absoluteY - matrix[ ImageElement.CY ];
			addImage2( image, matrix[ 0 ], matrix[ 1 ], matrix[ 2 ], matrix[ 3 ], matrix[ 4 ], matrix[ 5 ], inlineImage );
		}

		/**
		 * Adds an <CODE>ImageElement</CODE> to the page. The positioning of the <CODE>ImageElement</CODE>
		 * is done with the transformation matrix.
		 * To position an <CODE>ImageElement</CODE> at (x,y)
		 * use addImage(image, image_width, 0, 0, image_height, x, y)
		 *
		 * @param image the <CODE>ImageElement</CODE> object
		 * @param width
		 * @param b element of the matrix
		 * @param c element of the matrix
		 * @param height
		 * @param x
		 * @param y
		 * @param inlineImage
		 *
		 * @see org.purepdf.elements.images.ImageElement
		 */
		public function addImage2( image: ImageElement, width: Number, b: Number, c: Number, height: Number, x: Number, y: Number, inlineImage: Boolean ): void
		{
			if ( image.layer != null )
				beginLayer( image.layer );
			var h: Number;
			var w: Number;

			if ( image.isImgTemplate )
			{
				_writer.addDirectImageSimple( image );
				var template: PdfTemplate = image.templateData;
				w = template.width;
				h = template.height;
				
				addTemplate( template, width / w, b / w, c / h, height / h, x, y );
			}
			else
			{
				content.append( "q " );
				content.append_number( width ).append_char( ' ' );
				content.append_number( b ).append_char( ' ' );
				content.append_number( c ).append_char( ' ' );
				content.append_number( height ).append_char( ' ' );
				content.append_number( x ).append_char( ' ' );
				content.append_number( y ).append( " cm" );

				if ( inlineImage )
				{
					throw new NonImplementatioError();
				}
				else
				{
					var name: PdfName;
					var prs: PageResources = pageResources;
					var maskImage: ImageElement = image.imageMask;

					if ( maskImage != null )
					{
						name = _writer.addDirectImageSimple( maskImage );
						prs.addXObject( name, _writer.getImageReference( name ) );
					}
					name = _writer.addDirectImageSimple( image );
					name = prs.addXObject( name, _writer.getImageReference( name ) );
					content.append_char( ' ' ).append_bytes( name.getBytes() ).append( " Do Q" ).append_separator();
				}
			}

			if ( image.hasBorders() )
			{
				saveState();
				w = image.width;
				h = image.height;
				concatCTM( width / w, b / w, c / h, height / h, x, y );
				rectangle( image );
				restoreState();
			}

			if ( image.layer != null )
				endLayer();
			var annot: Annotation = image.annotation;

			if ( annot == null )
				return;
			var r: Vector.<Number> = new Vector.<Number>( unitRect.length );
			var k: int;

			for ( k = 0; k < unitRect.length; k += 2 )
			{
				r[ k ] = width * unitRect[ k ] + c * unitRect[ k + 1 ] + x;
				r[ k + 1 ] = b * unitRect[ k ] + height * unitRect[ k + 1 ] + y;
			}
			var llx: Number = r[ 0 ];
			var lly: Number = r[ 1 ];
			var urx: Number = llx;
			var ury: Number = lly;

			for ( k = 2; k < r.length; k += 2 )
			{
				llx = Math.min( llx, r[ k ] );
				lly = Math.min( lly, r[ k + 1 ] );
				urx = Math.max( urx, r[ k ] );
				ury = Math.max( ury, r[ k + 1 ] );
			}
			annot = new Annotation( annot );
			annot.setDimensions( llx, lly, urx, ury );
			var an: PdfAnnotation = PdfAnnotationsImp.convertAnnotation( _writer, annot, new RectangleElement( llx, lly, urx, ury ) );

			if ( an == null )
				return;
			throw new NonImplementatioError();
		}

		/**
		 * Adds an <CODE>ImageElement</CODE> to the page. The positioning of the <CODE>ImageElement</CODE>
		 * is done with the transformation matrix. To position an <CODE>ImageElement</CODE> at (x,y)
		 * use addImage(image, image_width, 0, 0, image_height, x, y).
		 *
		 * @param image the <CODE>ImageElement</CODE> object
		 * @param width
		 * @param b element of the transformation matrix
		 * @param c element of the transformation matrix
		 * @param height
		 * @param x
		 * @param y
		 *
		 * @see org.purepdf.elements.images.ImageElement
		 */
		public function addImage3( image: ImageElement, width: Number, b: Number, c: Number, height: Number, x: Number, y: Number ): void
		{
			addImage2( image, width, b, c, height, x, y, false );
		}

		/**
		 * Draws a partial ellipse inscribed within the rectangle x1,y1,x2,y2,
		 * starting at startAng degrees and covering extent degrees. Angles
		 * start with 0 to the right (+x) and increase counter-clockwise.
		 *
		 * @param x1 a corner of the enclosing rectangle
		 * @param y1 a corner of the enclosing rectangle
		 * @param x2 a corner of the enclosing rectangle
		 * @param y2 a corner of the enclosing rectangle
		 * @param startAng starting angle in degrees
		 * @param extent angle extent in degrees
		 */
		public function arc( x1: Number, y1: Number, x2: Number, y2: Number, startAng: Number, extent: Number ): void
		{
			var ar: Vector.<Vector.<Number>> = bezierArc( x1, y1, x2, y2, startAng, extent );

			if ( ar.length == 0 )
				return;

			var pt: Vector.<Number> = ar[ 0 ];

			moveTo( pt[ 0 ], pt[ 1 ] );

			for ( var k: int = 0; k < ar.length; ++k )
			{
				pt = ar[ k ];
				curveTo( pt[ 2 ], pt[ 3 ], pt[ 4 ], pt[ 5 ], pt[ 6 ], pt[ 7 ] );
			}
		}

		/**
		 * Begins a graphic block whose visibility is controlled by the <CODE>layer</CODE>.
		 * Blocks can be nested. Each block must be terminated by an {@link #endLayer()}.<p>
		 * Note that nested layers with {@link PdfLayer#addChild(PdfLayer)} only require a single
		 * call to this method and a single call to {@link #endLayer()}; all the nesting control
		 * is built in.
		 * @param layer the layer
		 * 
		 * @throws ArgumentError
		 */
		public function beginLayer( layer: IPdfOCG ): void
		{
			if(( layer is PdfLayer ) && PdfLayer( layer ).title != null )
				throw new ArgumentError("Title layer not allowed here");
			
			if( layerDepth == null )
				layerDepth = new Vector.<int>();
			
			if( layer is PdfLayerMembership )
			{
				layerDepth.push(1);
				beginLayer2(layer);
				return;
			}
			
			var n: int = 0;
			var la: PdfLayer = layer as PdfLayer;
			
			while( la != null )
			{
				if( la.title == null )
				{
					beginLayer2(la);
					++n;
				}
				
				la = la.parent;
			}
			
			layerDepth.push(n);
		}
		
		private function beginLayer2( layer: IPdfOCG ): void
		{
			var name: PdfName = _writer.addSimpleProperty( layer, layer.ref )[0] as PdfName;
			var prs: PageResources = pageResources;
			name = prs.addProperty( name, layer.ref );
			content.append_string("/OC ").append_bytes(name.getBytes()).append_string(" BDC").append_separator();
		}

		/**
		 * start writing text
		 */
		public function beginText(): void
		{
			if ( inText )
				throw new IllegalPdfSyntaxError( "Unbalanced begin and end text" );
			inText = true;
			state.xTLM = 0;
			state.yTLM = 0;
			content.append_string( "BT" ).append_separator();
		}

		/** Draws a circle. The endpoint will (x+r, y).
		 *
		 * @param x x center of circle
		 * @param y y center of circle
		 * @param r radius of circle
		 */
		public function circle( x: Number, y: Number, r: Number ): void
		{
			var b: Number = 0.5523;
			moveTo( x + r, y );
			curveTo( x + r, y + r * b, x + r * b, y + r, x, y + r );
			curveTo( x - r * b, y + r, x - r, y + r * b, x - r, y );
			curveTo( x - r, y - r * b, x - r * b, y - r, x, y - r );
			curveTo( x + r * b, y - r, x + r, y - r * b, x + r, y );
		}

		/**
		 * Modify the current clipping path by intersecting it with the current path, using the
		 * <CODE>even_odd</CODE> winding number rule to determine which regions lie inside the clipping
		 * path.
		 */
		public function clip( even_odd: Boolean=false ): void
		{
			content.append( even_odd ? "W*" : "W" ).append_separator();
		}

		/**
		 * Closes the current subpath by appending a straight line segment from the current point
		 * to the starting point of the subpath.
		 */
		public function closePath(): void
		{
			content.append( "h" ).append_separator();
		}

		/**
		 * Closes the path, fills it using the <CODE>even_odd</CODE> winding number rule to determine the region to fill and strokes it.
		 */
		public function closePathFillStroke( even_odd: Boolean=false ): void
		{
			content.append( even_odd ? "b*" : "b" ).append_separator();
		}

		/**
		 * Closes the path and strokes it.
		 */
		public function closePathStroke(): void
		{
			content.append( "s" ).append_separator();
		}

		/**
		 * Concatenate a matrix to the current matrix.
		 * @param a an element of the matrix
		 * @param b an element of the matrix
		 * @param c an element of the matrix
		 * @param d an element of the matrix
		 * @param e an element of the matrix
		 * @param f an element of the matrix
		 **/
		public function concatCTM( a: Number, b: Number, c: Number, d: Number, e: Number, f: Number ): void
		{
			content.append_number( a ).append( ' ' ).append_number( b ).append( ' ' ).append_number( c ).append( ' ' );
			content.append_number( d ).append( ' ' ).append_number( e ).append( ' ' ).append_number( f ).append( " cm" ).append_separator();
		}


		/**
		 * Create a new colored tiling pattern.
		 *
		 * @param width the width of the pattern
		 * @param height the height of the pattern
		 * @param xstep the desired horizontal spacing between pattern cells.
		 * May be either positive or negative, but not zero.
		 * @param ystep the desired vertical spacing between pattern cells.
		 * May be either positive or negative, but not zero.
		 * @return the <CODE>PdfPatternPainter</CODE> where the pattern will be created
		 */
		public function createPattern( width: Number, height: Number, xstep: Number=NaN, ystep: Number=NaN ): PdfPatternPainter
		{
			checkWriter();

			if ( isNaN( xstep ) || isNaN( ystep ) )
			{
				xstep = width;
				ystep = height;
			}

			if ( xstep == 0.0 || ystep == 0.0 )
				throw new RuntimeError( "xstep or ystep can not be zero" );

			var painter: PdfPatternPainter = new PdfPatternPainter( _writer );
			painter.width = width;
			painter.height = height;
			painter.xstep = xstep;
			painter.ystep = ystep;
			_writer.addSimplePattern( painter );
			return painter;
		}

		/**
		 * Create a new uncolored tiling pattern.
		 *
		 * @param width the width of the pattern
		 * @param height the height of the pattern
		 * @param xstep the desired horizontal spacing between pattern cells.
		 * May be either positive or negative, but not zero.
		 * @param ystep the desired vertical spacing between pattern cells.
		 * May be either positive or negative, but not zero.
		 * @param color the default color. Can be <CODE>null</CODE>
		 * @return the <CODE>PdfPatternPainter</CODE> where the pattern will be created
		 */
		public function createPatternColor( width: Number, height: Number, xstep: Number, ystep: Number, color: RGBColor ): PdfPatternPainter
		{
			checkWriter();

			if ( xstep == 0.0 || ystep == 0.0 )
				throw new RuntimeError( "xstep or ystep can not be zero" );

			var painter: PdfPatternPainter = new PdfPatternPainter( _writer, color );
			painter.width = width;
			painter.height = height;
			painter.xstep = xstep;
			painter.ystep = ystep;
			_writer.addSimplePattern( painter );
			return painter;
		}

		/**
		 * Appends a Bezier curve to the path, starting from the current point.
		 *
		 * @param       x1      x-coordinate of the first control point
		 * @param       y1      y-coordinate of the first control point
		 * @param       x2      x-coordinate of the second control point
		 * @param       y2      y-coordinate of the second control point
		 * @param       x3      x-coordinate of the ending point (= new current point)
		 * @param       y3      y-coordinate of the ending point (= new current point)
		 */
		public function curveTo( x1: Number, y1: Number, x2: Number, y2: Number, x3: Number, y3: Number ): void
		{
			content.append_number( x1 ).append_string( ' ' ).append_number( y1 ).append_string( ' ' ).append_number( x2 ).append_string( ' ' )
				.append_number( y2 ).append_string( ' ' ).append_number( x3 ).append_string( ' ' ).append_number( y3 ).append_string( " c" )
				.append_separator();
		}

		/**
		 * Draws an ellipse inscribed within the rectangle x1,y1,x2,y2.
		 *
		 * @param x1 a corner of the enclosing rectangle
		 * @param y1 a corner of the enclosing rectangle
		 * @param x2 a corner of the enclosing rectangle
		 * @param y2 a corner of the enclosing rectangle
		 */
		public function ellipse( x1: Number, y1: Number, x2: Number, y2: Number ): void
		{
			arc( x1, y1, x2, y2, 0, 360 );
		}

		public function endLayer(): void
		{
			var n: int = 1;

			if ( layerDepth != null && !( layerDepth.length == 0 ) )
			{
				n = layerDepth[ ( layerDepth.length - 1 ) ];
				layerDepth.splice( layerDepth.length - 1, 1 );
			}
			else
			{
				throw new IllegalPdfSyntaxError( "unbalanced layer operators" );
			}

			while ( n-- > 0 )
				content.append_string( "EMC" ).append_separator();
		}

		public function endText(): void
		{
			if ( !inText )
				throw new IllegalPdfSyntaxError( "Unbalanced begin and end text" );
			inText = false;
			content.append( "ET" ).append_separator();
		}

		/**
		 * fill the path
		 *
		 * @param even_odd	Determine how to draw the path (using the <CODE>even-odd</CODE> winding rule or not. Default is false)
		 */
		public function fill( even_odd: Boolean=false ): void
		{
			content.append( even_odd ? "f*" : "f" ).append_separator();
		}

		/**
		 * Fills the path using the <CODE>even_odd</CODE> winding number rule to determine the region to fill and strokes it.
		 */
		public function fillStroke( even_odd: Boolean=false ): void
		{
			content.append( even_odd ? "B*" : "B" ).append_separator();
		}

		/**
		 * Return the internal buffer
		 *
		 */
		public function getInternalBuffer(): ByteBuffer
		{
			return content;
		}

		public function lineTo( x: Number, y: Number ): void
		{
			content.append_number( x ).append( ' ' ).append_number( y ).append( " l" ).append_separator();
		}

		/**
		 * Moves to the start of the next line, offset from the start of the current line.
		 *
		 * @param       x           x-coordinate of the new current point
		 * @param       y           y-coordinate of the new current point
		 */
		public function moveText( x: Number, y: Number ): void
		{
			state.xTLM += x;
			state.yTLM += y;
			content.append_number( x ).append_char( ' ' ).append_number( y ).append( " Td" ).append_separator();
		}

		/**
		 * Move the current point omitting any connecting line segment.
		 */
		public function moveTo( x: Number, y: Number ): void
		{
			content.append_number( x ).append_string( ' ' ).append_number( y ).append_string( " m" ).append_separator();
		}
		
		/**
		 * Change the text matrix
		 */
		public function setTextMatrix( a: Number = 1, b: Number = 0, c: Number = 0, d: Number = 1, x: Number = 0, y: Number = 0 ): void
		{
			state.xTLM = x;
			state.yTLM = y;
			content.append_number(a).append_char(' ').append_number(b).append_int(32)
				.append_number(c).append_int(32).append_number(d).append_int(32)
				.append_number(x).append_int(32).append_number(y).append_string(" Tm")
				.append_separator();
		}


		/**
		 * Ends the path without filling or stroking it.
		 */
		public function newPath(): void
		{
			content.append( "n" ).append_separator();
		}

		public function get pageResources(): PageResources
		{
			return pdf.pageResources;
		}
		
		public function get pdfDocument(): PdfDocument
		{
			return pdf;
		}
		
		/**
		 * Get the x position of the text line matrix.
		 */
		public function get xTLM(): Number
		{
			return state.xTLM;
		}
		
		/**
		 * Get the y position of the text line matrix
		 */
		public function get yTLM(): Number
		{
			return state.yTLM;
		}


		/**
		 * Paint using a shading object
		 *
		 * @param value
		 */
		public function paintShading( value: PdfShading ): void
		{
			_writer.addSimpleShading( value );
			var prs: PageResources = pageResources;
			var name: PdfName = prs.addShading( value.shadingName, value.shadingReference );
			content.append_bytes( name.getBytes() ).append_string( " sh" ).append_separator();
			var details: ColorDetails = value.colorDetails;

			if ( details != null )
				prs.addColor( details.colorName, details.indirectReference );
		}

		/**
		 * Paints using a shading pattern.
		 */
		public function paintShadingPattern( shading: PdfShadingPattern ): void
		{
			paintShading( shading.shading );
		}

		/**
		 * Adds a rectangle to the current path<br>
		 * Either a RectangleElement or 4 Numbers are accepted as parameters.<br>
		 * Example:<br>
		 * <code>
		 * 		cb.setFillColor( RGBColor.BLACK );<br>
		 * 		cb.rectangle( 0, 0, 100, 100 );<br>
		 * 		cb.fill();<br>
		 * 		<br>
		 * 		var rect: RectangleElement = new RectangleElement( 0, 0, 100, 100 );<br>
		 * 		rect.setBorderSides( RectangleElement.ALL );<br>
		 * 		rect.setBorderWidth(5);<br>
		 * 		rect.setBackgroundColor( RGBColor.RED );<br>
		 * 		cb.rectangle( rect );<br>
		 * </code>
		 *
		 * @param       x       x-coordinate of the starting point
		 * @param       y       y-coordinate of the starting point
		 * @param       w       width
		 * @param       h       height
		 * 
		 * @see org.purepdf.elements.RectangleElement
		 */
		public function rectangle( ... params: Array ): void
		{
			if ( params[ 0 ] is RectangleElement )
			{
				setRectangle( params[ 0 ] );
			}
			else
			{
				var x: Number = params[ 0 ];
				var y: Number = params[ 1 ];
				var w: Number = params[ 2 ];
				var h: Number = params[ 3 ];
				content.append_number( x ).append_char( ' ' ).append_number( y ).append_char( ' ' ).append_number( w ).append_char( ' ' )
					.append_number( h ).append( " re" ).append_separator();
			}
		}

		/**
		 * Makes this <CODE>PdfContentByte</CODE> empty.
		 * Calls <code>reset( true )</code>
		 */
		public function reset( value: Boolean=true ): void
		{
			content.reset();

			if ( value )
				sanityCheck();
			state = new GraphicState();
		}

		public function resetFill(): void
		{
			content.append( "0 g" ).append_separator();
		}

		public function resetStroke(): void
		{
			content.append( "0 G" ).append_separator();
		}

		/**
		 * Restores the graphic state. <CODE>saveState</CODE> and
		 * <CODE>restoreState</CODE> must be balanced.
		 */
		public function restoreState(): void
		{
			content.append( "Q" ).append_separator();
			var idx: int = stateList.length - 1;

			if ( idx < 0 )
				throw new IllegalPdfSyntaxError("nothing to restore");
			state = stateList[ idx ];
			stateList.splice( idx, 1 );
		}

		/**
		 * Saves the graphic state. <CODE>saveState</CODE> and
		 * <CODE>restoreState</CODE> must be balanced.
		 */
		public function saveState(): void
		{
			content.append( "q" ).append_separator();
			stateList.push( GraphicState.create( state ) );
		}

		/**
		 * Changes the current color for filling paths (device dependent colors!).
		 * <P>
		 * Sets the color space to <B>DeviceCMYK</B> (or the <B>DefaultCMYK</B> color space),
		 * and sets the color to use for filling paths.</P>
		 * <P>
		 * Following the PDF manual, each operand must be a number between 0 (no ink) and
		 * 1 (maximum ink).</P>
		 *
		 * @param   cyan    the intensity of cyan. A value between 0 and 1
		 * @param   magenta the intensity of magenta. A value between 0 and 1
		 * @param   yellow  the intensity of yellow. A value between 0 and 1
		 * @param   black   the intensity of black. A value between 0 and 1
		 */

		public function setCMYKFillColor( cyan: Number, magenta: Number, yellow: Number, black: Number ): void
		{
			helperCMYK( cyan, magenta, yellow, black );
			content.append_string( " k" ).append_separator();
		}

		/**
		 * <p>Sets the color space to <B>DeviceCMYK</B> (or the <B>DefaultCMYK</B> color space),
		 * and sets the color to use for stroking paths.</p>
		 * <p>Each value must be between 0 and 1.</p>
		 *
		 * @param   cyan
		 * @param   magenta
		 * @param   yellow
		 * @param   black
		 */

		public function setCMYKStrokeColor( cyan: Number, magenta: Number, yellow: Number, black: Number ): void
		{
			helperCMYK( cyan, magenta, yellow, black );
			content.append_string( " K" ).append_separator();
		}

		/**
		 * Sets the fill color
		 * @param color the color
		 */
		public function setFillColor( color: RGBColor ): void
		{
			var type: int = ExtendedColor.getType( color );

			switch ( type )
			{
				case ExtendedColor.TYPE_GRAY:
					setGrayFill( GrayColor( color ).gray );
					break;

				case ExtendedColor.TYPE_CMYK:
					var cmyk: CMYKColor = CMYKColor( color );
					setCMYKFillColor( cmyk.cyan, cmyk.magenta, cmyk.yellow, cmyk.black );
					break;

				case ExtendedColor.TYPE_SEPARATION:
					var spot: SpotColor = SpotColor( color );
					setSpotFillColor( spot.pdfSpotColor, spot.tint );
					break;

				case ExtendedColor.TYPE_PATTERN:
					var pat: PatternColor = PatternColor( color );
					setPatternFill( pat.painter );
					break;

				case ExtendedColor.TYPE_SHADING:
					var shading: ShadingColor = ShadingColor( color );
					setShadingFill( shading.shadingPattern );
					break;

				default:
					setRGBFillColor( color.red, color.green, color.blue );
					break;
			}
		}

		/**
		 * Apply the graphic state
		 * @param gstate	The graphic state
		 */
		public function setGState( gstate: PdfGState ): void
		{
			var obj: Vector.<PdfObject> = _writer.addSimpleExtGState( gstate );
			var prs: PageResources = pageResources;
			var name: PdfName = prs.addExtGState( PdfName( obj[ 0 ] ), PdfIndirectReference( obj[ 1 ] ) );
			content.append_bytes( name.getBytes() ).append( " gs" ).append_separator();
		}

		public function setGrayFill( gray: Number ): void
		{
			content.append_number( gray ).append( " g" ).append_separator();
		}

		public function setGrayStroke( gray: Number ): void
		{
			content.append_number( gray ).append( " G" ).append_separator();
		}

		/**
		 * <p>Changes the <VAR>Line cap style</VAR></p>
		 * <p>The line cap style specifies the shape to be used at the end of open subpaths
		 * when they are stroked.</p>
		 * @param	style
		 * @see	PdfContentByte
		 */
		public function setLineCap( style: int ): void
		{
			if ( style >= 0 && style <= 2 )
			{
				content.append_number( style );
				content.append_string( " J" ).append_separator();
			}
		}

		/**
		 * Changes the value of the line dash pattern.
		 */
		public function setLineDash( phase: Number ): void
		{
			content.append_string( "[] " ).append_number( phase ).append_string( " d" ).append_separator();
		}

		/**
		 * Changes the value of the line dash pattern.<br />
		 * The line dash pattern controls the pattern of dashes and gaps used to stroke paths.
		 *
		 * @param       phase       the value of the phase
		 * @param       unitsOn     the number of units that must be 'on' (equals the number of units that must be 'off').
		 */

		public function setLineDash2( unitsOn: Number, phase: Number ): void
		{
			content.append_string( "[" ).append_number( unitsOn ).append_string( "] " ).append_number( phase ).append_string( " d" )
				.append_separator();
		}

		/**
		 * Changes the value of the line dash pattern<br />
		 * The line dash pattern controls the pattern of dashes and gaps used to stroke paths.
		 *
		 * @param       phase       the value of the phase
		 * @param       unitsOn     the number of units that must be 'on'
		 * @param       unitsOff    the number of units that must be 'off'
		 */

		public function setLineDash3( unitsOn: Number, unitsOff: Number, phase: Number ): void
		{
			content.append_string( "[" ).append_number( unitsOn ).append_char( ' ' ).append_number( unitsOff ).append_string( "] " )
				.append_number( phase ).append_string( " d" ).append_separator();
		}

		/**
		 * Changes the value of the line dash pattern<br />
		 * The line dash pattern controls the pattern of dashes and gaps used to stroke paths.
		 * It is specified by an array and a phase. The array specifies the length
		 * of the alternating dashes and gaps. The phase specifies the distance into the dash
		 * pattern to start the dash
		 *
		 * @param       array       length of the alternating dashes and gaps
		 * @param       phase       the value of the phase
		 */

		public function setLineDash4( array: Vector.<Number>, phase: Number ): void
		{
			content.append_string( "[" );

			for ( var i: int = 0; i < array.length; i++ )
			{
				content.append_number( array[ i ] );

				if ( i < array.length - 1 )
					content.append_char( ' ' );
			}
			content.append_string( "] " ).append_number( phase ).append_string( " d" ).append_separator();
		}

		/**
		 * <p>Changes the Line join style</p>
		 * <p>The line join style specifies the shape to be used at the corners of paths
		 * that are stroked.</p>
		 * <p>Allowed values are JointStyle.MITER (Miter joins), JointStyle.ROUND (Round joins) and JointStyle.BEVEL (Bevel joins).</p>
		 *
		 * @param joint
		 * @see	flash.diplay.JointStyle
		 */
		public function setLineJoin( joint: String ): void
		{
			var style: int;

			switch ( joint )
			{
				case JointStyle.BEVEL:
					style = 2;
					break;
				case JointStyle.MITER:
					style = 0;
					break;
				default:
					style = 1;
					break;
			}
			content.append( style ).append( " j" ).append_separator();
		}

		/**
		 * Changes the line width.
		 * @param	w
		 */
		public function setLineWidth( w: Number ): void
		{
			content.append_number( w ).append_string( " w" ).append_separator();
		}

		/**
		 * Output a String directly to the content
		 *
		 * @param value	The content to append
		 */
		public function setLiteral( value: String ): void
		{
			content.append_string( value );
		}

		/**
		 * Changes the Miter limit.
		 *
		 * @param miterLimit
		 */
		public function setMiterLimit( miterLimit: Number ): void
		{
			if ( miterLimit > 1 )
				content.append_number( miterLimit ).append( " M" ).append_separator();
		}

		/**
		 * Set the fill color to a pattern
		 */
		public function setPatternFill( p: PdfPatternPainter ): void
		{
			if ( p.is_stencil )
			{
				setPatternFill2( p, p.defaultColor );
				return;
			}
			setPattern( p, true );
		}

		/**
		 * Set the fill color of an uncolored pattern
		 */
		public function setPatternFill2( p: PdfPatternPainter, color: RGBColor ): void
		{
			if ( ExtendedColor.getType( color ) == ExtendedColor.TYPE_SEPARATION )
				setPatternFill3( p, color, SpotColor( color ).tint );
			else
				setPatternFill3( p, color, 0 );
		}

		/**
		 * Set the fill color to an uncolored pattern
		 */
		public function setPatternFill3( p: PdfPatternPainter, color: RGBColor, tint: Number ): void
		{
			checkWriter();

			if ( !p.is_stencil )
				throw new RuntimeError( "an uncolored pattern was expected" );

			setPattern3( p, color, tint, true );
		}

		/**
		 * Sets the stroke color to a pattern
		 */
		public function setPatternStroke( p: PdfPatternPainter ): void
		{
			if ( p.is_stencil )
			{
				setPatternStroke2( p, p.defaultColor );
				return;
			}
			setPattern( p, false );
		}

		/**
		 * Sets the stroke color to an uncolored pattern
		 */
		public function setPatternStroke2( p: PdfPatternPainter, color: RGBColor ): void
		{
			if ( ExtendedColor.getType( color ) == ExtendedColor.TYPE_SEPARATION )
				setPatternStroke3( p, color, SpotColor( color ).tint );
			else
				setPatternStroke3( p, color, 0 );
		}

		/**
		 * Sets the stroke color to an uncolored pattern
		 */
		public function setPatternStroke3( p: PdfPatternPainter, color: RGBColor, tint: Number ): void
		{
			checkWriter();

			if ( !p.is_stencil )
				throw new RuntimeError( "an uncolored pattern was expected" );
			setPattern3( p, color, tint, false );
		}

		/**
		 * Changes the current color for filling paths<br />
		 * Sets the color space to DeviceRGB
		 *
		 * @param red
		 * @param green
		 * @param blue
		 */
		public function setRGBFillColor( red: int, green: int, blue: int ): void
		{
			helperRGB( Number( red & 0xFF ) / 0xFF, Number( green & 0xFF ) / 0xFF, Number( blue & 0xFF ) / 0xFF );
			content.append_string( " rg" ).append_separator();
		}


		public function setRGBStrokeColor( red: int, green: int, blue: int ): void
		{
			helperRGB( Number( red & 0xFF ) / 0xFF, Number( green & 0xFF ) / 0xFF, Number( blue & 0xFF ) / 0xFF );
			content.append( " RG" ).append_separator();
		}

		/**
		 * Sets the shading fill pattern.
		 */
		public function setShadingFill( shading: PdfShadingPattern ): void
		{
			setShadingFillOrStroke( shading, true );
		}

		/**
		 * Sets the shading stroke pattern
		 * @param shading the shading pattern
		 */
		public function setShadingStroke( shading: PdfShadingPattern ): void
		{
			setShadingFillOrStroke( shading, false );
		}

		/**
		 * Sets the fill color to a spot color.
		 *
		 * @param sp the spot color
		 * @param tint the tint for the spot color. ( 0 = no color, 1 = 100% color )
		 *
		 */
		public function setSpotFillColor( sp: PdfSpotColor, tint: Number ): void
		{
			setSpotColor( sp, tint, true );
		}

		/**
		 * Sets the stroke color to a spot color
		 */
		public function setSpotStrokeColor( sp: PdfSpotColor, tint: Number ): void
		{
			setSpotColor( sp, tint, false );
		}

		public function setStrokeColor( color: RGBColor ): void
		{
			var type: int = ExtendedColor.getType( color );

			switch ( type )
			{
				case ExtendedColor.TYPE_GRAY:
					setGrayStroke( GrayColor( color ).gray );
					break;
				case ExtendedColor.TYPE_CMYK:
					var cmyk: CMYKColor = CMYKColor( color );
					setCMYKStrokeColor( cmyk.cyan, cmyk.magenta, cmyk.yellow, cmyk.black );
					break;
				case ExtendedColor.TYPE_SEPARATION:
					var spot: SpotColor = SpotColor( color );
					setSpotStrokeColor( spot.pdfSpotColor, spot.tint );
					break;
				case ExtendedColor.TYPE_PATTERN:
					var pat: PatternColor = PatternColor( color );
					setPatternStroke( pat.painter );
					break;
				case ExtendedColor.TYPE_SHADING:
					var shading: ShadingColor = ShadingColor( color );
					setShadingStroke( shading.shadingPattern );
					break;
				default:
					setRGBStrokeColor( color.red, color.green, color.blue );
					break;
			}
		}

		/**
		 * Concatenates the transformation to the current matrix
		 */
		public function setTransform( m: Matrix ): void
		{
			content.append_number( m.a ).append_char( ' ' ).append_number( m.b ).append_char( ' ' ).append_number( m.c ).append_char( ' ' );
			content.append_number( m.d ).append_char( ' ' ).append_number( m.tx ).append_char( ' ' ).append_number( m.ty ).append( " cm" )
				.append_separator();
		}

		public function size(): uint
		{
			return content.size();
		}

		/**
		 * Strokes the path.
		 */
		public function stroke(): void
		{
			content.append( "S" ).append_separator();
		}

		public function toPdf( $writer: PdfWriter ): Bytes
		{
			sanityCheck();
			return content.toByteArray();
		}

		public function toString(): String
		{
			return content.toString();
		}

		/**
		 * Adds a variable width border to the current path.
		 * Only use if isUseVariableBorders = true
		 * @param rect a <CODE>RectangleElement</CODE>
		 */
		public function variableRectangle( rect: RectangleElement ): void
		{
			var t: Number = rect.getTop();
			var b: Number = rect.getBottom();
			var r: Number = rect.getRight();
			var l: Number = rect.getLeft();
			var wt: Number = rect.borderWidthTop;
			var wb: Number = rect.borderWidthBottom;
			var wr: Number = rect.borderWidthRight;
			var wl: Number = rect.borderWidthLeft;
			var ct: RGBColor = rect.borderColorTop;
			var cb: RGBColor = rect.borderColorBottom;
			var cr: RGBColor = rect.borderColorRight;
			var cl: RGBColor = rect.borderColorLeft;
			saveState();
			setLineCap( 0 );
			setLineJoin( JointStyle.MITER );
			var clw: Number = 0;
			var cdef: Boolean = false;
			var ccol: RGBColor = null;
			var cdefi: Boolean = false;
			var cfil: RGBColor = null;
			var bt: Boolean, bb: Boolean;

			// draw top
			if ( wt > 0 )
			{
				setLineWidth( clw = wt );
				cdef = true;

				if ( ct == null )
					resetStroke();
				else
					setStrokeColor( ct );
				ccol = ct;
				moveTo( l, t - wt / 2 );
				lineTo( r, t - wt / 2 );
				stroke();
			}

			// Draw bottom
			if ( wb > 0 )
			{
				if ( wb != clw )
					setLineWidth( clw = wb );

				if ( !cdef || !compareColors( ccol, cb ) )
				{
					cdef = true;

					if ( cb == null )
						resetStroke();
					else
						setStrokeColor( cb );
					ccol = cb;
				}
				moveTo( r, b + wb / 2 );
				lineTo( l, b + wb / 2 );
				stroke();
			}

			// Draw right
			if ( wr > 0 )
			{
				if ( wr != clw )
					setLineWidth( clw = wr );

				if ( !cdef || !compareColors( ccol, cr ) )
				{
					cdef = true;

					if ( cr == null )
						resetStroke();
					else
						setStrokeColor( cr );
					ccol = cr;
				}
				bt = compareColors( ct, cr );
				bb = compareColors( cb, cr );
				moveTo( r - wr / 2, bt ? t : t - wt );
				lineTo( r - wr / 2, bb ? b : b + wb );
				stroke();

				if ( !bt || !bb )
				{
					cdefi = true;

					if ( cr == null )
						resetFill();
					else
						setFillColor( cr );
					cfil = cr;

					if ( !bt )
					{
						moveTo( r, t );
						lineTo( r, t - wt );
						lineTo( r - wr, t - wt );
						fill();
					}

					if ( !bb )
					{
						moveTo( r, b );
						lineTo( r, b + wb );
						lineTo( r - wr, b + wb );
						fill();
					}
				}
			}

			// Draw Left
			if ( wl > 0 )
			{
				if ( wl != clw )
					setLineWidth( wl );

				if ( !cdef || !compareColors( ccol, cl ) )
				{
					if ( cl == null )
						resetStroke();
					else
						setStrokeColor( cl );
				}
				bt = compareColors( ct, cl );
				bb = compareColors( cb, cl );
				moveTo( l + wl / 2, bt ? t : t - wt );
				lineTo( l + wl / 2, bb ? b : b + wb );
				stroke();

				if ( !bt || !bb )
				{
					if ( !cdefi || !compareColors( cfil, cl ) )
					{
						if ( cl == null )
							resetFill();
						else
							setFillColor( cl );
					}

					if ( !bt )
					{
						moveTo( l, t );
						lineTo( l, t - wt );
						lineTo( l + wl, t - wt );
						fill();
					}

					if ( !bb )
					{
						moveTo( l, b );
						lineTo( l, b + wb );
						lineTo( l + wl, b + wb );
						fill();
					}
				}
			}
			restoreState();
		}

		protected function checkWriter(): void
		{
			assertTrue( _writer != null, "The writer is null" );
		}

		/**
		 * Checks for any error in mismatched save/restore state, begin/end text,
		 * begin/end layer, or begin/end marked content sequence.
		 */
		protected function sanityCheck(): void
		{
			if ( mcDepth != 0 )
			{
				throw Error( "unbalanced marked content operators" );
			}

			if ( inText )
			{
				throw new IllegalPdfSyntaxError( "unbalanced begin and end text operators" );
			}

			if ( layerDepth != null && !( layerDepth.length == 0 ) )
			{
				throw new IllegalPdfSyntaxError( "unbalanced layer operators" );
			}

			if ( !( stateList.length == 0 ) )
			{
				throw new IllegalPdfSyntaxError( "unbalanced save and restore state operators" );
			}
		}

		pdf_core function setRectangle( rectangle: RectangleElement ): void
		{
			var x1: Number = rectangle.getLeft();
			var y1: Number = rectangle.getBottom();
			var x2: Number = rectangle.getRight();
			var y2: Number = rectangle.getTop();
			var background: RGBColor = rectangle.backgroundColor;

			if ( background != null )
			{
				saveState();
				setFillColor( background );
				this.rectangle( x1, y1, x2 - x1, y2 - y1 );
				fill();
				restoreState();
			}

			if ( !rectangle.hasBorders() )
				return;

			if ( rectangle.isUseVariableBorders() )
			{
				variableRectangle( rectangle );
			}
			else
			{
				if ( rectangle.borderWidth != RectangleElement.UNDEFINED )
					setLineWidth( rectangle.borderWidth );
				var color: RGBColor = rectangle.borderColor;

				if ( color != null )
					setStrokeColor( color );

				if ( rectangle.hasBorder( RectangleElement.ALL ) )
				{
					this.rectangle( x1, y1, x2 - x1, y2 - y1 );
				}
				else
				{
					if ( rectangle.hasBorder( RectangleElement.RIGHT ) )
					{
						moveTo( x2, y1 );
						lineTo( x2, y2 );
					}

					if ( rectangle.hasBorder( RectangleElement.LEFT ) )
					{
						moveTo( x1, y1 );
						lineTo( x1, y2 );
					}

					if ( rectangle.hasBorder( RectangleElement.BOTTOM ) )
					{
						moveTo( x1, y1 );
						lineTo( x2, y1 );
					}

					if ( rectangle.hasBorder( RectangleElement.TOP ) )
					{
						moveTo( x1, y2 );
						lineTo( x2, y2 );
					}
				}
				stroke();

				if ( color != null )
					resetStroke();
			}
		}

		private function compareColors( c1: RGBColor, c2: RGBColor ): Boolean
		{
			if ( c1 == null && c2 == null )
				return true;

			if ( c1 == null || c2 == null )
				return false;

			if ( c1 is ExtendedColor )
				return c1.equals( c2 );
			return c2.equals( c1 );
		}

		/**
		 * Helper to validate and write the CMYK color components.
		 */
		private function helperCMYK( cyan: Number, magenta: Number, yellow: Number, black: Number ): void
		{
			if ( cyan < 0 )
				cyan = 0.0;
			else if ( cyan > 1.0 )
				cyan = 1.0;

			if ( magenta < 0 )
				magenta = 0.0;
			else if ( magenta > 1.0 )
				magenta = 1.0;

			if ( yellow < 0 )
				yellow = 0.0;
			else if ( yellow > 1.0 )
				yellow = 1.0;

			if ( black < 0 )
				black = 0.0;
			else if ( black > 1.0 )
				black = 1.0;
			content.append_number( cyan ).append_char( ' ' ).append_number( magenta ).append_char( ' ' ).append_number( yellow ).append_char( ' ' )
				.append_number( black );
		}

		private function helperRGB( red: Number, green: Number, blue: Number ): void
		{
			if ( red < 0 )
				red = 0.0;
			else if ( red > 1.0 )
				red = 1.0;

			if ( green < 0 )
				green = 0.0;
			else if ( green > 1.0 )
				green = 1.0;

			if ( blue < 0 )
				blue = 0.0;
			else if ( blue > 1.0 )
				blue = 1.0;
			content.append_number( red ).append( ' ' ).append_number( green ).append( ' ' ).append_number( blue );
		}

		/**
		 * Outputs the color values to the content.
		 */
		private function outputColorNumbers( color: RGBColor, tint: Number ): void
		{

			var type: int = ExtendedColor.getType( color );

			switch ( type )
			{
				case ExtendedColor.TYPE_RGB:
					content.append_number( Number( color.red ) / 0xFF );
					content.append_char( ' ' );
					content.append_number( Number( color.green ) / 0xFF );
					content.append_char( ' ' );
					content.append_number( Number( color.blue ) / 0xFF );
					break;

				case ExtendedColor.TYPE_GRAY:
					content.append_number( GrayColor( color ).gray );
					break;

				case ExtendedColor.TYPE_CMYK:
					var cmyk: CMYKColor = CMYKColor( color );
					content.append_number( cmyk.cyan ).append_char( ' ' ).append_number( cmyk.magenta );
					content.append_char( ' ' ).append_number( cmyk.yellow ).append_char( ' ' ).append_number( cmyk.black );
					break;

				case ExtendedColor.TYPE_SEPARATION:
					content.append_number( tint );
					break;

				default:
					throw new RuntimeError( "invalid color type" );
			}
		}


		private function setPattern( p: PdfPatternPainter, fill: Boolean ): void
		{
			checkWriter();
			var psr: PageResources = pageResources;
			var name: PdfName = _writer.addSimplePattern( p );
			name = psr.addPattern( name, p.indirectReference );
			content.append_bytes( PdfName.PATTERN.getBytes() ).append_string( fill ? " cs " : " CS " ).append_bytes( name.getBytes() )
				.append_string( fill ? " scn" : " SCN" ).append_separator();
		}

		private function setPattern3( p: PdfPatternPainter, color: RGBColor, tint: Number, fill: Boolean ): void
		{
			var psr: PageResources = pageResources;
			var name: PdfName = _writer.addSimplePattern( p );
			name = psr.addPattern( name, p.indirectReference );
			var cDetail: ColorDetails = _writer.addSimplePatternColorSpace( color );
			var cName: PdfName = psr.addColor( cDetail.colorName, cDetail.indirectReference );
			content.append_bytes( cName.getBytes() ).append_string( fill ? " cs" : " CS" ).append_separator();
			outputColorNumbers( color, tint );
			content.append_char( ' ' ).append_bytes( name.getBytes() ).append_string( fill ? " scn" : " SCN" ).append_separator();
		}

		private function setShadingFillOrStroke( shading: PdfShadingPattern, fill: Boolean ): void
		{
			_writer.addSimpleShadingPattern( shading );
			var prs: PageResources = pageResources;
			var name: PdfName = prs.addPattern( shading.patternName, shading.patternReference );
			content.append_bytes( PdfName.PATTERN.getBytes() ).append_string( fill ? " cs " : " CS " ).append_bytes( name.getBytes() )
				.append_string( fill ? " scn" : " SCN" ).append_separator();
			var details: ColorDetails = shading.colorDetails;

			if ( details != null )
				prs.addColor( details.colorName, details.indirectReference );
		}

		private function setSpotColor( sp: PdfSpotColor, tint: Number, fill: Boolean ): void
		{
			checkWriter();
			state.colorDetails = _writer.addSimpleSpotColor( sp );
			var prs: PageResources = pageResources;
			var name: PdfName = state.colorDetails.colorName;
			name = prs.addColor( name, state.colorDetails.indirectReference );

			content.append_bytes( name.getBytes() ).append_string( fill ? " cs " : " CS " ).append_number( tint ).append_string( fill
				? " scn" : " SCN" ).append_separator();
		}

		/**
		 * Set the font and the size for the subsequent text writing
		 */
		public function setFontAndSize( bf: BaseFont, size: Number ): void
		{
			checkWriter();
			if( size < 0.0001 && size > -0.0001 )
				throw new ArgumentError( "font size too small");
			state.size = size;
			state.fontDetails = _writer.addSimpleFont( bf );
			var prs: PageResources = pageResources;
			var name: PdfName = state.fontDetails.fontName;
			name = prs.addFont( name, state.fontDetails.indirectReference );
			content.append_bytes( name.getBytes() ).append_char(' ').append_number(size).append_string(" Tf").append_separator();
		}
		
		/**
		 * This allows to write text in subscript or superscript mode
		 */
		public function setTextRise( rise: Number ): void
		{
			content.append_number( rise ).append_string( " Ts" ).append_separator();
		}
		
		/**
		 * Get the current character spacing
		 */
		public function getCharacterSpacing(): Number
		{
			return state.charSpace;
		}

		/**
		 * Change the character spacing
		 */
		public function setCharacterSpacing( charSpace: Number ): void
		{
			state.charSpace = charSpace;
			content.append_number( charSpace ).append_string( " Tc" ).append_separator();
		}
		
		
		/**
		 * Shows the text
		 */
		public function showText( text: String ): void
		{
			showText2( text );
			content.append_string( "Tj" ).append_separator();
		}
		
		/**
		 * Shows text aligned (left, center or right) with rotation.
		 * @param alignment the alignment can be ALIGN_CENTER, ALIGN_RIGHT or ALIGN_LEFT
		 * @param text the text to show
		 * @param x the x position
		 * @param y the y  position
		 * @param rotation the rotation in degrees
		 */
		public function showTextAligned( alignment: int, text: String, x: Number, y: Number, rotation: Number, kerned: Boolean = false ): void
		{
			if( state.fontDetails == null )
				throw new NullPointerError("set font and size before write text");
			
			if( rotation == 0 )
			{
				switch( alignment )
				{
					case ALIGN_CENTER:
						x -= getEffectiveStringWidth( text, kerned ) / 2;
						break;
					
					case ALIGN_RIGHT:
						x -= getEffectiveStringWidth( text, kerned );
						break;
				}
				setTextMatrix( 1, 0, 0, 1, x, y );
				if( kerned )
					showTextKerned( text );
				else
					showText( text );
			} else 
			{
				var alpha: Number = rotation * Math.PI / 180.0;
				var cos: Number = Math.cos(alpha);
				var sin: Number = Math.sin(alpha);
				var len: Number;
				
				switch( alignment )
				{
					case ALIGN_CENTER:
						len = getEffectiveStringWidth(text, kerned) / 2;
						x -=  len * cos;
						y -=  len * sin;
						break;
					
					case ALIGN_RIGHT:
						len = getEffectiveStringWidth(text, kerned);
						x -=  len * cos;
						y -=  len * sin;
						break;
				}
				
				setTextMatrix(cos, sin, -sin, cos, x, y);
				if( kerned )
					showTextKerned( text );
				else
					showText( text );
				setTextMatrix(1, 0, 0, 1, 0, 0);
			}
		}
		
		/**
		 * Shows the text kerned
		 */
		public function showTextKerned( text: String ): void
		{
			if( state.fontDetails == null )
				throw new NullPointerError("font and size must be set before write text");
			var bf: BaseFont = state.fontDetails.baseFont;
			if( bf.hasKernPairs() )
				showTextArray( getKernArray(text, bf) );
			else
				showText( text );
		}
		
		/**
		 * Show an array of kerned text
		 */
		public function showTextArray( text: PdfTextArray ): void
		{
			if( state.fontDetails == null )
				throw new NullPointerError("font and size must be set before write text");
			content.append_string("[");
			var arrayList: Vector.<Object> = text.arrayList;
			var lastWasNumber: Boolean = false;
			for( var k: int = 0; k < arrayList.length; ++k )
			{
				var obj: Object = arrayList[k];
				if( obj is String )
				{
					showText2( String( obj ) );
					lastWasNumber = false;
				} else 
				{
					if( lastWasNumber )
						content.append_char(' ');
					else
						lastWasNumber = true;
					content.append_number( Number( obj ) );
				}
			}
			content.append_string( "]TJ" ).append_separator();
		}		
		
		/**
		 * Constructs a kern array for a text in a certain font
		 * @param text the text
		 * @param font the font
		 * @return a PdfTextArray
		 */
		internal static function getKernArray( text: String, font: BaseFont ): PdfTextArray
		{
			var pa: PdfTextArray = new PdfTextArray();
			var acc: String = "";
			var len: int = text.length - 1;
			var c: Vector.<int> = StringUtils.toCharArray( text );
			if( len >= 0 )
				StringUtils.appendChars( acc, c, 0, 1 );
			
			for( var k: int = 0; k < len; ++k )
			{
				var c2: int = c[k + 1];
				var kern: int = font.getKerning( c[k], c2 );
				if( kern == 0 )
					acc += String.fromCharCode( c2 & 0xff );
				else 
				{
					pa.addString( acc );
					acc = "";
					StringUtils.appendChars( acc, c, k+1, 1 );
					pa.addNumber( -kern );
				}
			}
			pa.addString( acc );
			return pa;
		}
		
		/**
		 * Computes the width of the given string taking in account
		 * the current values of "Character spacing", "Word Spacing"
		 * and "Horizontal Scaling"
		 */
		public function getEffectiveStringWidth( text: String, kerned: Boolean = false ): Number
		{
			var bf: BaseFont = state.fontDetails.baseFont;
			var w: Number;
			
			if( kerned )
				w = bf.getWidthPointKerned( text, state.size );
			else
				w = bf.getWidthPoint( text, state.size );
			
			if( state.charSpace != 0.0 && text.length > 1 )
				w += state.charSpace * (text.length -1);
			
			var ft: int = bf.fontType;
			if( state.wordSpace != 0 && (ft == BaseFont.FONT_TYPE_T1 || ft == BaseFont.FONT_TYPE_TT || ft == BaseFont.FONT_TYPE_T3)) 
			{
				for ( var i: int = 0; i < (text.length -1); i++)
				{
					if( text.charCodeAt(i) == 32 )
						w += state.wordSpace;
				}
			}
			
			if( state.scale != 100.0 )
				w = (w * state.scale) / 100.0;
			
			return w;
		}

		/**
		 * Creates a new template. This template can be included in this
		 * PdfContentByte or in another template. Templates are written only when document
		 * is closed.
		 */
		public function createTemplate( width: Number, height: Number, forcedName: PdfName  = null ): PdfTemplate
		{
			checkWriter();
			var template: PdfTemplate = new PdfTemplate( _writer );
			template.width = width;
			template.height = height;
			_writer.addDirectTemplateSimple( template, forcedName );
			return template;
		}
		
		/**
		 * Adds a template to this content
		 *
		 * @param template the template
		 * @param a element of the matrix
		 * @param b element matrix
		 * @param c element matrix
		 * @param d element matrix
		 * @param tx element matrix
		 * @param ty element matrix
		 * 
		 * @see flash.geom.Matrix
		 */
		public function addTemplate( template: PdfTemplate, a: Number = 1, b: Number = 0, c: Number = 0, d: Number = 1, tx: Number = 0, ty: Number = 0 ): void
		{
			checkWriter();
			checkNoPattern( template );
			var name: PdfName = _writer.addDirectTemplateSimple( template, null );
			var prs: PageResources = pageResources;
			name = prs.addXObject( name, template.indirectReference );
			content.append_string("q ");
			content.append_number(a).append_char(' ');
			content.append_number(b).append_char(' ');
			content.append_number(c).append_char(' ');
			content.append_number(d).append_char(' ');
			content.append_number(tx).append_char(' ');
			content.append_number(ty).append_string(" cm ");
			content.append_bytes( name.getBytes() ).append_string(" Do Q").append_separator();
		}
		
		/** 
		 * Check if the template is a pattern. In that case
		 * throws an Error
		 * 
		 * @throws RuntimeError
		 */
		internal function checkNoPattern( t: PdfTemplate ): void
		{
			if( t.type == PdfTemplate.TYPE_PATTERN )
				throw new RuntimeError("template was expected");
		}
		
		public function addAnnotation( annot: PdfAnnotation ): void
		{
			_writer.pdfDocument.addAnnotation( annot );
		}
		
		public function addContent( other: PdfContentByte ): void
		{
			if( other.writer != null && _writer != other.writer )
				throw new RuntimeError();
			content.append_bytebuffer( other.content );
		}
		
		/**
		 * A helper to insert into the content stream the <CODE>text</CODE>
		 * converted to bytes according to the font's encoding.
		 *
		 * @param text the text to write
		 */
		private function showText2( text: String ): void
		{
			if( state.fontDetails == null )
				throw new NullPointerError("font and size must be set before writing any text");
			var b: Bytes = state.fontDetails.convertToBytes( text );
			escapeString( b, content );
		}

		/**
		 * Generates an array of bezier curves to draw an arc.
		 * 
		 * @param x1
		 * @param y1
		 * @param x2
		 * @param y2
		 * @param startAng starting angle in degrees
		 * @param extent angle extent in degrees
		 */
		public static function bezierArc( x1: Number, y1: Number, x2: Number, y2: Number, startAng: Number, extent: Number ): Vector
			.<Vector.<Number>>
		{
			var tmp: Number;

			if ( x1 > x2 )
			{
				tmp = x1;
				x1 = x2;
				x2 = tmp;
			}

			if ( y2 > y1 )
			{
				tmp = y1;
				y1 = y2;
				y2 = tmp;
			}

			var fragAngle: Number;
			var Nfrag: int;

			if ( Math.abs( extent ) <= 90 )
			{
				fragAngle = extent;
				Nfrag = 1;
			}
			else
			{
				Nfrag = ( Math.ceil( Math.abs( extent ) / 90 ) );
				fragAngle = extent / Nfrag;
			}

			var x_cen: Number = ( x1 + x2 ) / 2;
			var y_cen: Number = ( y1 + y2 ) / 2;
			var rx: Number = ( x2 - x1 ) / 2;
			var ry: Number = ( y2 - y1 ) / 2;
			var halfAng: Number = ( fragAngle * Math.PI / 360. );
			var kappa: Number = ( Math.abs( 4. / 3. * ( 1. - Math.cos( halfAng ) ) / Math.sin( halfAng ) ) );
			var pointList: Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>();

			for ( var i: int = 0; i < Nfrag; ++i )
			{
				var theta0: Number = ( ( startAng + i * fragAngle ) * Math.PI / 180. );
				var theta1: Number = ( ( startAng + ( i + 1 ) * fragAngle ) * Math.PI / 180. );
				var cos0: Number = Math.cos( theta0 );
				var cos1: Number = Math.cos( theta1 );
				var sin0: Number = Math.sin( theta0 );
				var sin1: Number = Math.sin( theta1 );

				if ( fragAngle > 0 )
				{
					pointList.push( Vector.<Number>( [ x_cen + rx * cos0, y_cen - ry * sin0, x_cen + rx * ( cos0 - kappa * sin0 ), y_cen
						- ry * ( sin0 + kappa * cos0 ), x_cen + rx * ( cos1 + kappa * sin1 ), y_cen - ry * ( sin1 - kappa * cos1 ), x_cen
						+ rx * cos1, y_cen - ry * sin1 ] ) );
				}
				else
				{
					pointList.push( Vector.<Number>( [ x_cen + rx * cos0, y_cen - ry * sin0, x_cen + rx * ( cos0 + kappa * sin0 ), y_cen
						- ry * ( sin0 - kappa * cos0 ), x_cen + rx * ( cos1 - kappa * sin1 ), y_cen - ry * ( sin1 + kappa * cos1 ), x_cen
						+ rx * cos1, y_cen - ry * sin1 ] ) );
				}
			}
			return pointList;
		}

		internal static function escapeByteArray( byte: Bytes ): Bytes
		{
			var content: ByteBuffer = new ByteBuffer();
			escapeString( byte, content );
			return content.toByteArray();
		}

		internal static function escapeString( byte: Bytes, content: ByteBuffer ): ByteBuffer
		{
			content.append_int( '('.charCodeAt( 0 ) );

			for ( var k: int = 0; k < byte.length; ++k )
			{
				var c: int = byte[ k ];

				switch ( String.fromCharCode( c ) )
				{
					case '\r':
						content.append( '\\r' );
						break;
					case '\n':
						content.append( '\\n' );
						break;
					case '\t':
						content.append( '\\t' );
						break;
					case '\b':
						content.append( '\\b' );
						break;
					case '\f':
						content.append( '\\f' );
						break;
					case '(':
					case ')':
					case '\\':
						content.append_int( '\\'.charCodeAt( 0 ) ).append_int( c );
						break;
					default:
						content.append_int( c );
						break;
				}
			}
			content.append( ')' );
			return content;
		}
	}
}