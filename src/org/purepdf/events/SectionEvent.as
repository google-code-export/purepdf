package org.purepdf.events
{
	import flash.events.Event;
	
	import org.purepdf.elements.Paragraph;
	
	public class SectionEvent extends Event
	{
		public static const SECTION_START: String = 'sectionStart';
		public static const SECTION_END: String = 'sectionEnd';
		
		public var position: Number;
		public var title: Paragraph;
		public var depth: int;
		
		public function SectionEvent( type: String, p: Number, d: int, t: Paragraph )
		{
			super( type, false, false );
			position = p;
			depth = d;
			title = t;
		}
	}
}