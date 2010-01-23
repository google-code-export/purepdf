package org.purepdf
{
	public interface IComparable
	{
		/**
		 * @return  a negative integer, zero, or a positive integer as this object
     	 * is less than, equal to, or greater than the specified object.
	 	 */
		function compareTo( o: Object ): int;
	}
}