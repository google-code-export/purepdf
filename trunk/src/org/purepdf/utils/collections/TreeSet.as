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
package org.purepdf.utils.collections
{
	import it.sephiroth.utils.collections.iterators.Iterator;
	
	import org.purepdf.IComparable;
	import org.purepdf.utils.iterators.VectorIterator;

	public class TreeSet
	{
		protected var map: Vector.<IComparable>;
		
		public function TreeSet()
		{
			map = new Vector.<IComparable>();
		}
		
		public function iterator(): Iterator
		{
			return new VectorIterator( Vector.<Object>( map ) );
		}
		
		public function add( element: IComparable ): Boolean
		{
			var exists: Boolean = exists( element );
			if( exists )
				return false;
			
			map.push( element );
			
			// TODO: verify if map should be sorted
			//map = map.sort( compare );
			return true;
		}
		
		private function exists( element: IComparable ): Boolean
		{
			for( var a: int = 0; a < map.length; a++ )
			{
				if( map[a].compareTo( element ) == 0 )
					return true;
			}
			return false;
		}
		
		private function indexOf( element: IComparable ): int
		{
			for( var a: int = 0; a < map.length; a++ )
			{
				if( map[a].compareTo( element ) == 0 )
					return a;
			}
			return -1;
		}
		
		public function remove( element: IComparable ): Boolean
		{
			var index: int = indexOf( element );
			if( index == -1 ) return false;
			map.splice( index, 1 );
			return true;
		}
		
		public function first(): IComparable
		{
			return map[0];
		}
		
		public function last(): IComparable
		{
			return map[ map.length - 1 ];
		}
		
		private function compare( element1: IComparable, element2: IComparable ): Number
		{
			return element1.compareTo( element2 );
		}
	}
}