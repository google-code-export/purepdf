package org.purepdf
{
	import org.purepdf.utils.ObjectUtils;

	public class ObjectHash extends Object implements IObject
	{
		protected var _hashCode: int;

		public function hashCode(): int
		{
			if ( isNaN( _hashCode ) )
				_hashCode = ObjectUtils.hashCode( this );
			return _hashCode;
		}
		
		public function equals( obj: ObjectHash ): Boolean
		{
			return this == obj;
		}
	}
}