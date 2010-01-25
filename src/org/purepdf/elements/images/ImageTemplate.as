package org.purepdf.elements.images
{
	import org.purepdf.elements.Element;
	import org.purepdf.errors.BadElementError;
	import org.purepdf.pdf.PdfTemplate;

	public class ImageTemplate extends ImageElement
	{
		public function ImageTemplate( obj: Object /*template: PdfTemplate*/ )
		{
			super( obj is PdfTemplate ? null : ( obj is ImageElement ? obj : null ) );
			
			if( obj is PdfTemplate )
			{
				var template: PdfTemplate = obj as PdfTemplate;
			
				if( template.type == PdfTemplate.TYPE_PATTERN )
					throw new BadElementError( "a pattern can not be used as a template to create an image" );
			
				_type = Element.IMGTEMPLATE;
				_scaledHeight = template.height;
				setTop(scaledHeight);
				_scaledWidth = template.width;
				setRight( scaledWidth );
				templateData = template;
				plainWidth = width;
				plainHeight = height;
			} else if( obj is ImageTemplate )
			{
				
			} else {
				throw new ArgumentError("invalid parameter passed");
			}
		}
	}
}