/*
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
* The Original Code is 'iText, a free JAVA-PDF library' by Bruno Lowagie.
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
package org.purepdf.elements
{
	import flash.utils.Dictionary;
	
	import org.purepdf.errors.DocumentError;

	public class MarkedObject implements IElement
	{
		protected var _element: IElement;
		protected var _properties: Dictionary;

		public function MarkedObject( $element: IElement = null )
		{
			_element = $element;
		}
		
		public function get element(): IElement
		{
			return _element;
		}
		
		public function get markupAttributes(): Dictionary
		{
			return _properties;
		}
		
		public function set markupAttributes( value: Dictionary ): void
		{
			_properties = value;
		}
		
		public function setMarkupAttribute( key: String, value: String ): void
		{
			_properties[key] = value;
		}
		
		public function process(listener:IElementListener):Boolean
		{
			try
			{
				return listener.addElement( _element );
			} catch( de: DocumentError )
			{}
			return false;
		}
		
		public function getChunks():Vector.<Object>
		{
			return _element.getChunks();
		}
		
		public function get isNestable():Boolean
		{
			return true;
		}
		
		public function get isContent():Boolean
		{
			return true;
		}
		
		public function toString():String
		{
			return null;
		}
		
		public function get type():int
		{
			return Element.MARKED;
		}
	}
}