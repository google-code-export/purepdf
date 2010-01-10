package it.sephiroth.utils
{

	public class EntrySetIterator extends HashMapIterator
	{
		public function EntrySetIterator( map: HashMap )
		{
			super( map );
		}

		override public function next(): *
		{
			return nextEntry();
		}
	}
}