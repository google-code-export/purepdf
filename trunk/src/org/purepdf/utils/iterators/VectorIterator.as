package org.purepdf.utils.iterators
{
	import it.sephiroth.utils.collections.iterators.Iterator;

	public class VectorIterator implements Iterator
	{
		protected var _data: Vector.<Object>;
		protected var pointer: int;
		
		public function VectorIterator( data: Vector.<Object> )
		{
			_data = data;
			pointer = 0;
		}
		
		public function get length(): int
		{
			return _data.length;
		}
		
		public function rewind(): void
		{
			pointer = 0;
		}
		
		public function hasNext(): Boolean
		{
			return _data.length > pointer;
		}
		
		public function next(): *
		{
			if( _data.length > pointer )
				return _data[pointer++];
			return null;
		}
		
		public function get index(): int
		{
			return pointer;
		}
	}
}