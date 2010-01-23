package org.purepdf.elements
{
	import org.purepdf.factories.RomanNumberFactory;

	public class RomanList extends List
	{
		public function RomanList($symbolIndent: Number = 0)
		{
			super(true, $symbolIndent);
		}

		override public function add(o: Object): Boolean
		{
			if (o is ListItem)
			{
				var item: ListItem = ListItem(o);
				var chunk: Chunk;
				chunk = new Chunk(preSymbol, symbol.font);
				chunk.append(RomanNumberFactory.getString(first + list.length, lowercase));
				chunk.append(postSymbol);
				item.listSymbol = chunk;
				item.setIndentationLeft(symbolIndent, autoindent);
				item.indentationRight = 0;
				list.push(item);
			} else if (o is List)
			{
				var nested: List = List(o);
				nested.indentationLeft = nested.indentationLeft + symbolIndent;
				first--;
				list.push(nested);
				return true;
			} else if (o is String)
			{
				return add(new ListItem(String(o)));
			}
			return false;
		}
	}
}