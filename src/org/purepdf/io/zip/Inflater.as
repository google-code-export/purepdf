package org.purepdf.io.zip
{
	import com.wizhelp.fzlib.FZlib;
	import com.wizhelp.fzlib.ZStream;
	import flash.utils.ByteArray;
	import org.purepdf.errors.IndexOutOfBoundsError;
	import org.purepdf.errors.NullPointerError;
	import org.purepdf.utils.ByteArrayUtils;

	public class Inflater
	{
		private static var emptyBuf: ByteArray = new ByteArray();
		private var _finished: Boolean;
		private var buf: ByteArray = emptyBuf;
		private var len: int;
		private var needDict: Boolean;
		private var off: int;
		private var strm: Number;

		public function Inflater( nowrap: Boolean=false )
		{
			_initIDs();
			strm = _init( nowrap );
		}

		public function end(): void
		{
			if ( strm != 0 )
			{
				_end( strm );
				strm = 0;
				buf = null;
			}
		}

		public function get finished(): Boolean
		{
			return _finished;
		}

		public function inflate( b: ByteArray, $off: int, $len: int ): int
		{
			if ( b == null )
			{
				throw new NullPointerError();
			}
			if ( $off < 0 || $len < 0 || $off > b.length - $len )
			{
				throw new IndexOutOfBoundsError();
			}
			return _inflateBytes( b, $off, $len );
		}

		public function get lenght(): int
		{
			return len;
		}

		public function set lenght( value: int ): void
		{
			len = value;
		}

		public function get needsDictionary(): Boolean
		{
			return needDict;
		}

		public function get needsInput(): Boolean
		{
			return len <= 0;
		}

		public function get offset(): int
		{
			return off;
		}

		public function set offset( value: int ): void
		{
			off = value;
		}

		public function reset(): void
		{
			ensureOpen();
			_reset( strm );
			_finished = false;
			needDict = false;
			off = len = 0;
			buf = emptyBuf;
		}

		public function setInput( b: ByteArray, $off: int, $len: int ): void
		{
			if ( b == null )
			{
				throw new NullPointerError();
			}
			if ( off < 0 || len < 0 || off > b.length - len )
			{
				throw new IndexOutOfBoundsError();
			}
			buf = b;
			off = $off;
			len = $len;
		}

		protected function finalize(): void
		{
			end();
		}

		private function _inflateBytes( b: ByteArray, $off: int, $len: int ): int
		{
			var this_off: int = off;
			var this_len: int = len;
			var in_buf: ByteArray = new ByteArray();
			var out_buf: ByteArray = new ByteArray();
			var ret: int;
			in_buf.length = this_len;
			out_buf.length = this_len;
			
			if( in_buf.length == 0 )
				return 0;
			
			in_buf.writeBytes( buf, this_off, this_len );
			
			var strm: ZStream = new ZStream();
			strm.next_in = in_buf;
			strm.next_out = out_buf;
			strm.avail_in = this_len;
			strm.avail_out = $len;
			strm.inflateInit();
			
			ret = strm.inflate( FZlib.Z_PARTIAL_FLUSH );
			
			if ( ret == FZlib.Z_STREAM_END || ret == FZlib.Z_OK )
			{
				out_buf.position = 0;
				out_buf.readBytes( b, $off, $len - strm.avail_out );
				trace( "next_out: ", ByteArrayUtils.toVector( strm.next_out ) );
				trace( "lenght:", strm.next_out.length );
				trace( "result: ", ByteArrayUtils.toVector( b ) );
			}
			switch ( ret )
			{
				case FZlib.Z_STREAM_END:
					_finished = true;
					/* fall through */
					
				case FZlib.Z_OK:
					this_off += this_len - strm.avail_in;
					off = this_off;
					len = strm.avail_in;
					return $len - strm.avail_out;
					
				case FZlib.Z_NEED_DICT:
					needDict = true;
					this_off += this_len - strm.avail_in;
					off = this_off;
					len = strm.avail_in;
					return 0;
					
				case FZlib.Z_BUF_ERROR:
					return 0;
					
				case FZlib.Z_DATA_ERROR:
					return 0;
					
				case FZlib.Z_MEM_ERROR:
					return 0;
					
				default:
					return 0;
			}
		}

		private function ensureOpen(): void
		{
			if ( strm == 0 )
				throw new NullPointerError();
		}

		private static function _end( strm: Number ): void
		{
		}

		private static function _getAdler( strm: Number ): int
		{
			return -1;
		}

		private static function _getBytesRead( strm: Number ): Number
		{
			return -1;
		}

		private static function _getBytesWritten( strm: Number ): Number
		{
			return -1;
		}

		private static function _init( nowrap: Boolean ): Number
		{
			return 1;
		}

		private static function _initIDs(): void
		{
		}

		private static function _reset( strm: Number ): void
		{
		}

		private static function _setDictionary( strm: Number, b: ByteArray, $off: int, $len: int ): void
		{
		}
	}
}