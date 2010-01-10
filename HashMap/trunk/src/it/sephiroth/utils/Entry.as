package it.sephiroth.utils
{
	public final class Entry extends ObjectHash implements IMapEntry
	{
		internal var key: ObjectHash;
		internal var value: ObjectHash;
		
		internal var next: Entry;
		internal var hash: int;
		
		public function Entry( h: int, k: ObjectHash, v: ObjectHash, n: Entry )
		{
			value = v;
			key = k;
			next = n;
			hash = h;
		}
		
		public function getKey(): ObjectHash
		{
			return key;
		}
		
		public function getValue(): ObjectHash
		{
			return value;
		}
		
		public function setValue( newValue: ObjectHash ): ObjectHash
		{
			var oldValue: ObjectHash = value;
			value = newValue;
			return oldValue;
		}
		
		override public function equals( obj: ObjectHash ): Boolean
		{
			if(!( obj is IMapEntry ) )
				return false;
			
			var e: IMapEntry = IMapEntry( obj );
			var k1: ObjectHash = getKey();
			var k2: ObjectHash = e.getKey();
			
			if( k1 == k2 || ( k1 != null && k1.equals(k2))){
				var v1: ObjectHash = getValue();
				var v2: ObjectHash = e.getValue();
				if( v1 == v2 || (v1 != null && v1.equals(v2)))
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