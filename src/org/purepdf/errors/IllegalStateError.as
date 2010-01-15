package org.purepdf.errors
{
	public class IllegalStateError extends Error
	{
		public function IllegalStateError(message:*="", id:*=0)
		{
			super(message, id);
		}
	}
}