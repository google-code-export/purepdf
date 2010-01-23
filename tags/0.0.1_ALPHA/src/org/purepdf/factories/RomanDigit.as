package org.purepdf.factories
{
	public final class RomanDigit
	{
		public var digit: String;
		public var pre: Boolean;
		public var value: int;
		
		public function RomanDigit($digit: String, $value: int, $pre: Boolean)
		{
			digit = $digit;
			value = $value;
			pre = $pre;
		}
	}
}