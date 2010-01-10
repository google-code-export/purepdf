package it.sephiroth.utils
{
	public interface IMapEntry
	{
		function getKey(): Object;
		function getValue(): Object;
		function setValue( newValue: Object ): Object;
		function equals( obj: Object ): Boolean;
		function hashCode(): int;
		function toString(): String;
	}
}