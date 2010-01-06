package org.purepdf.pdf
{

	/**
	 * Graphic state dictionary
	 *
	 */
	public class PdfGState extends PdfDictionary
	{
		/**
		 * The alpha source flag specifying whether the current soft mask
		 * and alpha constant are to be interpreted as shape values (true)
		 * or opacity values (false).
		 *
		 * @param v
		 */
		public function setAlphaIsShape( v: Boolean ): void
		{
			put( PdfName.AIS, v ? PdfBoolean.PDF_TRUE : PdfBoolean.PDF_FALSE );
		}

		/**
		 * The current blend mode to be used in the transparent imaging model.
		 * 
		 * @param bm
		 * 			Blend Mode
		 * 
		 * @see	prg.purepdf.pdf.PdfBlendMode
		 */
		public function setBlendMode( bm: PdfName ): void
		{
			put( PdfName.BM, bm );
		}

		/**
		 * Sets the current fill opacity
		 *
		 * @param n
		 * 			Number value between 0 and 1
		 */
		public function setFillOpacity( n: Number ): void
		{
			put( PdfName.ca, new PdfNumber( n ) );
		}

		/**
		 * Sets the flag whether to toggle knockout behavior for overprinted objects.
		 * @param ov - accepts 0 or 1
		 */
		public function setOverPrintMode( ov: int ): void
		{
			put( PdfName.OPM, new PdfNumber( ov == 0 ? 0 : 1 ) );
		}

		/**
		 * Sets the flag whether to apply overprint for non stroking painting operations.
		 * @param ov
		 */
		public function setOverPrintNonStroking( ov: Boolean ): void
		{
			put( PdfName.op, ov ? PdfBoolean.PDF_TRUE : PdfBoolean.PDF_FALSE );
		}

		/**
		 * Sets the flag whether to apply overprint for stroking.
		 * @param ov
		 */
		public function setOverPrintStroking( ov: Boolean ): void
		{
			put( PdfName.OP, ov ? PdfBoolean.PDF_TRUE : PdfBoolean.PDF_FALSE );
		}

		/**
		 * Sets the current stroking alpha
		 *
		 * @param n
		 * 			Float value between 0 and 1
		 */
		public function setStrokeOpacity( n: Number ): void
		{
			put( PdfName.CA, new PdfNumber( n ) );
		}

		/**
		 * Determines the behavior of overlapping glyphs within a text object
		 * in the transparent imaging model.
		 * @param v
		 */
		public function setTextKnockout( v: Boolean ): void
		{
			put( PdfName.TK, v ? PdfBoolean.PDF_TRUE : PdfBoolean.PDF_FALSE );
		}
	}
}