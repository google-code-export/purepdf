package org.purepdf.factories
{

	public class RomanAlphabetFactory
	{
		static public function getLowerCaseString(index: int): String
		{
			return getStringAtIndex(index);
		}

		static public function getString(index: int, lowercase: Boolean): String
		{
			if (lowercase)
			{
				return getLowerCaseString(index);
			} else
			{
				return getUpperCaseString(index);
			}
		}

		static public function getUpperCaseString(index: int): String
		{
			return getStringAtIndex(index).toUpperCase();
		}

		static private function getStringAtIndex(index: int): String
		{
			if (index < 1)
				throw new Error("Can't translate a negative number");
			index--;
			var bytes: int = 1;
			var start: int = 0;
			var symbols: int = 26;

			while (index >= symbols + start)
			{
				bytes++;
				start += symbols;
				symbols *= 26;
			}
			var c: int = index - start;
			var value: Vector.<String> = new Vector.<String>(bytes, true);

			while (bytes > 0)
			{
				value[--bytes] = String.fromCharCode(97 + (c % 26));
				c /= 26;
			}
			return value.join("");
		}
	}
}