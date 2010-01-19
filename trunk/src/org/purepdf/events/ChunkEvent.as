package org.purepdf.events
{
	import flash.events.Event;
	
	import org.purepdf.elements.RectangleElement;
	
	public class ChunkEvent extends Event
	{
		public static const GENERIC_TAG: String = 'genericTag';
		
		public var rect: RectangleElement;
		public var tag: String;
		
		public function ChunkEvent( type: String, r: RectangleElement, t: String )
		{
			super( type, false, false );
			rect = r;
			tag = t;
		}
	}
}