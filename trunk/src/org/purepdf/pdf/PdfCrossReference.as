package org.purepdf.pdf
{
	import org.purepdf.IComparable;
	import org.purepdf.IOutputStream;
	import org.purepdf.ObjectHash;
	import org.purepdf.utils.assertTrue;

	public final class PdfCrossReference extends ObjectHash implements IComparable
	{
		private var generation: int;
		private var offset: int;
		private var refnum: int;
		private var type: int;

		/**
		 * Constructs a cross-reference element for a PdfIndirectObject.
		 * @param refnum
		 * @param	offset		byte offset of the object
		 * @param	generation	generation number of the object
		 */
		public function PdfCrossReference( $type: int, $refnum: int, $offset: int, $generation: int=0 )
		{
			type = $type;
			offset = $offset;
			refnum = $refnum;
			generation = $generation;
		}

		public function compareTo( o: Object ): int
		{
			var other: PdfCrossReference = o as PdfCrossReference;
			return ( refnum < other.refnum ? -1 : ( refnum == other.refnum ? 0 : 1 ) );
		}

		public function equals( obj: Object ): Boolean
		{
			if ( obj is PdfCrossReference )
			{
				var other: PdfCrossReference = PdfCrossReference( obj );
				return ( refnum == other.refnum );
			}
			else
			{
				return false;
			}
		}

		public function getRefnum(): int
		{
			return refnum;
		}

		override public function hashCode(): int
		{
			return refnum;
		}

		/**
		 * Writes PDF syntax to the OutputStream
		 */
		public function midSizeToPdf( midSize: int, os: IOutputStream ): void
		{
			assertTrue( midSize >= 0, "midSize must be greater than 0" );
			os.writeInt( ByteBuffer.intToByte( type ) );

			while ( --midSize >= 0 )
				os.writeInt( ByteBuffer.intToByte( ( offset >>> ( 8 * midSize ) ) & 0xff ) );
			os.writeInt( ByteBuffer.intToByte( ( generation >>> 8 ) & 0xff ) );
			os.writeInt( ByteBuffer.intToByte( generation & 0xff ) );
		}

		/**
		 * Returns the PDF representation of this <CODE>PdfObject</CODE>.
		 */
		public function toPdf( os: IOutputStream ): void
		{
			var off: String = "0000000000" + offset.toString();
			off = off.substr( off.length - 10 );
			var gen: String = "00000" + generation.toString();
			gen = gen.substr( gen.length - 5 );
			off += " " + gen + ( generation == PdfWriter.GENERATION_MAX ? " f \n" : " n \n" );
			os.writeBytes( PdfWriter.getISOBytes( off ) );
		}
	}
}