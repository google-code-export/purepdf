package org.purepdf.pdf
{
	import org.purepdf.colors.RGBColor;

	public class PdfOutline extends PdfDictionary
	{
		private var _reference: PdfIndirectReference;
		private var _count: int = 0;
		private var _parent: PdfOutline;
		private var _kids: Vector.<PdfOutline> = new Vector.<PdfOutline>();
		private var _tag: String;
		private var _open: Boolean;
		private var _color: RGBColor;
		private var _style: int = 0;
		private var _destination: PdfDestination;
		
		protected var writer: PdfWriter;
		
		public function PdfOutline( $writer: PdfWriter )
		{
			super( OUTLINES );
			_open = true;
			_parent = null;
			writer = $writer;
		}
		
		public function get count():int
		{
			return _count;
		}

		public function set count(value:int):void
		{
			_count = value;
		}

		public function setDestinationPage( pageReference: PdfIndirectReference ): Boolean
		{
			if( _destination == null )
				return false;
			return _destination.addPage( pageReference );
		}
		
		public function get parent():PdfOutline
		{
			return _parent;
		}

		public function get indirectReference():PdfIndirectReference
		{
			return _reference;
		}

		public function set indirectReference(value:PdfIndirectReference):void
		{
			_reference = value;
		}

		public function get style():int
		{
			return _style;
		}

		public function set style(value:int):void
		{
			_style = value;
		}

		public function get color():RGBColor
		{
			return _color;
		}

		public function set color(value:RGBColor):void
		{
			_color = value;
		}

		public function isOpen():Boolean
		{
			return _open;
		}

		public function set open(value:Boolean):void
		{
			_open = value;
		}

		public function get title(): String
		{
			var title: PdfString = PdfString( getValue( PdfName.TITLE ) );
			return title.toString();
		}
		
		public function set title( value: String ): void
		{
			put( PdfName.TITLE, new PdfString( title, PdfObject.TEXT_UNICODE ) );
		}

		public function get tag():String
		{
			return _tag;
		}

		public function set tag(value:String):void
		{
			_tag = value;
		}

		public function get kids():Vector.<PdfOutline>
		{
			return _kids;
		}

		public function set kids(value:Vector.<PdfOutline>):void
		{
			_kids = value;
		}
		
		public function addKid( outline: PdfOutline ): void
		{
			_kids.push( outline );
		}

	}
}