package org.purepdf.elements
{
	import org.purepdf.errors.NonImplementatioError;

	public class TextElementaryArray extends Element
	{
		public function TextElementaryArray()
		{
			super();
		}
		
		public function add( o: Object ): Boolean
		{
			throw new NonImplementatioError();
		}
	}
}