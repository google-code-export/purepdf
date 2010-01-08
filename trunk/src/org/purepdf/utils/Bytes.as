package org.purepdf.utils
{
	import flash.utils.ByteArray;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	/**
	 * Implementation of a byte[] buffer
	 * which members can be only of primitive type 'byte'
	 *
	 *
	 */
	public class Bytes extends Proxy
	{
		private var buf: ByteArray;

		public function Bytes( value: Object=null )
		{
			super();
			buf = new ByteArray();

			if ( value != null )
			{
				if ( value is Number )
				{
					buf.length = value as Number;
				}
				else if ( value is Array )
				{
					for ( var k: int = 0; k < value.length; k++ )
						this[ k ] = value[ k ];
				}
			}
		}

		public function get buffer(): ByteArray
		{
			return buf;
		}

		public function set buffer( value: ByteArray ): void
		{
			buf = value;
		}

		public function get length(): uint
		{
			return buf.length;
		}

		public function set length( value: uint ): void
		{
			buf.length = value;
		}

		public function get position(): uint
		{
			return buf.position;
		}

		public function set position( value: uint ): void
		{
			buf.position = value;
		}

		public function readAsString( offset: int=0, len: int=0 ): String
		{
			if ( len == 0 )
				len = length;
			var str: String = "";

			for ( var k: int = 0; k < ( len - offset ); k++ )
			{
				str += String.fromCharCode( this[ k + offset ] );
			}
			return str;
		}

		public function size(): uint
		{
			return buf.length;
		}

		public function toString(): String
		{
			return "[" + toVector().toString() + "]";
		}

		public function toVector(): Vector.<int>
		{
			var r: Vector.<int> = new Vector.<int>( length );

			for ( var k: int = 0; k < length; k++ )
				r[ k ] = this[ k ];
			return r;
		}

		public function writeBytes( buffer: Bytes, offset: uint=0, len: uint=0 ): void
		{
			buf.writeBytes( buffer.buf, offset, len );
		}
		
		[Deprecated]
		public function getValue( key: uint ): int
		{
			var current_position: uint = position;
			position = key;
			var value: int = buf.readByte();
			position = current_position;
			return value;
		}
		
		[Deprecated]
		public function setValue( key: uint, value: int ): void
		{
			buf[ key ] = value;
		}

		flash_proxy override function getProperty( key: * ): *
		{
			var current_position: uint = position;
			position = uint( key );
			var value: int = buf.readByte();
			position = current_position;
			return value;
		}

		flash_proxy override function setProperty( name: *, value: * ): void
		{
			buf[ uint( name ) ] = value;
		}
	}
}