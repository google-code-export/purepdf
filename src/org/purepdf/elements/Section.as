package org.purepdf.elements
{
	import flash.utils.getQualifiedClassName;
	
	import it.sephiroth.utils.collections.iterators.Iterator;
	
	import org.purepdf.IIterable;
	import org.purepdf.errors.CastTypeError;
	import org.purepdf.errors.DocumentError;
	import org.purepdf.errors.IllegalStateError;
	import org.purepdf.utils.iterators.VectorIterator;

	public class Section implements ITextElementaryArray, ILargeElement, IIterable
	{
		public static const NUMBERSTYLE_DOTTED: int = 0;
		public static const NUMBERSTYLE_DOTTED_WITHOUT_FINAL_DOT: int = 1;
		private static const serialVersionUID: Number = 3324172577544748043;
		protected var _title: Paragraph;
		protected var _bookmarkTitle: String;
		protected var _numberDepth: int = 0;
		protected var _numberStyle: int = NUMBERSTYLE_DOTTED;
		protected var _indentationLeft: Number = 0;
		protected var _indentationRight: Number = 0;
		protected var _indentation: Number = 0;
		protected var _bookmarkOpen: Boolean = true;
		protected var _triggerNewPage: Boolean = false;
		protected var subsections: int = 0;
		protected var _numbers: Vector.<Number> = null;
		protected var complete: Boolean = true;
		protected var _addedCompletely: Boolean = false;
		protected var _notAddedYet: Boolean = true;
		
		private var _arrayList: Vector.<IElement> = new Vector.<IElement>();
		
		public function Section( $title: Paragraph, $depth: int = 1 )
		{
			_title = $title ? $title : new Paragraph();
			_numberDepth = $depth;
		}
		
		public function get numberStyle():int
		{
			return _numberStyle;
		}

		public function get numbers():Vector.<Number>
		{
			return _numbers;
		}

		public function get triggerNewPage():Boolean
		{
			return _triggerNewPage;
		}

		public function set triggerNewPage(value:Boolean):void
		{
			_triggerNewPage = value;
		}

		public function get bookmarkOpen():Boolean
		{
			return _bookmarkOpen;
		}

		public function set bookmarkOpen(value:Boolean):void
		{
			_bookmarkOpen = value;
		}

		public function get indentation():Number
		{
			return _indentation;
		}

		public function set indentation(value:Number):void
		{
			_indentation = value;
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

		public function get numberDepth():int
		{
			return _numberDepth;
		}

		public function set numberDepth(value:int):void
		{
			_numberDepth = value;
		}

		public function getBookmarkTitle(): Paragraph
		{
			if( _bookmarkTitle == null )
				return _title;
			else
				return Paragraph.create( _bookmarkTitle );
		}

		public function set bookmarkTitle(value:String):void
		{
			_bookmarkTitle = value;
		}

		public function get title(): Paragraph
		{
			return constructTitle( _title, _numbers, _numberDepth, _numberStyle );
		}
		
		public function set title( value: Paragraph ): void
		{
			_title = value;
		}
		
		public static function constructTitle( title: Paragraph, numbers: Vector.<Number>, numberDepth: int, numberStyle: int ): Paragraph
		{
			if( title == null)
				return null;
			
			var depth: int = Math.min(numbers.length, numberDepth);
			if (depth < 1)
				return title;
			
			var buf: String = "";
			for( var i: int = 0; i < depth; i++)
			{
				buf = "." + buf;
				buf = numbers[i] + buf;
			}
			
			if( numberStyle == NUMBERSTYLE_DOTTED_WITHOUT_FINAL_DOT )
				buf = buf.substr( 0, buf.length - 3 ) + buf.substr( buf.length - 1 );
			
			var result: Paragraph = new Paragraph( title );
			result.insert( 0, new Chunk( buf, title.font ) );
			return result;
		}
		
		
		public function iterator(): Iterator
		{
			return new VectorIterator( Vector.<Object>(_arrayList) );
		}
		
		public function get size(): uint
		{
			return _arrayList.length;
		}
		
		public function flushContent(): void
		{
			notAddedYet = false;
			_title = null;
			var element: IElement;
			for( var i: VectorIterator = iterator() as VectorIterator; i.hasNext(); ) 
			{
				element = IElement(i.next());
				if (element is Section) 
				{
					var s: Section = Section(element);
					if( !s.isComplete && size == 1 )
					{
						s.flushContent();
						return;
					} else 
					{
						s.addedCompletely = true;
					}
				}
				i.remove();
			}
		}
		
		public function get isChapter(): Boolean
		{
			return type == Element.CHAPTER;
		}
		
		public function isSection(): Boolean
		{
			return type == Element.SECTION;
		}
		
		public function set chapterNumber( value: uint ): void
		{
			_numbers[ _numbers.length - 1 ] = value;
			var s: Object;
			
			for( var i: Iterator = iterator(); i.hasNext(); ) 
			{
				s = i.next();
				if (s is Section) {
					Section(s).chapterNumber = value;
				}
			}
		}
		
		public function get depth(): uint
		{
			return _numbers.length;
		}
		
		public function get notAddedYet():Boolean
		{
			return _notAddedYet;
		}

		public function set notAddedYet(value:Boolean):void
		{
			_notAddedYet = value;
		}

		public function get addedCompletely():Boolean
		{
			return _addedCompletely;
		}

		public function set addedCompletely(value:Boolean):void
		{
			_addedCompletely = value;
		}

		public function add(o:Object):Boolean
		{
			if( addedCompletely )
				throw new IllegalStateError("element has already been added to the document");
			
			var section: Section;
			
			try 
			{
				var element: IElement = IElement(o);
				if (element.type == Element.SECTION) {
					section = Section(o);
					section.setNumbers(++subsections, _numbers);
					_arrayList.push( section );
					return true;
				} else if (o is MarkedSection && ( MarkedObject(o).element.type == Element.SECTION ))
				{
					var mo: MarkedSection = MarkedSection(o);
					section = Section(mo.element);
					section.setNumbers(++subsections, _numbers);
					_arrayList.push(mo);
					return true;
				} else if (element.isNestable )
				{
					_arrayList.push(o);
					return true;
				} else {
					throw new CastTypeError( "cannot add " + getQualifiedClassName(element) + " to this section" );
				}
			} catch( cce: CastTypeError ) {
				throw new CastTypeError( "insertion of illegal element " + cce.getStackTrace() );
			}
			return false;
		}
		
		public function addAll( collection: Vector.<IElement> ): Boolean
		{
			_arrayList = _arrayList.concat( collection );
			return true;
		}
		
		private function setNumbers( number: Number, array: Vector.<Number> ): void
		{
			_numbers = new Vector.<Number>();
			_numbers.push( number );
			_numbers = _numbers.concat( array );
		}
		
		public function process(listener:IElementListener):Boolean
		{
			try
			{
				var element: IElement;
				for ( var i: Iterator = iterator(); i.hasNext(); )
				{
					element = IElement(i.next());
					listener.add( element );
				}
				return true;
			}
			catch( de: DocumentError ) {
			}
			return false;
		}
		
		public function getChunks():Vector.<Object>
		{
			var tmp: Vector.<Object> = new Vector.<Object>();
			for( var i: Iterator = iterator(); i.hasNext(); )
			{
				var e: IElement = IElement( i.next() );
				tmp = tmp.concat( e.getChunks() );
			}
			return tmp;
		}
		
		public function insert( index: int, o: Object ): void
		{
			if ( addedCompletely )
				throw new IllegalStateError("element has already been added to the document");

			try
			{
				var element: IElement = IElement(o);
				if (element.isNestable)
					_arrayList.splice( index, 0, element );
				else
					throw new CastTypeError("you cant add this element to the section");
			}
			catch( cce: CastTypeError )
			{
				throw new CastTypeError("insertion of illegal element. " +  cce.message );
			}
		}
		
		public function get isNestable():Boolean
		{
			return false;
		}
		
		public function get isContent():Boolean
		{
			return false;
		}
		
		public function toString():String
		{
			return null;
		}
		
		public function get type():int
		{
			return Element.SECTION;
		}
		
		public function get isComplete():Boolean
		{
			return complete;
		}
		
		public function set isComplete(value:Boolean):void
		{
			complete = value;
		}
		
		public function newPage(): void
		{
			this.add( Chunk.NEXTPAGE );
		}
		
		public function addMarkedSection(): MarkedSection
		{
			var section: MarkedSection = new MarkedSection( new Section( null, numberDepth + 1 ) );
			add( section );
			return section;
		}
		
		public function addSection3( indentation: Number, title: Paragraph ): Section
		{
			return addSection2( indentation, title, numberDepth + 1 );
		}
		
		public function addSection4( title: Paragraph, numberDepth: int ): Section
		{
			return addSection2( 0, title, numberDepth );
		}
		
		public function addSection5( indentation: Number, title: String, numberDepth: int ): Section
		{
			return addSection2( indentation, Paragraph.create( title ), numberDepth );
		}
		
		public function addSection6( title: String, numberDepth: int ): Section
		{
			return addSection4( Paragraph.create( title ), numberDepth );
		}
		
		public function addSection7( indentation: Number, title: String ): Section
		{
			return addSection3( indentation, Paragraph.create( title ) );
		}

		public function addSection( title: String ): Section
		{
			return addSection1( Paragraph.create( title ) );
		}
		
		public function addSection1( title: Paragraph ): Section
		{
			return addSection2( 0, title, numberDepth + 1 );
		}
		
		public function addSection2( indentation: Number, title: Paragraph, numberDepth: int ): Section
		{
			if( addedCompletely )
				throw new IllegalStateError("element has already been added to the document");
			
			var section: Section = new Section( title, numberDepth );
			section.indentation = indentation;
			add( section );
			return section;
		}
		
	}
}