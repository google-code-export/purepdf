package org.purepdf.events
{
	import flash.events.Event;
	
	public class PageEvent extends Event
	{
		public static const DOCUMENT_OPEN: String = 	'documentStart';
		public static const PAGE_START: String = 		'pageStart';
		public static const PAGE_END: String = 			'pageEnd';
		public static const DOCUMENT_CLOSE: String = 	'documentClose';
		
		public function PageEvent( type: String, bubbles: Boolean = false, cancelable: Boolean = false )
		{
			super( type, bubbles, cancelable );
		}
		
		override public function clone() : Event
		{
			return new PageEvent( type, bubbles, cancelable );
		}
	}
}