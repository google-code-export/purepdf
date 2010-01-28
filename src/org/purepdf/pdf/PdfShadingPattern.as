/*
*                             ______ _____  _______ 
* .-----..--.--..----..-----.|   __ \     \|    ___|
* |  _  ||  |  ||   _||  -__||    __/  --  |    ___|
* |   __||_____||__|  |_____||___|  |_____/|___|    
* |__|
* $Id$
* $Author Alessandro Crugnola $
* $Rev$ $LastChangedDate$
* $URL$
*
* The contents of this file are subject to  LGPL license 
* (the "GNU LIBRARY GENERAL PUBLIC LICENSE"), in which case the
* provisions of LGPL are applicable instead of those above.  If you wish to
* allow use of your version of this file only under the terms of the LGPL
* License and not to allow others to use your version of this file under
* the MPL, indicate your decision by deleting the provisions above and
* replace them with the notice and other provisions required by the LGPL.
* If you do not delete the provisions above, a recipient may use your version
* of this file under either the MPL or the GNU LIBRARY GENERAL PUBLIC LICENSE
*
* Software distributed under the License is distributed on an "AS IS" basis,
* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
* for the specific language governing rights and limitations under the License.
*
* The Original Code is 'iText, a free JAVA-PDF library' ( version 4.2 ) by Bruno Lowagie.
* All the Actionscript ported code and all the modifications to the
* original java library are written by Alessandro Crugnola (alessandro@sephiroth.it)
*
* This library is free software; you can redistribute it and/or modify it
* under the terms of the MPL as stated above or under the terms of the GNU
* Library General Public License as published by the Free Software Foundation;
* either version 2 of the License, or any later version.
*
* This library is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
* FOR A PARTICULAR PURPOSE. See the GNU LIBRARY GENERAL PUBLIC LICENSE for more
* details
*
* If you didn't download this code from the following link, you should check if
* you aren't using an obsolete version:
* http://code.google.com/p/purepdf
*
*/
package org.purepdf.pdf 
{
	import org.purepdf.utils.pdf_core;
	

	public class PdfShadingPattern extends PdfDictionary
	{
		protected var _shading: PdfShading;
		protected var _writer: PdfWriter;
		protected var _matrix: Vector.<Number> = Vector.<Number>([1, 0, 0, 1, 0, 0]);
		protected var _patternName: PdfName;
		protected var _patternReference: PdfIndirectReference;
		
		use namespace pdf_core;
		
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