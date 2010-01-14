package org.purepdf.errors
{
	public class IllegalPdfSyntaxError extends Error
	{
		public function IllegalPdfSyntaxError(message:*="", id:*=0)
		{
			super(message, id);
		}
	}
}