package org.purepdf.utils
{
	import cmodule.float.CLibInit;

	public class FloatUtils
	{
		private static const EXP_BIT_MASK: int = 2139095040;
		private static const SIGNIF_BIT_MASK: int = 8388607;
		
		private static var float_loader: CLibInit;
		private static var float_lib: Object;
		private static var libs_loaded: Boolean = false;
		
		/**
		 * Returns a representation of the specified floating-point value
		 * according to the IEEE 754 floating-point "single format" bit
		 * layout.
	 	 */
		public static function floatToIntBits( value: Number ): int
		{
			if( !libs_loaded ) initCLibs();
			
			var result: int = float_lib.floatToRawIntBits( value );

			if ( ( ( result & EXP_BIT_MASK ) == EXP_BIT_MASK ) && ( result & SIGNIF_BIT_MASK ) != 0 )
				result = 0x7fc00000;
			return result;
		}
		
		private static function initCLibs(): void
		{
			float_loader = new CLibInit();
			float_lib = float_loader.init();
			libs_loaded = true;
		}
	}
}