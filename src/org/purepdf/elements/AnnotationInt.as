package org.purepdf.elements
{
	public class AnnotationInt extends Annotation
	{
		public function AnnotationInt( named: int )
		{
			super( null );
			
			_annotationtype = NAMED_DEST;
			_annotationAttributes.put( NAMED, named );
		}
	}
}