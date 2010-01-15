package org.purepdf.elements
{

	public class Chapter extends Section
	{
		private static const serialVersionUID: Number = 1791000695779357361;

		public function Chapter( $title: String, $number: int )
		{
			super( Paragraph.create( $title ), 1 );
			_numbers = new Vector.<Number>();
			_numbers.push( $number );
			_triggerNewPage = true;
		}

		override public function get isNestable(): Boolean
		{
			return false;
		}


		override public function get type(): int
		{
			return Element.CHAPTER;
		}
	}
}