package org.purepdf.utils
{
	public class StringTokenizer
	{
		private var re: RegExp;
		private var buffer: String;
		private var tokens: Vector.<String>;
		
		public function StringTokenizer( line: String, delimiter: RegExp = null )
		{
			buffer = line;
			re = delimiter != null ? delimiter : /[\s,\t\f]+/g;
			tokens = Vector.<String>(buffer.split( re ));
		}
		
		public function hasMoreTokens(): Boolean
		{
			return tokens.length > 0;
		}
		
		public function nextToken(): String
		{
			return tokens.shift();
		}
	}
}