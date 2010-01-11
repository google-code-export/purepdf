package it.sephiroth.utils
{
	import flash.utils.getQualifiedClassName;
	
	import it.sephiroth.utils.collections.iterators.Iterator;

	public class HashMap
	{
		private static const DEFAULT_INITIAL_CAPACITY: int = 32;
		private static const DEFAULT_LOAD_FACTOR: Number = 0.75;
		private static const MAXIMUM_CAPACITY: int = 1 << 30;
		private static const serialVersionUID: Number = 362498820763181265;
		private var _size: int;
		private var _entrySet: EntrySet;
		private var _keySet: KeySet;
		private var _values: ValueSet;
		private var loadFactor: Number;
		internal var modCount: int;
		
		internal var table: Vector.<Entry>;
		private var threshold: int;

		public function HashMap()
		{
			loadFactor = DEFAULT_LOAD_FACTOR;
			threshold = ( DEFAULT_INITIAL_CAPACITY * DEFAULT_LOAD_FACTOR );
			table = new Vector.<Entry>( DEFAULT_INITIAL_CAPACITY );
			init();
		}
		
		/**
		 * Return a view of the mappings of this map
		 * @see EntrySet
		 */
		public function entrySet(): EntrySet
		{
			if( _entrySet == null )
				_entrySet = new EntrySet( this );
			return _entrySet;
		}
		
		/**
		 * Return a view of the keys of this map
		 * @see KeySet
		 */
		public function keySet(): KeySet
		{
			if( _keySet == null )
				_keySet = new KeySet( this );
			return _keySet;
		}
		
		/**
		 * Return a view of the values of this map
		 * @see ValueSet
		 */
		public function values(): ValueSet
		{
			if( _values == null )
				_values = new ValueSet( this );
			return _values;
		}
		

		/**
		 * Removes all of the mappings from this map.
		 * The map will be empty after this call returns.
		 */
		public function clear(): void
		{
			modCount++;
			var tab: Vector.<Entry> = table;

			for ( var i: int = 0; i < tab.length; i++ )
				tab[ i ] = null;
			_size = 0;
		}

		/**
		 * Returns a shallow copy of this <tt>HashMap</tt> instance: the keys and
		 * values themselves are not cloned.
		 *
		 * @return a shallow copy of this map
		 */
		public function clone(): Object
		{
			var result: HashMap = new HashMap();
			result.table = new Vector.<Entry>( table.length );
			result.modCount = 0;
			result._size = 0;
			result.init();
			result.putAllForCreate( this );
			return result;
		}

		/**
		 * Return <code>true</code> if this map contains a mapping for the
		 * specified key
		 * 
		 */
		public function containsKey( key: Object ): Boolean
		{
			return getEntry( key ) != null;
		}

		/**
		 * Returns <tt>true</tt> if this map maps one or more keys to the
		 * specified value.
		 *
		 * @param value value whose presence in this map is to be tested
		 * @return <tt>true</tt> if this map maps one or more keys to the
		 *         specified value
		 */
		public function containsValue( value: Object ): Boolean
		{
			if ( value == null )
				return containsNullValue();

			var tab: Vector.<Entry> = table;

			for ( var i: int = 0; i < tab.length; i++ )
				for ( var e: Entry = tab[ i ]; e != null; e = e.next )
					if( getGenericObjectEquals( value, e.value ) )
						return true;
			return false;
		}
		
		/**
		 * Check if 2 objects are equals
		 * if the first object is ObjectHash then uses its equals method
		 */
		public static function getGenericObjectEquals( element1: Object, element2: Object ): Boolean
		{
			if( element1 is ObjectHash )
				return ObjectHash( element1 ).equals( element2 );
			return element1 == element2;
		}
		
		/**
		 * Get hash code for a generic object
		 */
		public static function getGenericObjectHashCode( obj: Object ): int
		{
			if( obj is ObjectHash )
				return hash( ObjectHash( obj ).hashCode() );
			
			if( obj is String )
				return hash(getHashCodeForString(String(obj)));
			else if( obj is Number )
				return hash( hashLib.hashCode(obj.toString()));
			else
				return hash( hashLib.hashCode(getQualifiedClassName(obj)));
		}
		
		public static function getHashCodeForString( obj: String ): int
		{
			var h: int = 0;
			var off: int = 0;
			var len: int = obj.length;
			
			for( var i: int = 0; i < len; i++ )
			{
				h = 31*h + obj.charCodeAt(off++);
			}
			return h;
		}		

		/**
		 * Return the value of which the specified key is mapped
		 * or {@code null} if this map contains no mapping for the key
		 */
		public function getValue( key: Object ): Object
		{
			if ( key == null )
				return getForNullKey();
			var tmp_hash: int = getGenericObjectHashCode(key);/* hash( key.hashCode() );*/

			for ( var e: Entry = table[ indexFor( tmp_hash, table.length ) ]; e != null; e = e.next )
			{
				var k: Object;

				if ( e.hash == tmp_hash && ( ( k = e.key ) == key || getGenericObjectEquals( key, k ) ) )
					return e.value;
			}
			return null;
		}

		public function isEmpty(): Boolean
		{
			return _size == 0;
		}

		/**
		 * Associate the specified value with the specified key in this map.
		 * If the map already contains a mapping for the key, the old value
		 * is replaced
		 * 
		 * @return	the previous value associated with the key of <code>null</code>
		 * 			if there was no mapping for the key.
		 */
		public function put( key: Object, value: Object ): Object
		{
			if ( key == null )
				return putForNullKey( value );
			var h: int = getGenericObjectHashCode(key);/* hash( key.hashCode() );*/
			var i: int = indexFor( h, table.length );

			for ( var e: Entry = table[ i ]; e != null; e = e.next )
			{
				var k: Object;

				if ( e.hash == h && ( ( k = e.key ) == key || getGenericObjectEquals( key, k ) ) )
				{
					var oldValue: Object = e.value;
					e.value = value;
					e.recordAccess( this );
					return oldValue;
				}
			}

			modCount++;
			addEntry( h, key, value, i );
			return null;
		}

		/**
		 * Copies all of the mappings from the specified map to this map.
		 * These mappings will replace any mappings that this map had for
		 * any of the keys currently in the specified map.
		 */
		public function putAll( m: HashMap ): void
		{
			var numKeysToBeAdded: int = m.size();

			if ( numKeysToBeAdded == 0 )
				return;

			if ( numKeysToBeAdded > threshold )
			{
				var targetCapacity: int = ( numKeysToBeAdded / loadFactor + 1 );

				if ( targetCapacity > MAXIMUM_CAPACITY )
					targetCapacity = MAXIMUM_CAPACITY;
				var newCapacity: int = table.length;

				while ( newCapacity < targetCapacity )
					newCapacity <<= 1;

				if ( newCapacity > table.length )
					resize( newCapacity );
			}

			var i: Iterator = m.entrySet().iterator();
			for( i; i.hasNext(); )
			{
				var e: Entry = i.next();
				put( e.getKey(), e.getValue() );
			}
		}

		/**
		 * Removes the mapping for the specified key from this map if present.
		 *
		 * @param  key key whose mapping is to be removed from the map
		 * @return the previous value associated with <tt>key</tt>, or
		 *         <tt>null</tt> if there was no mapping for <tt>key</tt>.
		 *         (A <tt>null</tt> return can also indicate that the map
		 *         previously associated <tt>null</tt> with <tt>key</tt>.)
		 */
		public function remove( key: Object ): Object
		{
			var e: Entry = removeEntryForKey( key );
			return ( e == null ? null : e.value );
		}

		/**
		 * Returns the current map size
		 */
		public function size(): int
		{
			return _size;
		}

		protected function addEntry( hash: int, key: Object, value: Object, bucketIndex: int ): void
		{
			var e: Entry = table[ bucketIndex ];
			table[ bucketIndex ] = new Entry( hash, key, value, e );

			if ( _size++ >= threshold )
				resize( 2 * table.length );
		}


		protected function init(): void
		{
		}

		internal function getEntry( key: Object ): Entry
		{
			var h: int = ( key == null ) ? 0 : getGenericObjectHashCode(key);/* hash( key.hashCode() );*/

			for ( var e: Entry = table[ indexFor( h, table.length ) ]; e != null; e = e.next )
			{
				var k: Object;

				if ( e.hash == h && ( ( ( k = e.key ) == key ) || ( key != null && getGenericObjectEquals( key, k ) ) ) )
					return e;
			}
			return null;
		}

		/**
		 * Removes and returns the entry associated with the specified key
		 * in the HashMap.  Returns null if the HashMap contains no mapping
		 * for this key.
		 */
		internal function removeEntryForKey( key: Object ): Entry
		{
			var h: int = ( key == null ) ? 0 : getGenericObjectHashCode( key ); /*hash( key.hashCode() );*/
			var i: int = indexFor( h, table.length );
			var prev: Entry = table[ i ];
			var e: Entry = prev;

			while ( e != null )
			{
				var next: Entry = e.next;
				var k: Object;

				if ( e.hash == h && ( ( k = e.key ) == key || ( key != null && getGenericObjectEquals( key, k ) ) ) )
				{
					modCount++;
					_size--;

					if ( prev == e )
						table[ i ] = next;
					else
						prev.next = next;
					e.recordRemoval( this );
					return e;
				}
				prev = e;
				e = next;
			}
			return e;
		}

		internal function removeMapping( o: Object ): Entry
		{
			if ( !( o is IMapEntry ) )
				return null;

			var entry: Entry = Entry( o );
			var key: Object = entry.getKey();
			var h: int = ( key == null ) ? 0 : getGenericObjectHashCode( key ); /*hash( key.hashCode() ); */
			var i: int = indexFor( h, table.length );
			var prev: Entry = table[ i ];
			var e: Entry = prev;

			while ( e != null )
			{
				var next: Entry = e.next;

				if ( e.hash == h && e.equals( entry ) )
				{
					modCount++;
					_size--;

					if ( prev == e )
						table[ i ] = next;
					else
						prev.next = next;
					e.recordRemoval( this );
					return e;
				}
				prev = e;
				e = next;
			}

			return e;
		}

		/**
		 * Special-case code for containsValue with null argument
		 */
		private function containsNullValue(): Boolean
		{
			var tab: Vector.<Entry> = table;

			for ( var i: int = 0; i < tab.length; i++ )
				for ( var e: Entry = tab[ i ]; e != null; e = e.next )
					if ( e.value == null )
						return true;
			return false;
		}


		/**
		 * Like addEntry except that this version is used when creating entries
		 * as part of Map construction or "pseudo-construction" (cloning,
		 * deserialization).  This version needn't worry about resizing the table.
		 *
		 * Subclass overrides this to alter the behavior of HashMap(Map),
		 * clone, and readObject.
		 */
		private function createEntry( hash: int, key: Object, value: Object, bucketIndex: int ): void
		{
			var e: Entry = table[ bucketIndex ];
			table[ bucketIndex ] = new Entry( hash, key, value, e );
			_size++;
		}


		private function getForNullKey(): Object
		{
			for ( var e: Entry = table[ 0 ]; e != null; e = e.next )
			{
				if ( e.key == null )
					return e.value;
			}
			return null;
		}

		private function putAllForCreate( m: HashMap ): void
		{
			var i: Iterator = m.entrySet().iterator();
			for( i; i.hasNext(); )
			{
				var e: Entry = i.next();
				putForCreate( e.getKey(), e.getValue() );
			}
		}

		private function putForCreate( key: Object, value: Object ): void
		{
			var h: int = ( key == null ) ? 0 : hash( key.hashCode() );
			var i: int = indexFor( h, table.length );

			for ( var e: Entry = table[ i ]; e != null; e = e.next )
			{
				var k: Object;

				if ( e.hash == h && ( ( k = e.key ) == key || ( key != null && getGenericObjectEquals( key, k ) ) ) )
				{
					e.value = value;
					return;
				}
			}
		}

		private function putForNullKey( value: Object ): Object
		{
			for ( var e: Entry = table[ 0 ]; e != null; e = e.next )
			{
				if ( e.key == null )
				{
					var oldValue: Object = e.value;
					e.value = value;
					e.recordAccess( this );
					return oldValue;
				}
			}

			modCount++;
			addEntry( 0, null, value, 0 );
			return null;
		}


		private function resize( newCapacity: int ): void
		{
			var oldTable: Vector.<Entry> = table;
			var oldCapacity: int = oldTable.length;

			if ( oldCapacity == MAXIMUM_CAPACITY )
			{
				threshold = uint( -1 );
				return;
			}

			var newTable: Vector.<Entry> = new Vector.<Entry>( newCapacity );
			transfer( newTable );
			table = newTable;
			threshold = ( newCapacity * loadFactor );
		}

		private function transfer( newTable: Vector.<Entry> ): void
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
						var i: int = indexFor( e.hash, newCapacity );
						e.next = newTable[ i ];
						newTable[ i ] = e;
						e = next;
					} while ( e != null );
				}
			}
		}

		protected static function hash( h: int ): int
		{
			h ^= ( h >>> 20 ) ^ ( h >>> 12 );
			return h ^ ( h >>> 7 ) ^ ( h >>> 4 );
		}

		protected static function indexFor( h: int, length: int ): int
		{
			return h & ( length - 1 );
		}
	}
}