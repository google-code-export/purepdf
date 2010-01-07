package org.purepdf.pdf
{
	import org.purepdf.IOutputStream;
	import org.purepdf.utils.iterators.VectorIterator;

	public class PdfArray extends PdfObject
	{
		protected var arrayList: Vector.<PdfObject>;

		public function PdfArray( object: Object = null )
		{
			super( ARRAY );
			arrayList = new Vector.<PdfObject>();

			if( object )
			{
				if ( object is PdfObject )
					arrayList.push( object );
				else if( object is Vector.<Number> )
					add2( Vector.<Number>( object ) );
				else if( object is Vector.<int> )
					add3( Vector.<int>( object ) );
			}
		}

		/**
		 * Add a PdfObject to the end of the PdfArray
		 * 
		 */
		public function add( object: PdfObject ): uint
		{
			return arrayList.push( object );
		}
		
		/**
		 * Add an array of numbers to the end of the PdfArray
		 * 
		 */
		public function add2( values: Vector.<Number> ): Boolean
		{
			for( var k: int = 0; k < values.length; ++k )
				arrayList.push( new PdfNumber( values[k] ) );
			return true;
		}
		
		/**
		 * Add and array of integer to the end of the PdfArray
		 * 
		 */
		public function add3( values: Vector.<int> ): Boolean
		{
			for( var k: int = 0; k < values.length; ++k )
				arrayList.push( new PdfNumber( values[k] ) );
			return true;
		}

		[Deprecated]
		public function getArrayList(): Vector.<PdfObject>
		{
			return arrayList;
		}

		public function isEmpty(): Boolean
		{
			return arrayList.length == 0;
		}

		public function size(): int
		{
			return arrayList.length;
		}

		/**
		 * Writes the PDF representation of this <CODE>PdfArray</CODE> as an array
		 * of <CODE>byte</CODE> to the specified <CODE>OutputStream</CODE>.
		 *
		 * @param writer for backwards compatibility
		 * @param os the <CODE>OutputStream</CODE> to write the bytes to.
		 */
		override public function toPdf( writer: PdfWriter, os: IOutputStream ): void
		{
			os.writeInt( '['.charCodeAt( 0 ) );
			var object: PdfObject;
			var t: int = 0;
			var i: VectorIterator = new VectorIterator( Vector.<Object>( arrayList ) );

			if ( i.hasNext() )
			{
				object = i.next();

				if ( object == null )
					object = PdfNull.PDFNULL;
				object.toPdf( writer, os );
			}

			while ( i.hasNext() )
			{
				object = i.next();

				if ( object == null )
					object = PdfNull.PDFNULL;
				t = object.getType();

				if ( t != PdfObject.ARRAY && t != PdfObject.DICTIONARY && t != PdfObject.NAME && t != PdfObject.STRING )
					os.writeInt( ' '.charCodeAt( 0 ) );
				object.toPdf( writer, os );
			}
			os.writeInt( ']'.charCodeAt( 0 ) );
		}

		override public function toString(): String
		{
			var str: String = "[";

			for ( var a: int = 0; a < arrayList.length; a++ )
			{
				str += arrayList[ a ].toString();

				if ( ( a + 1 ) < arrayList.length )
					str += ", ";
			}
			str += "]";
			return str;
		}
	}
}