package org.purepdf.elements
{
	import it.sephiroth.utils.collections.iterators.Iterator;
	
	import org.purepdf.errors.DocumentError;

	public class MarkedSection extends MarkedObject implements IElement
	{
		protected var _title: MarkedObject = null;

		public function MarkedSection( section: Section )
		{
			super();
			
			if( section.title != null )
			{
				title = new MarkedObject( section.title );
				section.title = null;
			}
			_element = section;
		}
		
		/**
		 * Adds a Paragraph, List, Table or Section to this Section.
		 */ 
		public function add( o: Object ): Boolean
		{
			return Section(element).add(o);
		}
		
		public function insert( index: int, o: Object ): void
		{
			Section(element).insert( index, o );
		}
		
		override public function process( listener: IElementListener ): Boolean
		{
			try 
			{
				var element: IElement;
				for ( var i: Iterator = Section(_element).iterator(); i.hasNext(); )
				{
					element = IElement(i.next());
					listener.addElement( element );
				}
				return true;
			}
			catch( de: DocumentError ) {
			}
			return false;
		}
		
		
		public function addAll( collection: Vector.<IElement> ): Boolean
		{
			return Section( element ).addAll( collection );
		}
		
		public function addSection3( indentation: Number, numberDepth: int ): MarkedSection
		{
			var section: MarkedSection = Section( element ).addMarkedSection();
			section.indentation = indentation;
			section.numberDepth = numberDepth;
			return section;
		}
		
		public function addSection2( indentation: Number ): MarkedSection
		{
			var section: MarkedSection = Section(element).addMarkedSection();
			section.indentation = indentation;
			return section;
		}
		
		public  function addSection1( numberDepth: Number ): MarkedSection
		{
			var section: MarkedSection = Section(element).addMarkedSection();
			section.numberDepth = numberDepth;
			return section;
		}
		
		public function addSection(): MarkedSection
		{
			return Section(element).addMarkedSection();
		}
		
		public function set title( title: MarkedObject ): void
		{
			if( title.element is Paragraph )
				_title = title;
		}
		
		public function get title(): MarkedObject
		{
			var result: Paragraph = Section.constructTitle( 
										Paragraph(title.element), 
										Section(element).numbers, 
										Section(element).numberDepth, 
										Section(element).numberStyle );
			
			var mo: MarkedObject = new MarkedObject( result );
			mo.markupAttributes = title.markupAttributes;
			return mo;
		}
		
		public function set numberDepth( value: int ): void
		{
			Section(element).numberDepth = value;
		}
		
		public function set indentationLeft( value: Number ): void
		{
			Section(element).indentationLeft = value;
		}
		   
		public function set indentationRight( value: Number ): void
		{
			Section(element).indentationRight = value;
		}
		
		public function set indentation( value: Number ): void
		{
			Section(element).indentation = value;
		}
		
		public function set bookmarkOpen( value: Boolean ): void
		{
			Section(element).bookmarkOpen = value;
		}
		
		public function set triggerNewPage( value: Boolean ): void
		{
			Section(element).triggerNewPage = value;
		}
		    
		public function set bookmarkTitle( value: String ): void
		{
			Section(element).bookmarkTitle = value;
		}
		
		public function newPage(): void
		{
			Section(element).newPage();
		}
	}
}