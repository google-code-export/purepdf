package org.purepdf.pdf
{

	public class PdfPages
	{
		private var writer: PdfWriter;
		private var pages: Vector.<PdfIndirectReference> = new Vector.<PdfIndirectReference>();
		private var parents: Vector.<PdfIndirectReference> = new Vector.<PdfIndirectReference>();
		private var leafSize: int = 10;
		private var topParent: PdfIndirectReference;
		
		public function PdfPages( $writer: PdfWriter )
		{
			writer = $writer;
		}
		
		public function getTopParent(): PdfIndirectReference
		{
			return topParent;
		}
		
		public function addPage( page: PdfDictionary ): void
		{
			if(( pages.length % leafSize ) == 0 )
				parents.push( writer.getPdfIndirectReference() );
			
			var parent: PdfIndirectReference = parents[ parents.length - 1] as PdfIndirectReference;
			page.put( PdfName.PARENT, parent );
			var current: PdfIndirectReference = writer.getCurrentPage();
			writer.addToBody1( page, current );
			pages.push( current );
		}
		
		public function addPageRef( pageRef: PdfIndirectReference ): PdfIndirectReference
		{
			if( ( pages.length % leafSize ) == 0 )
				parents.push( writer.getPdfIndirectReference() );
			pages.push( pageRef );
			return parents[ (parents.length - 1) ];
		}
		
		public function writePageTree(): PdfIndirectReference
		{
			if( pages.length == 0 )
				throw new Error("The document has no pages");
			
			var leaf: int = 1;
			var tParents: Vector.<PdfIndirectReference> = parents;
			var tPages: Vector.<PdfIndirectReference> = pages;
			var nextParents: Vector.<PdfIndirectReference> = new Vector.<PdfIndirectReference>();
			
			while( true )
			{
				leaf *= leafSize;
				var stdCount: int = leafSize;
				var rightCount: int = tPages.length % leafSize;
				if( rightCount == 0 )
					rightCount = leafSize;
				
				for( var p: int = 0; p < tParents.length; ++p )
				{
					var count: int;
					var thisLeaf: int = leaf;
					if( p == ( tParents.length - 1 ) )
					{
						count = rightCount;
						thisLeaf = pages.length % leaf;
						if( thisLeaf == 0 )
							thisLeaf = leaf;
					} else {
						count = stdCount;
					}
					
					var top: PdfDictionary = new PdfDictionary( PdfName.PAGES );
					top.put( PdfName.COUNT, new PdfNumber( thisLeaf ) );
					var kids: PdfArray = new PdfArray();
					var internalArray: Vector.<PdfObject> = kids.getArrayList();
					var tmp: Vector.<PdfIndirectReference> = tPages.slice( p * stdCount, p * stdCount + count );
					
					for( var a: int = 0; a < tmp.length; a++ )
						internalArray.push( tmp[a] );
					
					top.put( PdfName.KIDS, kids );
					if( tParents.length > 1 )
					{
						if( (p % leafSize) == 0 )
							nextParents.push( writer.getPdfIndirectReference() );
						top.put( PdfName.PARENT, nextParents[ int(p / leafSize) ] );
					} else {
						top.put( PdfName.PUREPDF, new PdfString( PdfWriter.RELEASE ) );
					}
					
					writer.addToBody1( top, tParents[p] );
				}
				
				if( tParents.length == 1 ){
					topParent = tParents[0];
					return topParent;
				}
				
				tPages = tParents;
				tParents = nextParents;
				nextParents = new Vector.<PdfIndirectReference>();
			}
			
			return null;
		}
	}
}