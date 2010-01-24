package org.purepdf.events
{
	import flash.events.Event;
	
	import org.purepdf.elements.Paragraph;
	
	public class SectionEvent extends Event
	{
		public static const SECTION_START: String = 'sectionStart';
		public static const SECTION_END: String = 'sectionEnd';
		
		protected var _position: Number;
		protected var _title: Paragraph;
		protected var _depth: int;
		
		public function SectionEvent( type: String, p: Number, d: int, t: Paragraph )
		{
			super( type, false, false );
			_position = p;
			_depth = d;
			_title = t;
		}
		
		override public function clone() : Event
		{
			return new SectionEvent( type, position, depth, title );
		}

		public function get depth():int
		{
			return _depth;
		}

		public function get title():Paragraph
		{
			return _title;
		}

		public function get position():Number
		{
			return _position;
		}

	}
}