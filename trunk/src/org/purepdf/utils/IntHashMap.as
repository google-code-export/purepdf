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
					while ((index-- > 0) && ((entry = table[index]) == null));
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
			
			for ( var e: Entry = table[index]; e != null; e = e.next )
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
			
			var e: Entry = new Entry( hash, key, value, table[index]);
			table[index] = e;
			_size++;
			return null;			
		}
		
		override public function remove(key:Object) : Object
		{
			var hash: int = int(key);
			var index: int = (hash & 0x7FFFFFFF) % table.length;
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
			for( var i = table.length; i-- > 0;) 
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