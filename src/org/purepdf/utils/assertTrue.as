package org.purepdf.utils
{
	import org.purepdf.errors.AssertionError;

	public function assertTrue( expression: Boolean, message: String = "Assertion Error" ): void
	{
		if ( !expression )
			throw new AssertionError( message );
	}
}
