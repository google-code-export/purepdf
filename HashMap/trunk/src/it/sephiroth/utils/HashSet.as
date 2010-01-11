package it.sephiroth.utils
{
	import it.sephiroth.utils.collections.iterators.Iterator;

	public class HashSet
	{
		private static const serialVersionUID: Number = -5024744406713321676;
		private static const PRESENT: ObjectHash = new ObjectHash();

		private var map: HashMap;
		
		public function HashSet()
		{
			map = new HashMap();
		}
		
		/**
		 * Return an iterator for the elements on this set.
		 * The elements are returned without particular order
		 */
		public function iterator(): Iterator
		{
			return map.keySet().iterator();
		}
		
		/**
		 * Add a new element to the set if it is not already present.
		 * If the set already contains that element, the set remains unchanged and
		 * returns false
		 */
		public function add( o: Object ): Boolean
		{
			return map.put( o, PRESENT ) == null;
		}
		
		/**
		 * Return the current set length
		 */
		public function size(): int
		{
			return map.size();
		}
		
		public function clone(): Object
		{
			var newset: HashSet = new HashSet();
			newset.map = map.clone() as HashMap;
			return newset;
		}
		
		public function clear(): void
		{
			map.clear();
		}
		
		/**
		 * Remove the specified element if already present into the set.
		 * If the set does not contain the element it returns false
		 */
		public function remove( o: Object ): Boolean
		{
			return map.remove(o) == PRESENT;
		}
		
		/**
		 * Return true is the set lenght is 0
		 */
		public function isEmpty(): Boolean
		{
			return map.isEmpty();
		}

		/**
		 * Return true if the map contains the specified element
		 */
		public function contains( o: Object ): Boolean
		{
			return map.containsKey( o );
		}
	}
}