/*
*                             ______ _____  _______ 
* .-----..--.--..----..-----.|   __ \     \|    ___|
* |  _  ||  |  ||   _||  -__||    __/  --  |    ___|
* |   __||_____||__|  |_____||___|  |_____/|___|    
* |__|
* $Id: Font.as 249 2010-02-02 06:59:26Z alessandro.crugnola $
* $Author Peter Sherwood $
* $Rev: 249 $ $LastChangedDate: 2010-02-02 07:59:26 +0100 (di, 02 feb 2010) $
* $URL: http://purepdf.googlecode.com/svn/trunk/src/org/purepdf/PdfImportedPage.as $
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
	import flash.errors.EOFError;
	import flash.errors.IOError;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import it.sephiroth.utils.Entry;
	import it.sephiroth.utils.HashMap;
	import it.sephiroth.utils.ObjectHash;
	import it.sephiroth.utils.collections.iterators.Iterator;
	import it.sephiroth.utils.HashMap;
	import it.sephiroth.utils.HashSet;
	
	import org.purepdf.utils.pdf_core;
	import org.purepdf.io.RandomAccessFileOrArray;

	public class PdfImportedPage extends PdfTemplate
	{
		use namespace pdf_core;
		
	    private var readerInstance : PdfReaderInstance;
	    private var pageNumber : int;
	    
	    public function PdfImportedPage(readerInstance: PdfReaderInstance, writer: PdfWriter , pageNumber:int) {
	    		super(writer);
	        this.readerInstance = readerInstance;
	        this.pageNumber = pageNumber;
	        this.writer = writer;
	        bBox = readerInstance.getReader().getPageSize(pageNumber);
	        setMatrixValues(1, 0, 0, 1, -bBox.getLeft(), -bBox.getBottom());
	        _type = PdfTemplate.TYPE_IMPORTED;
	    }
	    
		/**
		 * Gets the stream representing this page.
		 *
		 * @param	compressionLevel	the compressionLevel
		 * @return the stream representing this page
		 * @since	2.1.3	(replacing the method without param compressionLevel)
		 */
		 override public function getFormXObject(compressionLevel : int) : PdfStream {
			return readerInstance.getFormXObject(pageNumber, compressionLevel);
		}
		
	    /** Reads the content from this <CODE>PdfImportedPage</CODE>-object from a reader.
	     *
	     * @return self
	     *
	     */
	    public function getFromReader(): PdfImportedPage {
	      return this;
	    }
	
	    public function getPageNumber(): int {
	        return pageNumber;
	    }
	    
	    public function getPdfReaderInstance(): PdfReaderInstance {
	        return readerInstance;
	    }
	    
	    public function getResources() : PdfObject {
	        return readerInstance.getResources(pageNumber);
	    }
	}
}