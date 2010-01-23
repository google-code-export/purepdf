package org.purepdf.errors
{
	public class CastTypeError extends Error
	{
		public function CastTypeError(message:*="", id:*=0)
		{
			super(message, id);
		}
	}
}