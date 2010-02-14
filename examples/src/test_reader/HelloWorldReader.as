package test_reader
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import it.sephiroth.utils.HashMap;
	
	import org.purepdf.pdf.PdfReader;
	import org.purepdf.pdf.SimpleBookmark;

	public class HelloWorldReader extends Sprite
	{
		private var file: String = "../output/HelloWorldBookmark.pdf";

		public function HelloWorldReader()
		{
			super();
			
			var loader: URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.load( new URLRequest( file ) );
		}
		
		private function onComplete( event: Event ): void
		{
			var pdf: ByteArray = URLLoader( event.target ).data as ByteArray;
			
			var k: int;
			var reader: PdfReader = new PdfReader( pdf );
			reader.readPdf();

			trace( "=== Document Information ===" );
			trace( "PDF Version: " + reader.pdfVersion );
			trace( "Number of pages: " + reader.getNumberOfPages() );
			trace( "File length: " + reader.getFileLength() );
			trace( "Encrypted? " + reader.isEncrypted() );
			trace( "Rebuilt? " + reader.isRebuilt() );

			trace( "=== Page Size ===" );
			for( k = 0; k < reader.getNumberOfPages(); ++k )
			{
				trace( "Page " + k + " size: " + reader.getPageSize( k+1 ) + "Rotation: " + reader.getPageRotation( k+1 ) );
			}

			trace( "=== bookmarks ===" );

			var list: Vector.<HashMap> = SimpleBookmark.getBookmark( reader );
			for ( k = 0; k < list.length; ++k )
			{
				showBookmark( list[k], 0 );
			}
		}

		protected static function showBookmark( bookmark: HashMap, indent: int ): void
		{
			var tab: String = "";
			var i: int;
			for ( i = 0; i < indent; i++ )
			{
				tab += "   ";
			}

			trace( tab + bookmark.getValue( "Title" ) );

			var kids: Vector.<HashMap> = bookmark.getValue( "Kids" ) as Vector.<HashMap>;
			if ( kids == null )
				return;
			for ( i = 0; i < kids.length; ++i )
			{
				showBookmark( kids[i], indent + 1 );
			}
		}
	}
}