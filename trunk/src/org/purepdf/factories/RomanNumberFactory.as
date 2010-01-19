package org.purepdf.factories
{

	public class RomanNumberFactory
	{
		private static const roman: Vector.<RomanDigit> = Vector.<RomanDigit>([
						new RomanDigit('m', 1000, false), new RomanDigit('d', 500, false), new RomanDigit('c', 100, true),
						new RomanDigit('l', 50, false), new RomanDigit('x', 10, true), new RomanDigit('v', 5, false),
						new RomanDigit('i', 1, true)
						]);

		static public function getLowerCaseString(index: int): String
		{
			return getStringAtIndex(index);
		}

		static public function getString(index: int, lowercase: Boolean): String
		{
			if (lowercase)
				return getLowerCaseString(index);
			else
				return getUpperCaseString(index);
		}

		static public function getUpperCaseString(index: int): String
		{
			return getStringAtIndex(index).toUpperCase();
		}

		static public function getStringAtIndex(index: int): String
		{
			var buf: String = "";

			if (index < 0)
			{
				buf += '-';
				index = -index;
			}

			if (index > 3000)
			{
				buf += '|';
				buf += getStringAtIndex(index / 1000);
				buf += '|';
				index = index - (index / 1000) * 1000;
			}
			var pos: int = 0;

			while (true)
			{
				var dig: RomanDigit = roman[pos];

				while (index >= dig.value)
				{
					buf += dig.digit;
					index -= dig.value;
				}

				if (index <= 0)
					break;
				var j: int = pos;

				while (!roman[++j].pre);

				if (index + roman[j].value >= dig.value)
				{
					buf += roman[j].digit + dig.digit;
					index -= dig.value - roman[j].value;
				}
				pos++;
			}
			return buf;
		}
	}
}