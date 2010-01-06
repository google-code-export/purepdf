package org.purepdf.pdf
{
	import org.purepdf.utils.collections.HashMap;

	public class PdfPage extends PdfDictionary
	{
		private static const boxStrings: Vector.<String> = Vector.<String>(["crop", "trim", "art", "bleed"]);
		private static const boxNames: Vector.<PdfName> = Vector.<PdfName>([ PdfName.CROPBOX, PdfName.TRIMBOX, PdfName.ARTBOX, PdfName.BLEEDBOX ]);
		
		public static const PORTRAIT: PdfNumber = new PdfNumber( 0 );
		public static const LANDSCAPE: PdfNumber = new PdfNumber( 90 );
		public static const INVERTEDPORTRAIT: PdfNumber = new PdfNumber( 180 );
		public static const SEASCAPE: PdfNumber = new PdfNumber( 270 );
		
		protected var mediaBox: PdfRectangle;
		
		public function PdfPage( $mediaBox: PdfRectangle, boxSize: HashMap, resources: PdfDictionary, rotate: int )
		{
			super( PAGE );
			mediaBox = $mediaBox;
			put( PdfName.MEDIABOX, mediaBox );
			put( PdfName.RESOURCES, resources );
			
			if( rotate != 0 )
			{
				put( PdfName.ROTATE, new PdfNumber( rotate ) );
			}
			
			for( var k: int = 0; k < boxStrings.length; ++k )
			{
				var rect: PdfObject;
				if( boxSize.hasOwnProperty( boxStrings[k] ) )
					put( boxNames[k], boxSize[ boxStrings[k] ] );
			}
		}
		
		public function isParent(): Boolean
		{
			return false;
		}
		
		/**
		 * Adds an indirect reference pointing to a <CODE>PdfContents</CODE>-object.
		 *
		 * @param	contents		an indirect reference to a <CODE>PdfContents</CODE>-object
		 */
		
		public function add( contents: PdfIndirectReference ): void
		{
			put( PdfName.CONTENTS, contents );
		}
		
		/**
		 * Rotates the mediabox, but not the text in it.
		 *
		 * @return		a <CODE>PdfRectangle</CODE>
		 */
		public function rotateMediaBox(): PdfRectangle
		{
			this.mediaBox = mediaBox.rotate();
			put( PdfName.MEDIABOX, this.mediaBox );
			return this.mediaBox;
		}
		
		public function getMediaBox(): PdfRectangle
		{
			return mediaBox;
		}
	}
}