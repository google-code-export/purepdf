package org.purepdf.events
{
	import flash.events.Event;
	
	import org.purepdf.elements.Paragraph;
	
	public class ParagraphEvent extends Event
	{
		public static const PARAGRAPH_START: String = 'paragraphStart';
		public static const PARAGRAPH_END: String = 'paragraphEnd';
		
		public var position: Number;
		
		public function ParagraphEvent( type: String, p: Number )
		{
			super( type, false, false );
			position = p;
		}
	}
}