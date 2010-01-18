package org.purepdf.elements
{

	public class Chapter extends Section
	{

		/**
		 * Create a new Chapter object
		 * 
		 * @param $title	String or Paragraph allowed
		 * @param $number	chapter number
		 * 
		 * @see org.purepdf.elements.Paragraph
		 */
		public function Chapter( $title: Object, $number: int )
		{
			super( $title is String ? Paragraph.create( String( $title ) ) : Paragraph( $title ), 1 );
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