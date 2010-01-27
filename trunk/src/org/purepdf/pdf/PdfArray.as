/*
* $Id$
* $Author Alessandro Crugnola $
* $Rev$ $LastChangedDate$
* $URL$
*
* The contents of this file are subject to  LGPL license 
* (the "GNU LIBRARY GENERAL PUBLIC LICENSE"), in which case the
* provisions of LGPL are applicable instead of those above.  If you wish to
* allow use of your version of this file only under the terms of the LGPL
* License and not to allow others to use your version of this file under
* the MPL, indicate your decision by deleting the provisions above and
* replace them with the notice and other provisions required by the LGPL.
* If you do not delete the provisions above, a recipient may use your version
* of this file under either the MPL or the GNU LIBRARY GENERAL PUBLIC LICENSE
*
* Software distributed under the License is distributed on an "AS IS" basis,
* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
* for the specific language governing rights and limitations under the License.
*
* The Original Code is 'iText, a free JAVA-PDF library' ( version 4.2 ) by Bruno Lowagie.
* All the Actionscript ported code and all the modifications to the
* original java library are written by Alessandro Crugnola (alessandro@sephiroth.it)
*
* This library is free software; you can redistribute it and/or modify it
* under the terms of the MPL as stated above or under the terms of the GNU
* Library General Public License as published by the Free Software Foundation;
* either version 2 of the License, or any later version.
*
* This library is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
* FOR A PARTICULAR PURPOSE. See the GNU LIBRARY GENERAL PUBLIC LICENSE for more
* details
*
* If you didn't download this code from the following link, you should check if
* you aren't using an obsolete version:
* http://code.google.com/p/purepdf
*
*/
package org.purepdf.pdf
{
	import org.purepdf.pdf.interfaces.IOutputStream;
	import org.purepdf.utils.iterators.VectorIterator;

	public class PdfArray extends PdfObject
	{
		protected var arrayList: Vector.<PdfObject>;

		/**
		 * Supported constructor types:<br>
		 * <ul>
		 * <li>PdfObject</li>
		 * <li>Vector.&lt;Number&gt;</li>
		 * <li>Vector.&lt;int&gt;</li>
		 * </ul>
		 */
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
		
		public function addFirst( object: PdfObject ): void
		{
			arrayList.splice( 0, 0, object );
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