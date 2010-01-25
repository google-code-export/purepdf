package org.purepdf.pdf
{
	import it.sephiroth.utils.Entry;
	import it.sephiroth.utils.HashMap;
	import it.sephiroth.utils.collections.iterators.Iterator;
	
	import org.purepdf.errors.ConversionError;
	import org.purepdf.utils.pdf_core;

	public class PdfCatalog extends PdfDictionary
	{
		private var writer: PdfWriter;

		public function PdfCatalog( $pages: PdfIndirectReference, $writer: PdfWriter )
		{
			super( CATALOG );
			writer = $writer;
			put( PdfName.PAGES, $pages );
		}
		
		public function setAdditionalActions( actions: PdfDictionary ): void
		{
			try
			{
				put( PdfName.AA, writer.pdf_core::addToBody( actions ).getIndirectReference() );
			} catch( e: Error )
			{
				throw new ConversionError(e);
			}
		}

		public function addNames( localDestinations: HashMap, documentLevelJS: HashMap, documentFileAttachment: HashMap,
						writer: PdfWriter ): void
		{
			if ( localDestinations.isEmpty() && documentLevelJS.isEmpty() && documentFileAttachment.isEmpty() )
				return;

			try
			{
				var names: PdfDictionary = new PdfDictionary();

				if ( !localDestinations.isEmpty() )
				{
					var ar: PdfArray = new PdfArray();

					for ( var i: Iterator = localDestinations.entrySet().iterator(); i.hasNext();  )
					{
						var entry: Entry = Entry( i.next() );
						var name: String = String( entry.getKey() );
						var obj: Vector.<Object> = entry.getValue() as Vector.<Object>;

						if ( obj[2] == null ) //no destination
							continue;
						var ref: PdfIndirectReference = PdfIndirectReference( obj[1] );
						ar.add( new PdfString( name, null ) );
						ar.add( ref );
					}

					if ( ar.size() > 0 )
					{
						var dests: PdfDictionary = new PdfDictionary();
						dests.put( PdfName.NAMES, ar );
						names.put( PdfName.DESTS, writer.pdf_core::addToBody( dests ).getIndirectReference() );
					}
				}

				if ( !documentLevelJS.isEmpty() )
				{
					var tree: PdfDictionary = PdfNameTree.writeTree( documentLevelJS, writer );
					names.put( PdfName.JAVASCRIPT, writer.pdf_core::addToBody( tree ).getIndirectReference() );
				}

				if ( !documentFileAttachment.isEmpty() )
				{
					names.put( PdfName.EMBEDDEDFILES, writer.pdf_core::addToBody( PdfNameTree.writeTree( documentFileAttachment,
									writer ) ).getIndirectReference() );
				}

				if ( names.size() > 0 )
					put( PdfName.NAMES, writer.pdf_core::addToBody( names ).getIndirectReference() );
			} catch ( e: Error )
			{
				trace( e.getStackTrace() );
				throw new ConversionError( e );
			}
		}
	}
}