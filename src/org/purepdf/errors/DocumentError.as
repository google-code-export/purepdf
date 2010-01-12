package org.purepdf.errors
{
	public class DocumentError extends Error
	{
		public function DocumentError(message:*="", id:*=0)
		{
			super(message, id);
		}
	}
}