package org.purepdf.utils.collections
{
	public class Entry
	{
		private var key: Object;
		private var value: Object;
		
		public function Entry( $key: Object, $value: Object )
		{
			key = $key;
			value = $value;
		}
		
		public function getKey(): Object
		{
			return key;
		}
		
		public function getValue(): Object
		{
			return value;
		}
	}
}