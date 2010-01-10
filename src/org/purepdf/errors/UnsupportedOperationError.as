package org.purepdf.errors
{
	public class UnsupportedOperationError extends Error
	{
		public function UnsupportedOperationError(message:*="", id:*=0)
		{
			super(message, id);
		}
	}
}