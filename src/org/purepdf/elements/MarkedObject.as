package org.purepdf.elements
{
	import flash.utils.Dictionary;
	
	import org.purepdf.errors.DocumentError;

	public class MarkedObject implements IElement
	{
		protected var _element: IElement;
		protected var _properties: Dictionary;

		public function MarkedObject( $element: IElement = null )
		{
			_element = $element;
		}
		
		public function get element(): IElement
		{
			return _element;
		}
		
		public function get markupAttributes(): Dictionary
		{
			return _properties;
		}
		
		public function set markupAttributes( value: Dictionary ): void
		{
			_properties = value;
		}
		
		public function setMarkupAttribute( key: String, value: String ): void
		{
			_properties[key] = value;
		}
		
		public function process(listener:IElementListener):Boolean
		{
			try
			{
				return listener.add( _element );
			} catch( de: DocumentError )
			{}
			return false;
		}
		
		public function getChunks():Vector.<Object>
		{
			return _element.getChunks();
		}
		
		public function get isNestable():Boolean
		{
			return true;
		}
		
		public function get isContent():Boolean
		{
			return true;
		}
		
		public function toString():String
		{
			return null;
		}
		
		public function get type():int
		{
			return Element.MARKED;
		}
	}
}