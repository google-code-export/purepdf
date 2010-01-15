package org.purepdf.elements.images
{
	import flash.utils.ByteArray;
	
	import org.purepdf.elements.Element;

	public class ImageRaw extends ImageElement
	{
		public function ImageRaw( $width: int, $height: int, $components: int, $bpc: int, $data: ByteArray )
		{
			super( null );
			_type = Element.IMGRAW;
			_scaledHeight = $height;
			setTop( _scaledHeight );
			_scaledWidth = $width;
			setRight( _scaledWidth );

			if ( $components != 1 && $components != 3 && $components != 4 )
				throw new Error( "components must be 1, 3 or 4" );

			if ( $bpc != 1 && $bpc != 2 && $bpc != 4 && $bpc != 8 )
				throw new Error( "bits per component must be 1, 2, 4 or 8" );
			_colorspace = $components;
			_bpc = $bpc;
			_rawData = $data;
			plainWidth = width;
			plainHeight = height;
		}
	}
}