/*
*                             ______ _____  _______ 
* .-----..--.--..----..-----.|   __ \     \|    ___|
* |  _  ||  |  ||   _||  -__||    __/  --  |    ___|
* |   __||_____||__|  |_____||___|  |_____/|___|    
* |__|
* $Id: Font.as 249 2010-02-02 06:59:26Z alessandro.crugnola $
* $Author Peter Sherwood $
* $Rev: 249 $ $LastChangedDate: 2010-02-02 07:59:26 +0100 (di, 02 feb 2010) $
* $URL: http://purepdf.googlecode.com/svn/trunk/src/org/purepdf/DocListener.as $
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
package org.purepdf {
	import org.purepdf.elements.RectangleElement;

	/**
	 * A class that implements <CODE>DocListener</CODE> will perform some
	 * actions when some actions are performed on a <CODE>Document</CODE>.
	 *
	 * @see		ElementListener
	 * @see		Document
	 * @see		DocWriter
	 */
	
	public interface DocListener extends ElementListener {
	    
	    // methods
	    
		/**
		 * Signals that the <CODE>Document</CODE> has been opened and that
		 * <CODE>Elements</CODE> can be added.
		 */
	    
	    function open():void ; // [L1]
	    
	    /**
	     * Signals that the <CODE>Document</CODE> was closed and that no other
	     * <CODE>Elements</CODE> will be added.
	     * <P>
	     * The outputstream of every writer implementing <CODE>DocListener</CODE> will be closed.
	     */
	        
	    function close():void ; // [L2] 
	    
	    /**
	     * Signals that an new page has to be started.
	     *
	     * @return	<CODE>true</CODE> if the page was added, <CODE>false</CODE> if not.
	     */
	        
	    function newPage():Boolean ; // [L3]
	    
	    /**
	     * Sets the pagesize.
	     *
	     * @param	pageSize	the new pagesize
	     * @return	a <CODE>boolean</CODE>
	     */
	        
	    function setPageSize(pageSize:RectangleElement):void ; // [L4]
	        
	    /**
	     * Sets the margins.
	     *
	     * @param	marginLeft		the margin on the left
	     * @param	marginRight		the margin on the right
	     * @param	marginTop		the margin on the top
	     * @param	marginBottom	the margin on the bottom
	     * @return	a <CODE>boolean</CODE>
	     */
	        
	    function setMargins(marginLeft:Number, marginRight:Number, marginTop:Number, marginBottom:Number):Boolean ;  // [L5]
	        
	    /**
	     * Parameter that allows you to do left/right  margin mirroring (odd/even pages)
	     * @param marginMirroring
	     * @return true if successful
	     */
	    function setMarginMirroring(marginMirroring:Boolean):Boolean ; // [L6]
	    
	    /**
	     * Parameter that allows you to do top/bottom margin mirroring (odd/even pages)
	     * @param marginMirroringTopBottom
	     * @return true if successful
	     * @since	2.1.6
	     */
	    function setMarginMirroringTopBottom(marginMirroringTopBottom:Boolean):Boolean ; // [L6]
	        
	    /**
	     * Sets the page number.
	     *
	     * @param	pageN		the new page number
	     */
	        
	    function setPageCount(pageN:int):void ; // [L7]
	    
	    /**
	     * Sets the page number to 0.
	     */
	        
	    function resetPageCount():void ; // [L8]
	
	}
}