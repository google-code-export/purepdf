package it.sephiroth.utils
{
	import it.sephiroth.utils.collections.iterators.Iterator;

	public class EntrySet
	{
		private var _map: HashMap;
		
		public function EntrySet( map: HashMap )
		{
			_map = map;
		}
			
		public function iterator(): Iterator
		{
			return new EntrySetIterator( _map );
		}
	}
}