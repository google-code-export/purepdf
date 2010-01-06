package org.purepdf.pdf
{
	public class PdfLine
	{
		protected var line: Array;
		protected var _width: Number;
		protected var _height: Number;
		protected var _left: Number;
		protected var _right: Number;
		protected var _alignment: int;
		protected var originalWidth: Number;
		protected var isRTL: Boolean = false;
		protected var newlineSplit: Boolean = false;
		protected var symbolIndent: Number;
		
		public function PdfLine( $left: Number, $right: Number, $alignment: int, $height: Number )
		{
			_left = $left;
			_width = $right - $left;
			originalWidth = _width;
			_alignment = $alignment;
			_height = $height;
			line = new Array();
		}

		public function get alignment():int
		{
			return _alignment;
		}

		public function get right():Number
		{
			return _right;
		}

		public function get left():Number
		{
			return _left;
		}

		public function get width():Number
		{
			return _width;
		}

		public function get height():Number
		{
			return _height;
		}
		
		public function size(): int
		{
			return line.length;
		}
		

	}
}