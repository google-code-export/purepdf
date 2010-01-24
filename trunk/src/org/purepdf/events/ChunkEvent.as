package org.purepdf.events
{
	import flash.events.Event;
	
	import org.purepdf.elements.RectangleElement;
	
	public class ChunkEvent extends Event
	{
		public static const GENERIC_TAG: String = 'genericTag';
		
		protected var _rect: RectangleElement;
		protected var _tag: String;
		
		public function ChunkEvent( type: String, r: RectangleElement, t: String )
		{
			super( type, false, false );
			_rect = r;
			_tag = t;
		}

		override public function clone() : Event
		{
			return new ChunkEvent( type, rect, tag );
		}

		public function get tag():String
		{
			return _tag;
		}

		public function get rect():RectangleElement
		{
			return _rect;
		}

	}
}