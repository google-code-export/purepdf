package org.purepdf.pdf
{
	import it.sephiroth.utils.HashMap;
	import it.sephiroth.utils.ObjectHash;
	
	import org.purepdf.elements.AnnotationElement;
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.errors.NonImplementatioError;

	public class PdfAnnotationsImp extends ObjectHash
	{
		protected var annotations: Vector.<PdfAnnotation>;
		protected var delayedAnnotations: Vector.<PdfAnnotation> = new Vector.<PdfAnnotation>();
		protected var acroForm: PdfAcroForm;
		
		public function PdfAnnotationsImp( $writer: PdfWriter )
		{
			acroForm = new PdfAcroForm( $writer );
		}
		
		public function addAnnotation( annot: PdfAnnotation ): void
		{
			if( annot.isForm )
			{
				var field: PdfFormField = annot as PdfFormField;
				if( field.parent == null )
					addFormFieldRaw( field );
			} else
			{
				annotations.push( annot );
			}
		}
		
		public function hasUnusedAnnotations(): Boolean
		{
			return !( annotations.length == 0 );
		}
		
		public function resetAnnotations(): void
		{
			annotations = delayedAnnotations;
			delayedAnnotations = new Vector.<PdfAnnotation>();
		}
		
		protected function addFormFieldRaw( field: PdfFormField ): void
		{
			annotations.push( field );
			var kids: Array = field.kids;
			
			if( kids != null )
			{
				for( var k: int = 0; k < kids.length; ++k )
					addFormFieldRaw( kids[k] as PdfFormField );
			}
		}
		
		internal static function convertAnnotation( writer: PdfWriter, annot: AnnotationElement, defaultRect: RectangleElement ): PdfAnnotation
		{
			throw new NonImplementatioError();
		}
		
		
		internal function rotateAnnotations( writer: PdfWriter, pageSize: RectangleElement ): PdfArray
		{
			var array: PdfArray = new PdfArray();
			var rotation: int = pageSize.getRotation() % 360;
			var currentPage: int = writer.getCurrentPageNumber();
			
			for( var k: int = 0; k < annotations.length; ++k )
			{
				var dic: PdfAnnotation = annotations[k];
				var page: int = dic.placeInPage;
				if( page > currentPage )
				{
					delayedAnnotations.push( dic );
					continue;
				}
				
				if( dic.isForm )
				{
					if( !dic.isUsed )
					{
						var templates: HashMap = dic.templates;
						if( templates != null )
							acroForm.addFieldTemplates( templates );
					}
					
					var field: PdfFormField = PdfFormField( dic );
					if( field.parent == null )
						acroForm.addDocumentField( field.getIndirectReference() );
				}
				
				if( dic.isAnnotation )
				{
					array.add( dic.getIndirectReference() );
					if( !dic.isUsed )
					{
						var rect: PdfRectangle = dic.getValue( PdfName.RECT ) as PdfRectangle;
						if( rect != null )
						{
							switch( rotation )
							{
								case 90:
									dic.put( PdfName.RECT, new PdfRectangle(
										pageSize.getTop() - rect.bottom,
										rect.left,
										pageSize.getTop() - rect.top,
										rect.right) );
									break;
								
								case 180:
									dic.put( PdfName.RECT, new PdfRectangle(
										pageSize.getRight() - rect.left,
										pageSize.getTop() - rect.bottom,
										pageSize.getRight() - rect.right,
										pageSize.getTop() - rect.top) );
									break;
								
								case 270:
									dic.put( PdfName.RECT, new PdfRectangle(
										rect.bottom,
										pageSize.getRight() - rect.left,
										rect.top,
										pageSize.getRight() - rect.right) );
									break;
							}
						}
					}
				}
				
				if( !dic.isUsed )
				{
					dic.isUsed = true;
					writer.addToBody1( dic, dic.getIndirectReference() );
				}
			}
			return array;
		}
	}
}