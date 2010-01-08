package org.purepdf.pdf 
{
	

	public class PdfShadingPattern extends PdfDictionary
	{
		protected var _shading: PdfShading;
		protected var _writer: PdfWriter;
		protected var _matrix: Vector.<Number> = Vector.<Number>([1, 0, 0, 1, 0, 0]);
		protected var _patternName: PdfName;
		protected var _patternReference: PdfIndirectReference;
		
		public function PdfShadingPattern( sh: PdfShading )
		{
			_writer = sh.writer;
			put( PdfName.PATTERNTYPE, new PdfNumber(2) );
			_shading = sh;
		}
		
		internal function get patternName(): PdfName
		{
			return _patternName;
		}
		
		internal function get shadingName(): PdfName
		{
			return _shading.shadingName;
		}
		
		internal function get patternReference(): PdfIndirectReference
		{
			if( _patternReference == null )
				_patternReference = _writer.getPdfIndirectReference();
			return _patternReference;
		}
		
		internal function get shadingReference(): PdfIndirectReference
		{
			return _shading.shadingReference;
		}
		
		internal function setName( number: int ): void
		{
			_patternName = new PdfName("P" + number);
		}
		
		internal function addToBody(): void
		{
			put( PdfName.SHADING, shadingReference );
			put( PdfName.MATRIX, new PdfArray(_matrix) );
			_writer.addToBody1( this, patternReference );
		}
		
		public function set matrix( value: Vector.<Number>):void
		{
			if (value.length != 6)
				throw new ArgumentError("the matrix size must be 6");
			_matrix = value;
		}
		
		public function get matrix(): Vector.<Number>
		{
			return _matrix;
		}
		
		public function get shading(): PdfShading
		{
			return _shading;
		}
		
		internal function get colorDetails(): ColorDetails
		{
			return _shading.colorDetails;
		}
		
	}
}