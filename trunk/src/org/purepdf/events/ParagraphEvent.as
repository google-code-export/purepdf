package org.purepdf.events
{
	import flash.events.Event;
	
	public class ParagraphEvent extends Event
	{
		public static const PARAGRAPH_START: String = 'paragraphStart';
		public static const PARAGRAPH_END: String = 'paragraphEnd';
		
		protected var _position: Number;
		
		public function ParagraphEvent( type: String, p: Number )
		{
			super( type, false, false );
			_position = p;
		}
		
		public function get position():Number
		{
			return _position;
		}

		override public function clone() : Event
		{
			return new ParagraphEvent( type, position );
		}
	}
}