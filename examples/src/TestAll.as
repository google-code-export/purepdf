package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.utils.getQualifiedClassName;

	public class TestAll extends DefaultBasicExample
	{
		protected var class_list: Vector.<Class> = new Vector.<Class>();
		protected var filelist: Vector.<Array> = new Vector.<Array>();
		protected var total_number: int;
		protected var current_test_number: int = 0;
		
		protected var current: DefaultBasicExample;

		public function TestAll()
		{
			super();

			class_list.push( AnimatedGif );
			class_list.push( ClippingPath );
			class_list.push( DrawingPaths );
			class_list.push( GraphicState );
			class_list.push( ImageTypes );
			class_list.push( LineStyles );
			class_list.push( Patterns );
			class_list.push( SeparationColors );
			class_list.push( ShadingPatterns );
			class_list.push( SimpleAnnotation );
			class_list.push( ViewerExample );
			class_list.push( SlideShow );
			class_list.push( Layers );
			class_list.push( HelloWorld );
			class_list.push( HelloWorld2 );
			
			total_number = class_list.length;
		}

		override protected function createchildren(): void
		{
			description_container = new Sprite();
			addChild( description_container );
			
			
			create_class();
		}
		
		protected function create_class(): void
		{
			if ( class_list.length == 0 )
				return;

			current_test_number++;
			
			var cls: Class = class_list.shift();
			current = new cls();
			create_default_button( "(" + current_test_number + " of " + total_number + ") " + getQualifiedClassName( current ) );
			createDescription();
		}
		
		override internal function createDescription() : void
		{
			if( current )
			{
				description( current.description_list );
			}
		}

		override protected function execute( event: Event=null ): void
		{
			super.execute();

			var result: Array = current.executeAll();

			end_time = new Date().getTime();

			if ( result_time )
			{
				removeChild( result_time );
				result_time = null;
			}

			addResultTime( end_time - start_time );


			var f: FileReference = new FileReference();
			f.addEventListener( Event.COMPLETE, onSaveComplete );
			f.save( result[ 1 ], result[ 0 ] );

		}


		private function execute_next(): void
		{
			if ( create_button )
			{
				removeChild( create_button );
				create_button = null;
			}

			if ( result_time )
			{
				removeChild( result_time );
				result_time = null;
			}

			if ( class_list.length == 0 )
				return;
			
			create_class();
		}

		private function onSaveComplete( e: Event ): void
		{
			execute_next();
		}
	}
}