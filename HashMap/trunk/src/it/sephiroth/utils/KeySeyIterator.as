package it.sephiroth.utils
{

	public class KeySeyIterator extends HashMapIterator
	{
		public function KeySeyIterator( map: HashMap )
		{
			super( map );
		}

		override public function next(): *
		{
			return nextEntry().getKey();
		}
	}
}