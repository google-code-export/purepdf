package it.sephiroth.utils
{
	import it.sephiroth.utils.collections.iterators.Iterator;

	public class KeySet
	{
		private var _map: HashMap;
		
		public function KeySet( map: HashMap )
		{
			_map = map;
		}
		
		public function iterator(): Iterator
		{
			return new KeySeyIterator( _map );
		}
	}
}