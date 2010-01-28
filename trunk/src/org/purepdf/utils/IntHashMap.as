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
package org.purepdf.utils
{
	import it.sephiroth.utils.Entry;
	import it.sephiroth.utils.HashMap;
	
	public class IntHashMap extends HashMap
	{
		public function IntHashMap( initialCapacity: int = -1 )
		{
			super( initialCapacity );
		}
		
		public function toOrderedKeys(): Vector.<int>
		{
			var res: Vector.<int> = getKeys();
			res.sort( function( a: int, b: int ): Number { return a - b; } );
			return res;
		}
		
		
		
		public function getKeys(): Vector.<int>
		{
			var res: Vector.<int> = new Vector.<int>( _size, true );
			var ptr: int = 0;
			var index: int = table.length;
			var entry: Entry = null;
			var e: Entry;
			while (true) 
			{
				if (entry == null)
					while ((index-- > 0) && ((entry = table[index]) == null)){ /* empty statement */ }
				if (entry == null)
					break;
				e = entry;
				entry = e.next;
				res[ptr++] = int(e.key);
			}
			return res;
		}
		
		override public function put(key:Object, value:Object) : Object
		{
			var hash: int = int(key);
			var index: int = ( hash & 0x7FFFFFFF ) % table.length;
			var e: Entry;
			
			for ( e = table[index]; e != null; e = e.next )
			{
				var k: Object;
				
				if ( e.hash == hash && e.key == key )
				{
					var old: int = int(e.value);
					e.value = value;
					return old;
				}
			}
			
			if( _size >= threshold )
			{
				resize( 2 * table.length );
				index = ( hash & 0x7FFFFFFF ) % table.length;
			}
			
			e = new Entry( hash, key, value, table[index]);
			table[index] = e;
			_size++;
			return null;			
		}
		
		override public function remove(key:Object) : Object
		{
			var hash: int = int(key);
			var index: int = (hash & 0x7FFFFFFF) % table.length;
			var prev: Entry;
			
			for( var e: Entry = table[index], prev = null; e != null; prev = e, e = e.next )
			{
				if( e.hash == hash && e.key == key )
				{
					if (prev != null) {
						prev.next = e.next;
					} else {
						table[index] = e.next;
					}
					_size--;
					var oldValue: int = int(e.value);
					e.value = 0;
					return oldValue;
				}
			}
			return 0;
		}
		
		override public function containsValue( value: Object ): Boolean
		{
			var v: int = int(value);
			for( var i: int = table.length; i-- > 0;) 
			{
				for( var e: Entry = table[i]; e != null; e = e.next) {
					if (e.value == v) {
						return true;
					}
				}
			}
			return false;
		}
		
		override public function containsKey( key: Object ): Boolean
		{
			var ikey: int = int(key);
			var hash: int = ikey;
			var index: int = (hash & 0x7FFFFFFF) % table.length;
			
			for( var e: Entry = table[index]; e != null; e = e.next) {
				if (e.hash == hash && e.key == ikey) {
					return true;
				}
			}
			return false;
		}
		
		override public function getValue( key: Object ): Object
		{
			var hash: int = int(key);
			var index: int = ( hash & 0x7FFFFFFF ) % table.length;
			
			for( var e: Entry = table[index]; e != null; e = e.next) {
				if (e.hash == hash && e.key == key )
				{
					return e.value;
				}
			}
			return 0;
		}
		
		override protected function transfer( newTable: Vector.<Entry> ): void
		{
			var src: Vector.<Entry> = table;
			var newCapacity: int = newTable.length;
			
			for ( var j: int = 0; j < src.length; j++ )
			{
				var e: Entry = src[ j ];
				
				if ( e != null )
				{
					src[ j ] = null;
					
					do
					{
						var next: Entry = e.next;
						var i: int = (e.hash & 0x7FFFFFFF) % newCapacity
						e.next = newTable[ i ];
						newTable[ i ] = e;
						e = next;
					} while ( e != null );
				}
			}
		}
	}
}