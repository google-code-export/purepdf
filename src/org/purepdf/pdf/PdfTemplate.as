package org.purepdf.pdf
{
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.pdf.interfaces.IPdfOCG;

	public class PdfTemplate extends PdfContentByte
	{
		public static const TYPE_IMPORTED: int = 2;
		public static const TYPE_PATTERN: int = 3;
		public static const TYPE_TEMPLATE: int = 1;

		protected var _type: int;
		protected var bBox: RectangleElement = new RectangleElement( 0, 0, 0, 0 );
		protected var _group: PdfTransparencyGroup;
		protected var matrix: PdfArray;
		protected var _pageResources: PageResources;
		protected var thisReference: PdfIndirectReference;
		private var _layer: IPdfOCG;

		public function PdfTemplate( $writer: PdfWriter=null )
		{
			super( $writer );
			_type = TYPE_TEMPLATE;

			if ( $writer != null )
			{
				_pageResources = new PageResources();
				_pageResources.addDefaultColor( $writer.getDefaultColorSpace() );
				thisReference = $writer.getPdfIndirectReference();
			}
		}


		public function get boundingBox(): RectangleElement
		{
			return bBox;
		}

		public function set boundingBox( value: RectangleElement ): void
		{
			bBox = value;
		}

		public function get height(): Number
		{
			return bBox.height;
		}

		public function set height( value: Number ): void
		{
			bBox.setTop( value );
			bBox.setBottom( 0 );
		}

		public function get layer(): IPdfOCG
		{
			return _layer;
		}

		public function set layer( value: IPdfOCG ): void
		{
			_layer = value;
		}

		public function setMatrix( a: Number, b: Number, c: Number, d: Number, tx: Number, ty: Number ): void
		{
			matrix = new PdfArray();
			matrix.add( new PdfNumber( a ) );
			matrix.add( new PdfNumber( b ) );
			matrix.add( new PdfNumber( c ) );
			matrix.add( new PdfNumber( d ) );
			matrix.add( new PdfNumber( tx ) );
			matrix.add( new PdfNumber( ty ) );
		}
		
		public function getMatrix(): PdfArray
		{
			return matrix;
		}

		public function get type(): int
		{
			return _type;
		}

		public function get width(): Number
		{
			return bBox.width;
		}

		public function set width( value: Number ): void
		{
			bBox.setLeft( 0 );
			bBox.setRight( value );
		}
		
		public function get indirectReference(): PdfIndirectReference
		{
			if( thisReference == null )
				thisReference = writer.getPdfIndirectReference();
			return thisReference;
		}
		
		public function beginVariableText(): void
		{
			content.append_string("/Tx BMC ");
		}
		
		public function endVariableText(): void
		{
			content.append_string("EMC ");
		}
		
		override public function get pageResources(): PageResources
		{
			return _pageResources;
		}
		
		/**
		 * Constructs the resources used by this template.
		 *
		 * @return the resources used by this template
		 */
		
		public function get resources(): PdfObject {
			return pageResources.getResources();
		}
		
		/**
		 * Gets the stream representing this template.
		 *
		 * @param	compressionLevel	the compressionLevel
		 */
		
		public function getFormXObject( compressionLevel: int ): PdfStream
		{
			return new PdfFormXObject( this, compressionLevel );
		}
		
		public function duplicate(): PdfContentByte
		{
			var tpl: PdfTemplate = new PdfTemplate();
			tpl.writer = writer;
			tpl.pdf = pdf;
			tpl.thisReference = thisReference;
			tpl._pageResources = pageResources;
			tpl.bBox = RectangleElement.clone( bBox );
			tpl.group = group;
			tpl.layer = layer;
			if (matrix != null) 
			{
				tpl.matrix = new PdfArray(matrix);
			}
			tpl.separator = separator;
			return tpl;
		}
		
		public function get group(): PdfTransparencyGroup
		{
			return _group;
		}
		
		public function set group( value: PdfTransparencyGroup ): void
		{
			_group = value;
		}
			

		/**
		 * Creates a new template.
		 * <P>
		 * Creates a new template that is nothing more than a form XObject
		 *
		 * @param writer the PdfWriter to use
		 * @param width the bounding box width
		 * @param height the bounding box height
		 *
		 */
		public static function createTemplate( writer: PdfWriter, w: Number, h: Number ): PdfTemplate
		{
			return createTemplate2( writer, w, h, null );
		}

		public static function createTemplate2( writer: PdfWriter, w: Number, h: Number, forcedName: PdfName ): PdfTemplate
		{
			var tpl: PdfTemplate = new PdfTemplate( writer );
			tpl.width = w;
			tpl.height = h;
			writer.addDirectTemplateSimple( tpl, forcedName );
			return tpl;
		}
	}
}