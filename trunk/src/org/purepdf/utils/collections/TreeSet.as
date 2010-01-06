package org.purepdf.utils.collections
{
	import org.purepdf.IComparable;
	import org.purepdf.utils.iterators.Iterator;
	import org.purepdf.utils.iterators.VectorIterator;

	public class TreeSet
	{
		protected var map: Vector.<IComparable>;
		
		public function TreeSet()
		{
			map = new Vector.<IComparable>();
		}
		
		public function iterator(): Iterator
		{
			return new VectorIterator( Vector.<Object>( map ) );
		}
		
		public function add( element: IComparable ): Boolean
		{
			var exists: Boolean = exists( element );
			if( exists )
				return false;
			
			map.push( element );
			map = map.sort( compare );
			return true;
		}
		
		private function exists( element: IComparable ): Boolean
		{
			for( var a: int = 0; a < map.length; a++ )
			{
				if( map[a].compareTo( element ) == 0 )
					return true;
			}
			return false;
		}
		
		private function indexOf( element: IComparable ): int
		{
			for( var a: int = 0; a < map.length; a++ )
			{
				if( map[a].compareTo( element ) == 0 )
					return a;
			}
			return -1;
		}
		
		public function remove( element: IComparable ): Boolean
		{
			var index: int = indexOf( element );
			if( index == -1 ) return false;
			map.splice( index, 1 );
			return true;
		}
		
		public function first(): IComparable
		{
			return map[0];
		}
		
		public function last(): IComparable
		{
			return map[ map.length - 1 ];
		}
		
		private function compare( element1: IComparable, element2: IComparable ): Number
		{
			return element1.compareTo( element2 );
		}
	}
}