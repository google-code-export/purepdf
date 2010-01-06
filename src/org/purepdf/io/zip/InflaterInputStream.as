package org.purepdf.io.zip
{
	import com.wizhelp.fzlib.FZlib;
	import com.wizhelp.fzlib.ZStream;
	
	import flash.errors.IOError;
	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;
	
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.purepdf.errors.IndexOutOfBoundsError;
	import org.purepdf.errors.NullPointerError;
	import org.purepdf.io.FilterInputStream;
	import org.purepdf.io.InputStream;
	import org.purepdf.utils.Bytes;

	public class InflaterInputStream extends FilterInputStream
	{
		protected var buf: Bytes;
		protected var c_stream: ZStream;
		protected var len: int;
		private var closed: Boolean = false;
		private var reachEOF: Boolean = false;
		private var singleByteBuf: Bytes = new Bytes();
		private var usesDefaultInflater: Boolean = false;
		
		private static var logger: ILogger = LoggerFactory.getClassLogger( InflaterInputStream );

		public function InflaterInputStream( stream: InputStream )
		{
			super( stream );
			singleByteBuf.length = 1;
			init( stream, stream.size() );
		}
		
		private function init( stream: InputStream, size: int ): void
		{
			if ( stream == null )
				throw new NullPointerError();
			else if ( size <= 0 )
				throw new IllegalOperationError( "buffer size <= 0" );
			
			buf = new Bytes( size );
			stream.readBytes( buf.buffer, 0, size );
			
			c_stream = new ZStream();
			c_stream.next_in = buf.buffer;
			c_stream.next_in_index = 0;
			c_stream.next_out = new Bytes();
			c_stream.next_out_index = 0;
			var err: int = c_stream.inflateInit();
			CHECK_ERR( c_stream, err, "inflateInit" );
		}

		override public function readBytes( b: ByteArray, off: int, len: int ): int
		{
			ensureOpen();
			if ( b == null )
				throw new NullPointerError();
			else if ( off < 0 || len < 0 || len > b.length - off )
				throw new IndexOutOfBoundsError();
			else if ( len == 0 )
				return 0;
			
			c_stream.avail_in = buf.length;
			c_stream.avail_out = len;
			c_stream.next_in_index = 0;
			c_stream.next_out_index = 0;
			c_stream.next_out = b;
			var err: int = c_stream.inflate( FZlib.Z_NO_FLUSH );
			CHECK_ERR( c_stream, err, c_stream.msg );
			
			return c_stream.total_out;
		}

		override public function readUnsignedByte(): int
		{
			ensureOpen();
			
			c_stream.avail_in = buf.length;
			c_stream.avail_out = 1;
			c_stream.next_in_index = 0;
			c_stream.next_out_index = 0;
			c_stream.next_out = singleByteBuf;
			var err: int = c_stream.inflate( FZlib.Z_NO_FLUSH );
			CHECK_ERR( c_stream, err, c_stream.msg );
			
			return c_stream.total_out == 0 ? -1 : singleByteBuf[ 0 ] & 0xFF;
		}

		private function ensureOpen(): void
		{
			if ( closed )
				throw new IOError( "stream closed" );
		}
		
		static protected function CHECK_ERR( z: ZStream, err: int, msg: String ): void
		{
			if ( err != FZlib.Z_OK )
			{
				if ( z.msg != null )
					logger.error( z.msg + " " );
				logger.error( "message: {0}, error: {1}", msg, err );
			}
		}
	}
}