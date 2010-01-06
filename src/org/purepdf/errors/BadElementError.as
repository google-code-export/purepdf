package org.purepdf.errors
{
	public class BadElementError extends Error
	{
		public function BadElementError(message:*="", id:*=0)
		{
			super(message, id);
		}
	}
}