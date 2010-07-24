/*
*                             ______ _____  _______ 
* .-----..--.--..----..-----.|   __ \     \|    ___|
* |  _  ||  |  ||   _||  -__||    __/  --  |    ___|
* |   __||_____||__|  |_____||___|  |_____/|___|    
* |__|
* $Id: Font.as 249 2010-02-02 06:59:26Z alessandro.crugnola $
* $Author Peter Sherwood $
* $Rev: 249 $ $LastChangedDate: 2010-02-02 07:59:26 +0100 (di, 02 feb 2010) $
* $URL: http://purepdf.googlecode.com/svn/trunk/src/org/purepdf/PdfReaderInstance.as $
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
	import it.sephiroth.utils.HashSet;
	import it.sephiroth.utils.ObjectHash;
	import it.sephiroth.utils.collections.iterators.Iterator;
	
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.errors.IllegalArgumentException;
	import org.purepdf.io.RandomAccessFileOrArray;
	import org.purepdf.utils.pdf_core;
	
	public class PdfReaderInstance
	{
		use namespace pdf_core;
	
		private static const IDENTITYMATRIX:PdfLiteral = new PdfLiteral("[1 0 0 1 0 0]");
		private static const ONE:PdfNumber = new PdfNumber(1);
		private var reader:PdfReader;
		private var file: RandomAccessFileOrArray;
		private var myXref:Array;
		private var importedPages:HashMap = new HashMap();
		private var writer:PdfWriter;
		private var visited: HashSet = new HashSet();
		private var nextRound: Array = new Array();
	    
	    /**
	     * Construct an instance of this reader instance.
	     *
	     */
	    public function PdfReaderInstance(reader:PdfReader,  writer:PdfWriter) {
	        this.reader = reader;
	        this.writer = writer;
	        file = reader.getSafeFile();
	        myXref = new Array(reader.getXrefSize());
	    }
	
			/**
			 * Get the Reader.
			 */
	    public function getReader():PdfReader {
	        return reader;
	    }
	    
	    public function getImportedPage(pageNumber:int): PdfImportedPage {        
	        if (!reader.isOpenedWithFullPermissions())
	            throw new IllegalArgumentException("PdfReader not opened with owner password");
	        if (pageNumber < 1 || pageNumber > reader.getNumberOfPages())
	            throw new IllegalArgumentException("Invalid page number.");
	        var pageT:PdfImportedPage = importedPages.getValue(pageNumber) as PdfImportedPage;
	        if (pageT == null) {
	            pageT = new PdfImportedPage(this, writer, pageNumber);
	            importedPages.put(pageNumber, pageT);
	        }
	        return pageT;
	    }
	    
	    public function getNewObjectNumber(number: int, generation: int) : int {
	        if (myXref.indexOf(number) == -1) {
	            myXref[number] = writer.getIndirectReferenceNumber();
	            nextRound.push(number);
	        }
	        return myXref[number];
	    }
	    
	    /**
	     * Get the Reader file.
	     */
	    protected function getReaderFile(): RandomAccessFileOrArray {
	        return file;
	    }
	    
	    public function getResources(pageNumber:int):PdfObject {
	        var obj:PdfObject = PdfReader.getPdfObjectRelease(reader.getPageNRelease(pageNumber).getValue(PdfName.RESOURCES));
	        return obj;
	    }
	    
	        /**
	     * Gets the content stream of a page as a PdfStream object.
	     * @param	pageNumber			the page of which you want the stream
	     * @param	compressionLevel	the compression level you want to apply to the stream
	     * @return	a PdfStream object
	     * @since	2.1.3 (the method already existed without param compressionLevel)
	     */
	    public function getFormXObject(pageNumber : int, compressionLevel : int) : PdfStream{
	        var page:PdfDictionary = reader.getPageNRelease(pageNumber);
	        var contents: PdfObject = PdfReader.getPdfObjectRelease(page.getValue(PdfName.CONTENTS));
	        var dic: PdfDictionary = new PdfDictionary();
	        var bout: ByteArray = null;
	        if (contents != null) {
	            if (contents.isStream()) {
	                dic.putAll(contents as PRStream);
	            }
	            else {
	//                bout = reader.getPageContent(pageNumber, file);
	            }
	        }
	        else
	            bout = new ByteArray();
	        dic.put(PdfName.RESOURCES, PdfReader.getPdfObjectRelease(page.getValue(PdfName.RESOURCES)));
	        dic.put(PdfName.TYPE, PdfName.XOBJECT);
	        dic.put(PdfName.SUBTYPE, PdfName.FORM);
	        var impPage:PdfImportedPage = importedPages.getValue(pageNumber) as PdfImportedPage;
	        var bBox : RectangleElement = impPage.boundingBox;
	        dic.put(PdfName.BBOX, PdfRectangle.createFromRectangle(bBox));
	        var matrix:PdfArray = impPage.matrix;
	        if (matrix == null)
	            dic.put(PdfName.MATRIX, IDENTITYMATRIX);
	        else
	            dic.put(PdfName.MATRIX, matrix);
	        dic.put(PdfName.FORMTYPE, ONE);
	        var stream:PRStream;
	        if (bout == null) {
	            stream = PRStream.fromPRStream(contents as PRStream, dic);
	        }
	        else {     
	            //stream = new PRStream(reader, bout, compressionLevel);
	            stream.putAll(dic);
	        }
	        return stream;
	    }
	    
	    function writeAllVisited() : void {
	        while (nextRound.length != 0 ) {
	            var vec: Array = nextRound;
	            nextRound = new Array();
	            for (var k:int = 0; k < vec.length; ++k) {
	                var i:int = vec[k];
	                if (!visited.contains(i)) {
	                    visited.add(i);
	                    var n:int = i;
	                    writer.addToBodyRefNumber(reader.getPdfObjectRelease(n), myXref[n]);
	                }
	            }
	        }
	    }
	    
	    function writeAllPages() : void {
	      file.reOpen();
	      for ( var i: Iterator = importedPages.entrySet().iterator(); i.hasNext(); ) {
	     	 var entry: Entry = Entry( i.next() );            
	         var ip:PdfImportedPage = entry.getValue() as PdfImportedPage;
	         writer.addToBody1(ip.getFormXObject(writer.compressionLevel), ip.indirectReference);
	      }
	      writeAllVisited();
	    }
    
	}
}