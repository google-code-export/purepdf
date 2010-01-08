package org.purepdf.pdf
{
	import org.purepdf.ObjectHash;

	/**
	 * Describe each SpotColor defined in the document
	 */
	public class ColorDetails extends ObjectHash
	{
		private var _colorName: PdfName;
		private var _indirectReference: PdfIndirectReference;
		private var _spotColor: PdfSpotColor;

		public function ColorDetails( name: PdfName, ind: PdfIndirectReference, spot: PdfSpotColor )
		{
			_colorName = name;
			_indirectReference = ind;
			_spotColor = spot;
		}

		public function get colorName(): PdfName
		{
			return _colorName;
		}

		public function get indirectReference(): PdfIndirectReference
		{
			return _indirectReference;
		}

		internal function getSpotColor( writer: PdfWriter ): PdfObject
		{
			return _spotColor.getSpotObject( writer );
		}
	}
}