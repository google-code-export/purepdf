package org.purepdf.events
{
	import flash.events.Event;
	
	public class PageEvent extends Event
	{
		public static const OPEN_DOCUMENT: String = 'openDocument';
		public static const START_PAGE: String = 'startPage';
		public static const END_PAGE: String = 'endPage';
		public static const CLOSE_DOCUMENT: String = 'closeDocument';
		
		public function PageEvent( type: String, bubbles: Boolean = false, cancelable: Boolean = false )
		{
			super( type, bubbles, cancelable );
		}
	}
}