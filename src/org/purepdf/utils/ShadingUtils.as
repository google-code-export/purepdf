package org.purepdf.utils
{
	import org.purepdf.colors.GrayColor;
	import org.purepdf.colors.RGBColor;
	import org.purepdf.pdf.PdfContentByte;
	import org.purepdf.pdf.PdfDictionary;
	import org.purepdf.pdf.PdfGState;
	import org.purepdf.pdf.PdfName;
	import org.purepdf.pdf.PdfShading;
	import org.purepdf.pdf.PdfShadingPattern;
	import org.purepdf.pdf.PdfTemplate;
	import org.purepdf.pdf.PdfTransparencyGroup;

	public class ShadingUtils
	{
		/**
		 * Draws a rectangle with a multiple alpha gradient colors<br />
		 * Example:<br />
		 * <pre>
		 * var colors: Vector.&lt;RGBColor&gt; 	= Vector.&lt;RGBColor&gt;([ RGBColor.BLACK, RGBColor.YELLOW, RGBColor.RED, RGBColor.CYAN ] );
		 * var ratios: Vector.&lt;Number&gt;		= Vector.&lt;Number&gt;([0, 0.5, 0.7, 1]);
		 * var alphas: Vector.&ltNumber&gt;		= Vector.&lt;Number&gt;([ 0, 0.2, 0.3, 0.6 ]);
		 * ShadingUtils.drawRectangleGradient( cb, 100, 100, 100, PageSize.A4.height - 200, colors, ratios, alphas ); 
		 * </pre>
		 * 
		 * @param cb
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * @param colors		Vector of RGBColor
		 * @param ratios		Vector of numbers ( 0 to 1 )
		 * @param alpha			Vector of numbers ( 0 to 1 )
		 * @param extendStart
		 * @param extendEnd
		 */
		public static function drawRectangleGradient( cb: PdfContentByte, x: Number, y: Number, width: Number, height: Number, colors: Vector.<RGBColor>,
				ratios: Vector.<Number>, alpha: Vector.<Number>, extendStart: Boolean = true, extendEnd: Boolean = true ): void
		{
			assertTrue( colors.length == alpha.length, "Colors and Alpha vectors must be same length" );

			var shading: PdfShading;
			var template: PdfTemplate;
			var gState: PdfGState;

			cb.moveTo( x, y );
			cb.lineTo( x + width, y );
			cb.lineTo( x + width, y + height );
			cb.lineTo( x, y + height );

			// Create template
			template = cb.createTemplate( x + width, y + height );

			var transGroup: PdfTransparencyGroup = new PdfTransparencyGroup();
			transGroup.put( PdfName.CS, PdfName.DEVICERGB );
			transGroup.isolated = true;
			transGroup.knockout = false;
			template.group = transGroup;

			gState = new PdfGState();
			var maskDict: PdfDictionary = new PdfDictionary();
			maskDict.put( PdfName.TYPE, PdfName.MASK );
			maskDict.put( PdfName.S, new PdfName( "Luminosity" ) );
			maskDict.put( new PdfName( "G" ), template.indirectReference );
			gState.put( PdfName.SMASK, maskDict );
			cb.setGState( gState );

			var alphas: Vector.<GrayColor> = new Vector.<GrayColor>( alpha.length, true );
			for ( var k: int = 0; k < alpha.length; ++k )
			{
				alphas[k] = new GrayColor( alpha[k] );
			}

			shading = PdfShading.complexAxial( cb.writer, 0, y, 0, height, Vector.<RGBColor>( alphas ), ratios );
			template.paintShading( shading );

			shading = PdfShading.complexAxial( cb.writer, 0, y, 0, height, colors, ratios );
			var axialPattern: PdfShadingPattern = new PdfShadingPattern( shading );
			cb.setShadingFill( axialPattern );
			cb.fill();
		}
	}
}