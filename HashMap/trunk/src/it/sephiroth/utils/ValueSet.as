package it.sephiroth.utils
{
	import it.sephiroth.utils.collections.iterators.Iterator;

	public class ValueSet
	{
		private var _map: HashMap;
		
		public function ValueSet( map: HashMap )
		{
			_map = map;
		}
		
		public function iterator(): Iterator
		{
			return new ValueIterator( _map );
		}
	}
}