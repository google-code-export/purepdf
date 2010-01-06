package org.purepdf.pdf
{
	import org.purepdf.IOutputStream;

	public class PdfIndirectReference extends PdfObject
	{
		private var _number: int;
		private var _generation: int = 0;
		
		public function PdfIndirectReference( $type: int = 0, $number: int = -1, $generation: int = 0 )
		{
			super( $type );
			
			if( $number > -1 )
			{
				_number = $number;
				_generation = $generation;
				setContent( number + " " + generation + " R" );
			}
		}

		public function get generation():int
		{
			return _generation;
		}

		public function get number():int
		{
			return _number;
		}
		
		override public function toString() : String
		{
			return number + " " + generation + " R";
		}

	}
}