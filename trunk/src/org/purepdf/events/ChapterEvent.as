package org.purepdf.events
{
	import flash.events.Event;
	
	import org.purepdf.elements.Paragraph;
	
	public class ChapterEvent extends Event
	{
		public static const CHAPTER_START: String = 'chapterStart';
		public static const CHAPTER_END: String = 'chapterEnd';
		
		protected var _position: Number;
		protected var _title: Paragraph;
		
		public function ChapterEvent( type: String, p: Number, t: Paragraph )
		{
			super( type, false, false );
			_position = p;
			_title = t;
		}
		
		public function get title():Paragraph
		{
			return _title;
		}

		public function get position():Number
		{
			return _position;
		}

		override public function clone() : Event
		{
			return new ChapterEvent( type, _position, _title );
		}
	}
}