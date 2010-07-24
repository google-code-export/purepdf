/*
*                             ______ _____  _______ 
* .-----..--.--..----..-----.|   __ \     \|    ___|
* |  _  ||  |  ||   _||  -__||    __/  --  |    ___|
* |   __||_____||__|  |_____||___|  |_____/|___|    
* |__|
* $Id: Font.as 249 2010-02-02 06:59:26Z alessandro.crugnola $
* $Author Peter Sherwood $
* $Rev: 249 $ $LastChangedDate: 2010-02-02 07:59:26 +0100 (di, 02 feb 2010) $
* $URL: http://purepdf.googlecode.com/svn/trunk/src/org/purepdf/Element.as $
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


	/**
	 * Interface for a text element.
	 * <P>
	 * Remark: I looked at the interface javax.swing.text.Element, but I decided to
	 * write my own text-classes for two reasons:
	 * <OL>
	 * <LI>The javax.swing.text-classes may be very generic, I think they are
	 * overkill: they are to heavy for what they have to do.
	 * <LI>A lot of people using iText (formerly known as rugPdf), still use
	 * JDK1.1.x. I try to keep the Java2 requirements limited to the Collection
	 * classes (I think they're really great). However, if I use the
	 * javax.swing.text classes, it will become very difficult to downgrade rugPdf.
	 * </OL>
	 *
	 * @see Anchor
	 * @see Chapter
	 * @see Chunk
	 * @see Header
	 * @see Image
	 * @see Jpeg
	 * @see List
	 * @see ListItem
	 * @see Meta
	 * @see Paragraph
	 * @see Phrase
	 * @see Rectangle
	 * @see Section
	 */
	
	public interface Element {
	
		// methods
	
		/**
		 * Processes the element by adding it (or the different parts) to an <CODE>
		 * ElementListener</CODE>.
		 *
		 * @param listener
		 *            an <CODE>ElementListener</CODE>
		 * @return <CODE>true</CODE> if the element was processed successfully
		 */
	
		function process(listener:ElementListener):Boolean ;
	
		/**
		 * Gets the type of the text element.
		 *
		 * @return a type
		 */
	
		function type():int ;
	
		/**
		 * Checks if this element is a content object.
		 * If not, it's a metadata object.
		 * @return	true if this is a 'content' element; false if this is a 'metadata' element
		 */
	
		function isContent():Boolean ;
	
		/**
		 * Checks if this element is nestable.
		 * @return	true if this element can be nested inside other elements.
		 */
	
		function isNestable():Boolean ;
	
		/**
		 * Gets all the chunks in this element.
		 *
		 * @return an <CODE>ArrayList</CODE>
		 */
	
		function getChunks() : Array ;
	
		/**
		 * Gets the content of the text element.
		 *
		 * @return a type
		 */
	
		function toString():String ;
	}
}