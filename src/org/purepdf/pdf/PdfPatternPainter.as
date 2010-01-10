package org.purepdf.pdf
{
	import org.purepdf.colors.RGBColor;
	import org.purepdf.elements.images.ImageElement;
	import org.purepdf.errors.RuntimeError;
	

	public class PdfPatternPainter extends PdfTemplate
	{
		private var _xstep: Number;
		private var _ystep: Number;
		private var _stencil: Boolean = false;
		private var _defaultColor: RGBColor;
		
		public function PdfPatternPainter( $writer: PdfWriter = null, color: RGBColor = null )
		{
			super($writer);
			_type = TYPE_PATTERN;
			
			if( color != null )
			{
				_stencil = true;
				_defaultColor = color;
			}
		}
		
		public function get defaultColor():RGBColor
		{
			return _defaultColor;
		}
		
		/**
		 * Get the vertical interval of this pattern.
		 */
		public function get ystep():Number
		{
			return _ystep;
		}

		/**
		 * Sets the vertical interval of this pattern.
		 */
		public function set ystep(value:Number):void
		{
			_ystep = value;
		}

		/**
		 * Set the horizontal interval of this pattern
		 */
		public function get xstep():Number
		{
			return _xstep;
		}

		/**
		 * Get the horizontal interval of this pattern.
		 */
		public function set xstep(value:Number):void
		{
			_xstep = value;
		}
		
		/**
		 * Tells you if this pattern is colored/uncolored
		 */
		public function get is_stencil(): Boolean
		{
			return _stencil;
		}
		
		/**
		 * Get the stream for this pattern
		 */
		public function getPattern( compressionLvl: int = 0 /* PdfStream.NO_COMPRESSION */ ): PdfPattern
		{
			return new PdfPattern( this, compressionLvl );
		}
		
		override public function duplicate(): PdfContentByte
		{
			var tpl: PdfPatternPainter = new PdfPatternPainter();
			tpl.writer = writer;
			tpl.pdf = pdf;
			tpl.thisReference = thisReference;
			tpl._pageResources = _pageResources;
			tpl.bBox = bBox;
			tpl.xstep = xstep;
			tpl.ystep = ystep;
			tpl.matrix = matrix;
			tpl._stencil = _stencil;
			tpl._defaultColor = _defaultColor;
			return tpl;
		}
		
		override public function setGrayFill(gray:Number) : void
		{
			checkNoColor();
			super.setGrayFill( gray );
		}
		
		override public function resetFill() : void
		{
			checkNoColor();
			super.resetFill();
		}
		
		override public function resetStroke() : void
		{
			checkNoColor();
			super.resetStroke();
		}
		
		override public function setGrayStroke(gray:Number) : void
		{
			checkNoColor();
			super.setGrayStroke( gray );
		}
		
		override public function setRGBFillColor(red:int, green:int, blue:int) : void
		{
			checkNoColor();
			super.setRGBFillColor( red, green, blue );
		}
		
		override public function setRGBStrokeColor(red:int, green:int, blue:int) : void
		{
			checkNoColor();
			super.setRGBStrokeColor( red, green, blue );
		}
		
		override public function setCMYKFillColor(cyan:Number, magenta:Number, yellow:Number, black:Number) : void
		{
			checkNoColor();
			super.setCMYKFillColor( cyan, magenta, yellow, black );
		}
		
		override public function setCMYKStrokeColor(cyan:Number, magenta:Number, yellow:Number, black:Number) : void
		{
			checkNoColor();
			super.setCMYKStrokeColor( cyan, magenta, yellow, black );
		}
		
		override public function setStrokeColor(color:RGBColor) : void
		{
			checkNoColor();
			super.setStrokeColor( color );
		}
		
		override public function setFillColor(color:RGBColor) : void
		{
			checkNoColor();
			super.setFillColor( color );
		}
		
		override public function setPatternStroke(p:PdfPatternPainter) : void
		{
			checkNoColor();
			super.setPatternStroke(p);
		}
		
		override public function setPatternStroke2(p:PdfPatternPainter, color:RGBColor) : void
		{
			checkNoColor();
			super.setPatternStroke2( p, color );
		}
		
		override public function setPatternStroke3(p:PdfPatternPainter, color:RGBColor, tint:Number) : void
		{
			checkNoColor();
			super.setPatternStroke3( p, color, tint );
		}
		
		override public function setPatternFill(p:PdfPatternPainter) : void
		{
			checkNoColor();
			super.setPatternFill( p );
		}
		
		override public function setPatternFill2(p:PdfPatternPainter, color:RGBColor) : void
		{
			checkNoColor();
			super.setPatternFill2( p, color );
		}
		
		override public function setPatternFill3(p:PdfPatternPainter, color:RGBColor, tint:Number) : void
		{
			checkNoColor();
			super.setPatternFill3( p, color, tint );
		}
		
		override public function addImage2(image:ImageElement, width:Number, b:Number, c:Number, height:Number, x:Number, y:Number, inlineImage:Boolean) : void
		{
			if( _stencil && !image.ismask )
			{
				checkNoColor();
			}
			super.addImage2( image, width, b, c, height, x, y, inlineImage );
		}
			
		
		public function checkNoColor(): void
		{
			if (_stencil)
				throw new RuntimeError("colors not allowed in uncolored tile pattern");
		}

	}
}