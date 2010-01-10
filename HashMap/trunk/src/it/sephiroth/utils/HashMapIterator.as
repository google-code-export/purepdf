package it.sephiroth.utils
{
	import it.sephiroth.utils.collections.iterators.Iterator;

	public class HashMapIterator implements Iterator
	{
		private var _current: Entry;
		private var _index: int = 0;
		private var _map: HashMap;
		private var _next: Entry;

		public function HashMapIterator( map: HashMap )
		{
			_map = map;

			if ( _map.size() > 0 )
			{
				while ( _index < _map.table.length && ( _next = _map.table[ _index++ ] ) == null ){}
			}
		}

		public function hasNext(): Boolean
		{
			return _next != null;
		}

		protected function nextEntry(): Entry
		{
			var e: Entry = _next;
			if( e == null )
				throw new Error();
			
			if(( _next = e.next ) == null )
			{
				while ( _index < _map.table.length && ( _next = _map.table[ _index++ ] ) == null ){}
			}
			_current = e;
			return e;
		}
		
		public function next(): *
		{
			return nextEntry();
		}
	}
}