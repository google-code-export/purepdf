package org.purepdf.elements
{
	/**
	 * Chapter with auto numbering
	 * 
	 */
	public class ChapterAutoNumber extends Chapter
	{
		protected var numberSet: Boolean = false;
		
		public function ChapterAutoNumber( $title: Object )
		{
			super( $title, 0 );
		}
		
		override public function addSection(title:String) : Section
		{
			return addSection6( title, 2 );
		}
		
		override public function addSection1(title:Paragraph) : Section
		{
			return addSection4( title, 2 );
		}
		
		/**
		 * Changes the chapter number
		 */
		public function setAutomaticNumber( value: int ): int
		{
			if (!numberSet) {
				value++;
				super.chapterNumber = value;
				numberSet = true;
			}
			return value;
		}
	}
}