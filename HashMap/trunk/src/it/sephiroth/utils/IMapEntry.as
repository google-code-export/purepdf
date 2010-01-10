package it.sephiroth.utils
{
	

	public interface IMapEntry
	{
		function getKey(): ObjectHash;
		function getValue(): ObjectHash;
		function setValue( newValue: ObjectHash ): ObjectHash;
		function equals( obj: ObjectHash ): Boolean;
		function hashCode(): int;
		function toString(): String;
	}
}