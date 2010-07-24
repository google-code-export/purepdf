/*
*                             ______ _____  _______ 
* .-----..--.--..----..-----.|   __ \     \|    ___|
* |  _  ||  |  ||   _||  -__||    __/  --  |    ___|
* |   __||_____||__|  |_____||___|  |_____/|___|    
* |__|
* $Id: Font.as 249 2010-02-02 06:59:26Z alessandro.crugnola $
* $Author Peter Sherwood $
* $Rev: 249 $ $LastChangedDate: 2010-02-02 07:59:26 +0100 (di, 02 feb 2010) $
* $URL: http://purepdf.googlecode.com/svn/trunk/src/org/purepdf/PdfCopyFields.as $
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
* Part of the copy documents update by Peter Sherwood
*
*/
package org.purepdf.pdf
{
	import flash.utils.ByteArray;
	
	import org.purepdf.io.OutputStreamCounter;
	import org.purepdf.utils.pdf_core;
	
	/**
	 * Copies fields between streams.
	 */
	public class PdfCopyFields
	{

		use namespace pdf_core;
	
		
		private var fc:PdfCopyFieldsImp;
		
		/**
		 * Creates a new instance.
		 * @param os the output stream
		 * @throws DocumentException on error
		 */
		public function PdfCopyFields(os:ByteArray) {
			fc = new PdfCopyFieldsImp(os);
		}
		
		/**
		 * Concatenates a PDF document.
		 * @param reader the PDF document
		 * @throws DocumentException on error
		 */
		public function addDocument(reader:PdfReader):void {
			fc.addDocument(reader);
		}
		
		/**
		 * Closes the output document.
		 */
		public function close() : void {
			fc.close();
		}
		
	}
}