package org.purepdf.elements
{
	import org.purepdf.Font;
	import org.purepdf.errors.DocumentError;
	import org.purepdf.factories.RomanAlphabetFactory;

	public class List implements ITextElementaryArray
	{
		public static const ORDERED: Boolean = true;
		public static const UNORDERED: Boolean = false;
		public static const NUMERICAL: Boolean = false;
		public static const ALPHABETICAL: Boolean = true;
		public static const UPPERCASE: Boolean = false;
		public static const LOWERCASE: Boolean = true;
		
		protected var list: Vector.<IElement> = new Vector.<IElement>();
		protected var _numbered: Boolean = false;
		protected var _lettered: Boolean = false;
		protected var _lowercase: Boolean = false;
		protected var _autoindent: Boolean = false;
		protected var _alignindent: Boolean = false;
		protected var _first: int = 1;
		protected var _symbol: Chunk = new Chunk("- ", new Font());
		protected var _preSymbol: String = "";
		protected var _postSymbol: String = ". ";
		protected var _indentationLeft: Number = 0;
		protected var _indentationRight: Number = 0;
		protected var _symbolIndent: Number = 0;
		
		public function List( $numbered: Boolean, $symbolIndent: Number = 0 )
		{
			_numbered = $numbered;
			_symbolIndent = $symbolIndent;
		}
		
		public function get symbolIndent():Number
		{
			return _symbolIndent;
		}

		public function set symbolIndent(value:Number):void
		{
			_symbolIndent = value;
		}

		public function get postSymbol():String
		{
			return _postSymbol;
		}

		public function set postSymbol(value:String):void
		{
			_postSymbol = value;
		}

		public function get preSymbol():String
		{
			return _preSymbol;
		}

		public function set preSymbol(value:String):void
		{
			_preSymbol = value;
		}

		public function get symbol():Chunk
		{
			return _symbol;
		}

		public function set symbol(value:Chunk):void
		{
			_symbol = value;
		}

		public function get first():int
		{
			return _first;
		}

		public function set first(value:int):void
		{
			_first = value;
		}

		public function get alignindent():Boolean
		{
			return _alignindent;
		}

		public function set alignindent(value:Boolean):void
		{
			_alignindent = value;
		}

		public function get autoindent():Boolean
		{
			return _autoindent;
		}

		public function set autoindent(value:Boolean):void
		{
			_autoindent = value;
		}

		public function get lowercase():Boolean
		{
			return _lowercase;
		}

		public function set lowercase(value:Boolean):void
		{
			_lowercase = value;
		}

		public function get lettered():Boolean
		{
			return _lettered;
		}

		public function set lettered(value:Boolean):void
		{
			_lettered = value;
		}

		public function get numbered():Boolean
		{
			return _numbered;
		}

		public function set numbered(value:Boolean):void
		{
			_numbered = value;
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
			var tmp: Vector.<Object> = new Vector.<Object>();
			for( var k: int = 0; k < list.length; ++k )
			{
				tmp = tmp.concat( list[k].getChunks() );
			}
			return tmp;
		}
		
		public function add( o: Object ): Boolean
		{
			if( o is ListItem )
			{
				var item: ListItem = ListItem(o);
				if( _numbered || _lettered )
				{
					var chunk: Chunk = new Chunk( _preSymbol, _symbol.font );
					var index: int = _first + list.length;
					if( _lettered )
						chunk.append( RomanAlphabetFactory.getString( index, _lowercase ) );
					else
						chunk.append( index.toString() );
					chunk.append( _postSymbol );
					item.listSymbol = chunk;
				} else
				{
					item.listSymbol = _symbol;
				}
				item.indentationLeft = _symbolIndent, _autoindent;
				item.indentationRight = 0;
				list.push( item );
				return true;
			} else if( o is List )
			{
				var nested: List = List(o);
				nested.indentationLeft = nested.indentationLeft + _symbolIndent;
				_first--;
				list.push( nested );
				return true;
			} else if( o is String )
			{
				add( new ListItem( String(o) ) );
				return true;
			}
			return false;
		}
		
		public function normalizeIndentation(): void
		{
			var max: Number = 0;
			var o: IElement;
			var k: int;
			for( k = 0; k < list.length; ++k )
			{
				o = IElement( list[k] );
				if( o is ListItem )
					max = Math.max( max, ListItem(o).indentationLeft );
			}
		
			for( k = 0; k < list.length; ++k )
			{
				o = IElement( list[k] );
				if (o is ListItem)
					ListItem(o).indentationLeft = max;
			}
		}
		
		public function get items(): Vector.<IElement>
		{
			return list;
		}
		
		public function get size(): uint
		{
			return list.length;
		}
		
		public function get isEmpty(): Boolean
		{
			return list.length == 0;
		}
		
		public function get totalLeading(): Number
		{
			if( list.length < 1 )
				return -1;
			
			var item: ListItem = ListItem(list[0]);
			return item.totalLeading;
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
			return Element.LIST;
		}
	}
}