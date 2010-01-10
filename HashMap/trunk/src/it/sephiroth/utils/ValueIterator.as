package it.sephiroth.utils
{

	public class ValueIterator extends HashMapIterator
	{

		public function ValueIterator( map: HashMap )
		{
			super( map );
		}

		override public function next(): *
		{
			return nextEntry().value;
		}
	}
}