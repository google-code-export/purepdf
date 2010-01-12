package org.purepdf.io
{
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	
	public class LineReader implements IDataInput
	{
		private var data: ByteArray;
		
		public function LineReader( input: ByteArray )
		{
			data = input;
		}
		
		public function readLine(): String
		{
			var input: String = "";
			var c: int = -1;
			var eol: Boolean = false;
			
			while( !eol )
			{
				switch( c = read() )
				{
					case -1:
					case 10:
						eol = true;
						break;
					
					case 13:
						eol = true;
						var cur: uint = data.position;
						if( read() != 10 )
							data.position = cur;
						break;
					
					default:
						input += String.fromCharCode( c );
						break;
				}
			}
			
			if( c == -1 && input.length == 0 )
				return null;
			
			return input;
		}
		
		public function read(): int
		{
			try
			{
				return data.readUnsignedByte();
			} catch( e: Error )
			{
			}
			return -1;
		}
		
		public function readBytes(bytes:ByteArray, offset:uint=0, length:uint=0):void
		{
			data.readBytes( bytes, offset, length );
		}
		
		public function readBoolean():Boolean
		{
			return data.readBoolean();
		}
		
		public function readByte():int
		{
			return data.readByte();
		}
		
		public function readUnsignedByte():uint
		{
			return data.readUnsignedByte();
		}
		
		public function readShort():int
		{
			return data.readShort();
		}
		
		public function readUnsignedShort():uint
		{
			return data.readUnsignedShort();
		}
		
		public function readInt():int
		{
			return data.readInt();
		}
		
		public function readUnsignedInt():uint
		{
			return data.readUnsignedInt();
		}
		
		public function readFloat():Number
		{
			return data.readFloat();
		}
		
		public function readDouble():Number
		{
			return data.readDouble();
		}
		
		public function readMultiByte(length:uint, charSet:String):String
		{
			return data.readMultiByte( length, charSet );
		}
		
		public function readUTF():String
		{
			return data.readUTF();
		}
		
		public function readUTFBytes(length:uint):String
		{
			return data.readUTFBytes( length );
		}
		
		public function get bytesAvailable():uint
		{
			return data.bytesAvailable;
		}
		
		public function readObject():*
		{
			return data.readObject();
		}
		
		public function get objectEncoding():uint
		{
			return data.objectEncoding;
		}
		
		public function set objectEncoding(version:uint):void
		{
			data.objectEncoding = version;
		}
		
		public function get endian():String
		{
			return data.endian;
		}
		
		public function set endian(type:String):void
		{
			data.endian = type;
		}
	}
}