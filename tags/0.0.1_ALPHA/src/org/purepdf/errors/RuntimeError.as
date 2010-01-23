package org.purepdf.errors
{
	public class RuntimeError extends Error
	{
		public function RuntimeError(message:*="", id:*=0)
		{
			super(message, id);
		}
	}
}