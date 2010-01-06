package org.purepdf.errors
{
	public class AssertionError extends Error
	{
		public function AssertionError(message:*="", id:*=0)
		{
			super(message, id);
		}
	}
}