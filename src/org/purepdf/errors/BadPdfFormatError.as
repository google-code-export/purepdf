package org.purepdf.errors
{
	public class BadPdfFormatError extends Error
	{
		public function BadPdfFormatError(message:*="", id:*=0)
		{
			super(message, id);
		}
	}
}