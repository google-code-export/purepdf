package org.purepdf.pdf
{
	import org.purepdf.IOutputStream;
	import org.purepdf.utils.iterators.VectorIterator;

	public class PdfArray extends PdfObject
	{
		protected var arrayList: Vector.<PdfObject>;
		
		public function PdfArray( object: PdfObject = null )
		{
			super( ARRAY );
			arrayList = new Vector.<PdfObject>();
			
			if( object )
				arrayList.push( object );
		}

		public function add( object: PdfObject ): uint
		{
			return arrayList.push( object );
		}
		
		public function size(): int
		{
			return arrayList.length;
		}
		
		public function isEmpty(): Boolean
		{
			return arrayList.length == 0;
		}
		
		[Deprecated]
		public function getArrayList(): Vector.<PdfObject>
		{
			return arrayList;
		}
		
		override public function toString() : String
		{
			var str: String = "[";
			for( var a: int = 0; a < arrayList.length; a++ )
			{
				str += arrayList[a].toString();
				if( (a+1) < arrayList.length )
					str += ", ";
			}
			str += "]";
			return str;
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
			os.writeInt( '['.charCodeAt(0) );
			
			var object: PdfObject;
			var t: int = 0;
			var i: VectorIterator = new VectorIterator( Vector.<Object>(arrayList) );
			
			if( i.hasNext() )
			{
				object = i.next();
				if( object == null )
					object = PdfNull.PDFNULL;
				object.toPdf( writer, os );
			}
			
			while( i.hasNext() )
			{
				object = i.next();
				if( object == null )
					object = PdfNull.PDFNULL;
				t = object.getType();
				if( t != PdfObject.ARRAY && t != PdfObject.DICTIONARY && t != PdfObject.NAME && t != PdfObject.STRING )
					os.writeInt( ' '.charCodeAt(0) );
				object.toPdf( writer, os );
			}
			
			os.writeInt( ']'.charCodeAt(0) );
		}
	}
}