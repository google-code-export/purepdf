package it.sephiroth.utils
{
	import flash.utils.getQualifiedClassName;
	

	public class ObjectHash extends Object implements IObject
	{
		protected var _hashCode: int;

		public function hashCode(): int
		{
			if ( isNaN( _hashCode ) )
				_hashCode = hashLib.hashCode( getQualifiedClassName( this ) );
			return _hashCode;
		}
		
		public function equals( obj: Object ): Boolean
		{
			return this == obj;
		}
	}
}