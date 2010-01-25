package org.purepdf.pdf
{
	import it.sephiroth.utils.HashMap;
	
	import org.purepdf.utils.pdf_core;

	public class PdfNameTree
	{
		private static const leafSize: int = 64;
		
		/**
		 * Writes a name tree to a PdfWriter.
		 * @param items the item of the name tree. The key is a <CODE>String</CODE>
		 * and the value is a <CODE>PdfObject</CODE>. Note that although the
		 * keys are strings only the lower byte is used and no check is made for chars
		 * with the same lower byte and different upper byte. This will generate a wrong
		 * tree name.
		 * @param writer the writer
		 * @throws IOException on error
		 * @return the dictionary with the name tree. This dictionary is the one
		 * generally pointed to by the key /Dests, for example
		 */    
		public static function writeTree( items: HashMap, writer: PdfWriter ): PdfDictionary
		{
			if (items.isEmpty())
				return null;
			
			var k: int;
			var arr: PdfArray;
			var dic: PdfDictionary;
			var offset: int;
			var end: int;
			
			var names: Vector.<Object> = new Vector.<Object>(items.size());
			names = items.keySet().toArray( Vector.<Object>(names) );
			names.sort( function cmp( a: String, b: String ): Number{ if( a < b ){ return -1 } else if( a > b ){ return 1 } else { return 0 } } );
			if( names.length <= leafSize) 
			{
				dic = new PdfDictionary();
				var ar: PdfArray = new PdfArray();
				for ( k = 0; k < names.length; ++k) {
					ar.add(new PdfString(names[k], null));
					ar.add(items.getValue(names[k]) as PdfObject);
				}
				dic.put(PdfName.NAMES, ar);
				return dic;
			}
			var skip: int = leafSize;
			var kids: Vector.<PdfIndirectReference> = new Vector.<PdfIndirectReference>( (names.length + leafSize - 1) / leafSize, true );
			for( k = 0; k < kids.length; ++k )
			{
				offset = k * leafSize;
				end = Math.min(offset + leafSize, names.length);
				dic = new PdfDictionary();
				arr = new PdfArray();
				arr.add(new PdfString(names[offset], null));
				arr.add(new PdfString(names[end - 1], null));
				dic.put(PdfName.LIMITS, arr);
				arr = new PdfArray();
				for (; offset < end; ++offset) {
					arr.add(new PdfString(names[offset], null));
					arr.add(items.getValue(names[offset]) as PdfObject );
				}
				dic.put(PdfName.NAMES, arr);
				kids[k] = writer.pdf_core::addToBody(dic).getIndirectReference();
			}
			
			var top: int = kids.length;
			while (true)
			{
				if (top <= leafSize) {
					arr = new PdfArray();
					for ( k = 0; k < top; ++k)
						arr.add(kids[k]);
					dic = new PdfDictionary();
					dic.put(PdfName.KIDS, arr);
					return dic;
				}
				skip *= leafSize;
				var tt: int = (names.length + skip - 1 )/ skip;
				for ( k = 0; k < tt; ++k) {
					offset = k * leafSize;
					end = Math.min(offset + leafSize, top);
					dic = new PdfDictionary();
					arr = new PdfArray();
					arr.add(new PdfString(names[k * skip], null));
					arr.add(new PdfString(names[Math.min((k + 1) * skip, names.length) - 1], null));
					dic.put(PdfName.LIMITS, arr);
					arr = new PdfArray();
					for (; offset < end; ++offset) {
						arr.add(kids[offset]);
					}
					dic.put(PdfName.KIDS, arr);
					kids[k] = writer.pdf_core::addToBody(dic).getIndirectReference();
				}
				top = tt;
			}
			return null;
		}
	}
}