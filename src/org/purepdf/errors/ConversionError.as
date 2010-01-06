package org.purepdf.errors
{
	public class ConversionError extends Error
	{
		public function ConversionError(message:*="", id:*=0)
		{
			super(message, id);
		}
	}
}