package org.purepdf.elements
{
	import org.purepdf.Font;
	import org.purepdf.errors.DocumentError;
	import org.purepdf.errors.NonImplementatioError;

	public class List implements ITextElementaryArray
	{
		public static const ORDERED: Boolean = true;
		public static const UNORDERED: Boolean = false;
		public static const NUMERICAL: Boolean = false;
		public static const ALPHABETICAL: Boolean = true;
		public static const UPPERCASE: Boolean = false;
		public static const LOWERCASE: Boolean = true;
		
		protected var list: Vector.<IElement> = new Vector.<IElement>();
		protected var numbered: Boolean = false;
		protected var lettered: Boolean = false;
		protected var lowercase: Boolean = false;
		protected var autoindent: Boolean = false;
		protected var alignindent: Boolean = false;
		protected var first: int = 1;
		protected var symbol: Chunk = new Chunk("- ", new Font());
		protected var preSymbol: String = "";
		protected var postSymbol: String = ". ";
		protected var _indentationLeft: Number = 0;
		protected var _indentationRight: Number = 0;
		protected var symbolIndent: Number = 0;
		
		public function List()
		{
		}
		
		public function get indentationRight():Number
		{
			return _indentationRight;
		}

		public function set indentationRight(value:Number):void
		{
			_indentationRight = value;
		}

		public function get indentationLeft():Number
		{
			return _indentationLeft;
		}

		public function set indentationLeft(value:Number):void
		{
			_indentationLeft = value;
		}

		public function add(o:Object):Boolean
		{
			return false;
		}
		
		public function process(listener:IElementListener):Boolean
		{
			try
			{
				for( var k: int = 0; k < list.length; ++k )
					listener.add( list[k] );
				return true;
			} catch( e: DocumentError )
			{
				return false;
			}
			return false;
		}
		
		public function getChunks():Vector.<Object>
		{
			throw new NonImplementatioError();
		}
		
		public function get isNestable():Boolean
		{
			return true;
		}
		
		public function get isContent():Boolean
		{
			return true;
		}
		
		public function toString():String
		{
			return null;
		}
		
		public function get type():int
		{
			return 0;
		}
	}
}