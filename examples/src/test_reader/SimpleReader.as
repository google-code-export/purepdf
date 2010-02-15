package test_reader
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	public class SimpleReader extends Sprite
	{
		protected var file: String;
		protected var pdf: ByteArray;
		
		public function SimpleReader( file: String )
		{
			super();
			
			this.file = file;
			addEventListener( Event.ADDED_TO_STAGE, onAdded );
		}
		
		protected function onAdded( event: Event ): void
		{
			var loader: URLLoader = new URLLoader();
			loader.addEventListener( Event.COMPLETE, onComplete);
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.load( new URLRequest( this.file ) );
		}
		
		protected function onComplete( event: Event ): void
		{
			pdf = URLLoader( event.target ).data as ByteArray;
		}
	}
}