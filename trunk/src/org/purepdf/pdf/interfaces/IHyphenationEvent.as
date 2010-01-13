package org.purepdf.pdf.interfaces
{
	import org.purepdf.pdf.fonts.BaseFont;

	public interface IHyphenationEvent
	{
		function getHyphenSymbol(): String;
		function getHyphenatedWordPre( word: String, font: BaseFont, fontSize: Number, remainingWidth: Number ): String;
		function getHyphenatedWordPost(): String;
	}
}