package it.sephiroth.utils
{
	public class hashLib
	{
		public static function BPHash( str: String, len: int = 36 ): int
		{
			var hash: uint = 0;
			var i: uint    = 0;
			for( i = 0; i < len && i < str.length; i++ )
			{
				hash = hash << 7 ^ (str.charCodeAt(i));
			}
			
			return hash;
		}
		
		public static function APHash( str: String, len: int = 36 ): int
		{
			var hash: uint = 0xAAAAAAAA;
			var i: uint    = 0;
			
			for(i = 0; i < len && i < str.length; i++ )
			{
				hash ^= ((i & 1) == 0) ? (  (hash <<  7) ^ (str.charCodeAt(i)) ^ (hash >> 3)) :
					(~((hash << 11) ^ (str.charCodeAt(i)) ^ (hash >> 5)));
			}
			
			return hash;
		}
		
		public static function FNVHash( str: String, len: int = 36 ): int
		{
			const fnv_prime: uint = 0x811C9DC5;
			var hash: uint      = 0;
			var i: uint         = 0;
			
			for( i = 0; i < len && i < str.length; i++ )
			{
				hash *= fnv_prime;
				hash ^= str.charCodeAt(i);
			}
			
			return hash;
		}
		
		public static function RSHash( str: String, len: int = 36 ): int
		{
			var b: uint    = 378551;
			var a: uint    = 63689;
			var hash: uint = 0;
			var i: uint    = 0;
			
			for( i = 0; i < len && i < str.length; i++ )
			{
				hash = hash * a + (str.charCodeAt(i));
				a    = a * b;
			}
			
			return hash;
		}
		
		
		public static function JSHash( str: String, len: int = 36 ): int
		{
			var hash: uint = 1315423911;
			var i: uint    = 0;
			
			for(i = 0; i < len && i < str.length; i++)
			{
				hash ^= ((hash << 5) + str.charCodeAt(i) + (hash >> 2));
			}
			
			return hash;
		}
		
		public static function PJWHash( str: String, len: int = 36 ): int
		{
			const BitsInUnsignedInt: uint = 32 * 8;
			const ThreeQuarters: uint     = ((BitsInUnsignedInt  * 3) / 4);
			const OneEighth: uint         = (BitsInUnsignedInt / 8);
			const HighBits: uint          = (0xFFFFFFFF) << (BitsInUnsignedInt - OneEighth);
			
			var hash: uint              = 0;
			var test: uint              = 0;
			var i: uint                 = 0;
			
			for( i = 0; i < len && i < str.length; i++ )
			{
				hash = (hash << OneEighth) + str.charCodeAt(i);
				if((test = hash & HighBits)  != 0)
				{
					hash = (( hash ^ (test >> ThreeQuarters)) & (~HighBits));
				}
			}
			
			return hash;
		}
		
		public static function ELFHash( str: String, len: int = 36 ): int
		{
			var hash: uint = 0;
			var x: uint    = 0;
			var i: uint    = 0;
			
			for(i = 0; i < len && i < str.length; i++)
			{
				hash = (hash << 4) + str.charCodeAt(i);
				if((x = hash & 0xF0000000) != 0)
				{
					hash ^= (x >> 24);
				}
				hash &= ~x;
			}
			
			return hash;
		}
		
		
		public static function BKDRHash( str: String, len: int = 36 ): int
		{
			var seed: uint = 131; /* 31 131 1313 13131 131313 etc.. */
			var hash: uint = 0;
			var i: uint    = 0;
			
			for(i = 0; i < len && i < str.length; i++)
			{
				hash = (hash * seed) + str.charCodeAt(i);
			}
			
			return hash;
		}
		
		public static function SDBMHash( str: String, len: int = 36 ): int
		{
			var hash: uint = 0;
			var i: uint    = 0;
			
			for(i = 0; i < len && i < str.length; i++)
			{
				hash = str.charCodeAt(i) + (hash << 6) + (hash << 16) - hash;
			}
			
			return hash;
		}
		
		
		public static function DJBHash( str: String, len: int = 36 ): int
		{
			var hash: uint = 5381;
			var i: uint    = 0;
			
			for(i = 0; i < len && i < str.length; i++)
			{
				hash = ((hash << 5) + hash) + str.charCodeAt(i);
			}
			
			return hash;
		}
		
		public static function DEKHash( str: String, len: int = 36 ): int
		{
			var hash: uint = len;
			var i: uint    = 0;
			
			for(i = 0; i < len && i < str.length; i++)
			{
				hash = ((hash << 5) ^ (hash >> 27)) ^ str.charCodeAt(i);
			}
			return hash;
		}
		
		public static function hashCode( str: String, len: int = 36 ): int
		{
			return APHash( str, Math.max( len, str.length ) );
		}
		
	}
}
