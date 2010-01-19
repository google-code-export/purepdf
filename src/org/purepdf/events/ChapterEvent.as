package org.purepdf.events
{
	import flash.events.Event;
	
	import org.purepdf.elements.Paragraph;
	
	public class ChapterEvent extends Event
	{
		public static const CHAPTER_START: String = 'chapterStart';
		public static const CHAPTER_END: String = 'chapterEnd';
		
		public var position: Number;
		public var title: Paragraph;
		
		public function ChapterEvent( type: String, p: Number, t: Paragraph )
		{
			super( type, false, false );
			position = p;
			title = t;
		}
	}
}