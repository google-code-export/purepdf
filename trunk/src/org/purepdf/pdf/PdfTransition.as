package org.purepdf.pdf
{
	import flash.utils.describeType;
	
	import it.sephiroth.utils.ObjectHash;

	public class PdfTransition extends ObjectHash
	{
		public static const BLINDH: int      = 6;
		public static const BLINDV: int      = 5;
		public static const BTWIPE: int      = 11;
		public static const DGLITTER: int    = 16;
		public static const DISSOLVE: int    = 13;
		public static const INBOX: int       = 7;
		public static const LRGLITTER: int   = 14;
		public static const LRWIPE: int      = 9;
		public static const OUTBOX: int      = 8;
		public static const RLWIPE: int      = 10;
		public static const SPLITHIN: int    = 4;
		public static const SPLITHOUT: int   = 2;
		public static const SPLITVIN: int    = 3;
		public static const SPLITVOUT: int   = 1;
		public static const TBGLITTER: int   = 15;
		public static const TBWIPE: int      = 12;

		protected var _duration: int;
		protected var _type: int;
		
		public static function get RANDOM(): PdfTransition
		{
			var r: int = Math.floor( Math.random() * 16 );
			return new PdfTransition( r+1 );
		}

		public function PdfTransition( $type: int, $duration: int = 1 )
		{
			_type = $type;
			_duration = $duration;
		}

		public function get duration(): int
		{
			return _duration;
		}
		
		public function set duration( value: int ): void
		{
			_duration = value;
		}

		internal function getTransitionDictionary(): PdfDictionary
		{
			var trans: PdfDictionary = new PdfDictionary( PdfName.TRANS );

			switch ( type )
			{
				case SPLITVOUT:
					trans.put( PdfName.S, PdfName.SPLIT );
					trans.put( PdfName.D, new PdfNumber( duration ) );
					trans.put( PdfName.DM, PdfName.V );
					trans.put( PdfName.M, PdfName.O );
					break;
				case SPLITHOUT:
					trans.put( PdfName.S, PdfName.SPLIT );
					trans.put( PdfName.D, new PdfNumber( duration ) );
					trans.put( PdfName.DM, PdfName.H );
					trans.put( PdfName.M, PdfName.O );
					break;
				case SPLITVIN:
					trans.put( PdfName.S, PdfName.SPLIT );
					trans.put( PdfName.D, new PdfNumber( duration ) );
					trans.put( PdfName.DM, PdfName.V );
					trans.put( PdfName.M, PdfName.I );
					break;
				case SPLITHIN:
					trans.put( PdfName.S, PdfName.SPLIT );
					trans.put( PdfName.D, new PdfNumber( duration ) );
					trans.put( PdfName.DM, PdfName.H );
					trans.put( PdfName.M, PdfName.I );
					break;
				case BLINDV:
					trans.put( PdfName.S, PdfName.BLINDS );
					trans.put( PdfName.D, new PdfNumber( duration ) );
					trans.put( PdfName.DM, PdfName.V );
					break;
				case BLINDH:
					trans.put( PdfName.S, PdfName.BLINDS );
					trans.put( PdfName.D, new PdfNumber( duration ) );
					trans.put( PdfName.DM, PdfName.H );
					break;
				case INBOX:
					trans.put( PdfName.S, PdfName.BOX );
					trans.put( PdfName.D, new PdfNumber( duration ) );
					trans.put( PdfName.M, PdfName.I );
					break;
				case OUTBOX:
					trans.put( PdfName.S, PdfName.BOX );
					trans.put( PdfName.D, new PdfNumber( duration ) );
					trans.put( PdfName.M, PdfName.O );
					break;
				case LRWIPE:
					trans.put( PdfName.S, PdfName.WIPE );
					trans.put( PdfName.D, new PdfNumber( duration ) );
					trans.put( PdfName.DI, new PdfNumber( 0 ) );
					break;
				case RLWIPE:
					trans.put( PdfName.S, PdfName.WIPE );
					trans.put( PdfName.D, new PdfNumber( duration ) );
					trans.put( PdfName.DI, new PdfNumber( 180 ) );
					break;
				case BTWIPE:
					trans.put( PdfName.S, PdfName.WIPE );
					trans.put( PdfName.D, new PdfNumber( duration ) );
					trans.put( PdfName.DI, new PdfNumber( 90 ) );
					break;
				case TBWIPE:
					trans.put( PdfName.S, PdfName.WIPE );
					trans.put( PdfName.D, new PdfNumber( duration ) );
					trans.put( PdfName.DI, new PdfNumber( 270 ) );
					break;
				case DISSOLVE:
					trans.put( PdfName.S, PdfName.DISSOLVE );
					trans.put( PdfName.D, new PdfNumber( duration ) );
					break;
				case LRGLITTER:
					trans.put( PdfName.S, PdfName.GLITTER );
					trans.put( PdfName.D, new PdfNumber( duration ) );
					trans.put( PdfName.DI, new PdfNumber( 0 ) );
					break;
				case TBGLITTER:
					trans.put( PdfName.S, PdfName.GLITTER );
					trans.put( PdfName.D, new PdfNumber( duration ) );
					trans.put( PdfName.DI, new PdfNumber( 270 ) );
					break;
				case DGLITTER:
					trans.put( PdfName.S, PdfName.GLITTER );
					trans.put( PdfName.D, new PdfNumber( duration ) );
					trans.put( PdfName.DI, new PdfNumber( 315 ) );
					break;
			}
			return trans;
		}

		public function get type(): int
		{
			return _type;
		}
	}
}