package org.purepdf.pdf
{
	import org.purepdf.Font;
	import org.purepdf.IOutputStream;
	import org.purepdf.colors.RGBColor;
	import org.purepdf.elements.Chunk;
	import org.purepdf.elements.Paragraph;

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
		protected var _destination: PdfDestination;
		protected var _writer: PdfWriter;
		protected var _action: PdfAction;
		
		public function PdfOutline( $writer: PdfWriter )
		{
			super( $writer == null ? null : OUTLINES );
			
			if( $writer != null )
			{
				_open = true;
				_parent = null;
				_writer = $writer;
			}
		}
		
		override public function toPdf(writer:PdfWriter, os:IOutputStream) : void
		{
			if( _color != null && !_color.equals( RGBColor.BLACK ) )
				put( PdfName.C, new PdfArray( Vector.<Number>([color.red/255, color.green/255, color.blue/255]) ) );
			
			var flag: int = 0;
			if( ( _style & Font.BOLD ) != 0 )
				flag |= 2;
			
			if ((_style & Font.ITALIC) != 0)
				flag |= 1;
			
			if (flag != 0)
				put(PdfName.F, new PdfNumber(flag));
			
			if (_parent != null)
				put(PdfName.PARENT, _parent.indirectReference);
			
			if (_destination != null && _destination.hasPage )
				put( PdfName.DEST, _destination);
			
			trace("PdfOutline.toPdf. Prtially implemented");
			
			if( _action != null)
				put( PdfName.A, _action );
			
			if( _count != 0) {
				put( PdfName.COUNT, new PdfNumber(_count));
			}
			super.toPdf(writer, os);
		}
		
		/**
		 * Constructs a PdfOutline
		 */

		public function get writer():PdfWriter
		{
			return _writer;
		}

		public function set writer(value:PdfWriter):void
		{
			_writer = value;
		}

		public static function create( parent: PdfOutline, destination: PdfDestination, title: Paragraph, open: Boolean ): PdfOutline
		{
			var p: PdfOutline = new PdfOutline( null );
			
			var buf: String = "";
			var chunks: Vector.<Object> = title.getChunks();
			
			for( var i: int = 0; i < chunks.length; ++i )
			{
				var chunk: Chunk = Chunk( chunks[i] );
				buf += chunk.content;
			}
			
			p._destination = destination;
			p.initOutline( parent, buf, open );
			return p;
		}
		
		internal function initOutline( parent: PdfOutline, title: String, open: Boolean ): void
		{
			_open = open;
			_parent = parent;
			_writer = parent.writer;
			put( PdfName.TITLE, new PdfString( title, PdfObject.TEXT_UNICODE ) );
			parent.addKid( this );
			if( _destination != null && !_destination.hasPage )
				setDestinationPage( writer.getCurrentPage() );
		}
		
		public function get level(): int
		{
			if( parent == null )
				return 0;
			return parent.level + 1;
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