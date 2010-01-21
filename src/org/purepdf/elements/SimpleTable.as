package org.purepdf.elements
{
	public class SimpleTable extends RectangleElement implements ITextElementaryArray
	{
		public function SimpleTable($llx:Number, $lly:Number, $urx:Number, $ury:Number)
		{
			super($llx, $lly, $urx, $ury);
		}
		
		public function add(o:Object):Boolean
		{
			return false;
		}
	}
}