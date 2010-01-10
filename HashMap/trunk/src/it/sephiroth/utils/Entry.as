package it.sephiroth.utils
{
	public final class Entry extends ObjectHash implements IMapEntry
	{
		internal var key: Object;
		internal var value: Object;
		
		internal var next: Entry;
		internal var hash: int;
		
		public function Entry( h: int, k: Object, v: Object, n: Entry )
		{
			value = v;
			key = k;
			next = n;
			hash = h;
		}
		
		public function getKey(): Object
		{
			return key;
		}
		
		public function getValue(): Object
		{
			return value;
		}
		
		public function setValue( newValue: Object ): Object
		{
			var oldValue: Object = value;
			value = newValue;
			return oldValue;
		}
		
		override public function equals( obj: Object ): Boolean
		{
			if(!( obj is IMapEntry ) )
				return false;
			
			var e: IMapEntry = IMapEntry( obj );
			var k1: Object = getKey();
			var k2: Object = e.getKey();
			
			if( k1 == k2 || ( k1 != null && HashMap.getGenericObjectEquals( k1, k2 ) )){
				var v1: Object = getValue();
				var v2: Object = e.getValue();
				if( v1 == v2 || (v1 != null && HashMap.getGenericObjectEquals( v1, v2 ) ))
					return true;
			}
			return false;
		}
		
		override public function hashCode(): int
		{
			return ( key == null ? 0 : key.hashCode() ) ^ ( value == null ? 0 : value.hashCode() );
		}
		
		public function toString(): String
		{
			return getKey() + " = " + getValue();
		}
		
		internal function recordAccess( m: HashMap ): void
		{
		}
		
		
		internal function recordRemoval( m: HashMap ): void
		{
		}

	}
}