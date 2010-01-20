package org.purepdf.elements.images
{
	import org.purepdf.elements.Element;
	import org.purepdf.errors.BadElementError;
	import org.purepdf.pdf.PdfTemplate;

	public class ImageTemplate extends ImageElement
	{
		public function ImageTemplate( template: PdfTemplate )
		{
			super( null );
			if( template == null )
				throw new BadElementError("the template can not be null");
			
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
		}
	}
}