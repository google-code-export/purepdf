package org.purepdf.pdf
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	[Event( name="complete", type="flash.events.Event" )]
	[Event( name="error", type="flash.events.errors.ErrorEvent" )]
	[Event( name="progress", type="flash.events.ProgressEvent" )]
	public class PRDocObjectReader extends EventDispatcher
	{
		public var streams: Vector.<PdfObject>;
		
		private var tokens: PRTokeniser;
		private var xref: Vector.<int>;
		private var xrefObj: Vector.<PdfObject>;
		private var reader: PdfReader;
		private var k: int;
		private var progress_event: ProgressEvent;

		public function PRDocObjectReader( pdf: PdfReader )
		{
			super( null );
			reader = pdf;
		}

		public function run(): void
		{
			streams = new Vector.<PdfObject>();
			xrefObj = reader.getxrefobj();
			xref = reader.getxref();
			tokens = reader.getTokens();
			k = 2;
			setTimeout( step, 100 );
			progress_event = new ProgressEvent( ProgressEvent.PROGRESS, false, false, 0, xref.length );
		}

		public function dispose(): void
		{
			xref = null;
			reader = null;
			xrefObj = null;
		}

		private function step(): void
		{
			try
			{
				var timer: Number = getTimer();
				while ( getTimer() - timer < 500 )
				{
					if( k < xref.length )
					{
						var pos: int = xref[k];
						if ( pos <= 0 || xref[k + 1] > 0 )
						{
							k += 2;
							continue;
						}
						tokens.seek( pos );
						tokens.nextValidToken();
						if ( tokens.getTokenType() != PRTokeniser.TK_NUMBER )
							tokens.throwError( "invalid object number" );
						reader.setObjNum( tokens.intValue() );
						tokens.nextValidToken();
						if ( tokens.getTokenType() != PRTokeniser.TK_NUMBER )
							tokens.throwError( "invalid generation number" );
						reader.setObjGen( tokens.intValue() );
						tokens.nextValidToken();
						if ( tokens.getStringValue() != "obj" )
							tokens.throwError( "token obj expected" );
						var obj: PdfObject;
						try
						{
							obj = reader.readPRObject();
							if ( obj.isStream() )
							{
								streams.push( obj );
							}
						} catch ( e: Error )
						{
							obj = null;
						}
						xrefObj[k / 2] = obj;
						
						progress_event.bytesLoaded = k;
						dispatchEvent( progress_event ); 
						
						k += 2;
					} else
					{
						dispatchEvent( new Event( Event.COMPLETE ) );
						return;
					}
				}
				setTimeout( step, 100 );
			} catch( e: Error )
			{
				dispatchEvent( new ErrorEvent( ErrorEvent.ERROR, false, false, e.message ) );
			}
		}
	}
}