package org.purepdf.pdf
{
	import org.purepdf.utils.collections.HashMap;
	import org.purepdf.utils.iterators.Iterator;
	import org.purepdf.utils.iterators.VectorIterator;

	public class PageResources
	{
		protected var colorDictionary: PdfDictionary = new PdfDictionary();
		protected var extGStateDictionary: PdfDictionary = new PdfDictionary();
		protected var fontDictionary: PdfDictionary = new PdfDictionary();
		protected var forbiddenNames: HashMap;
		protected var namePtr: Vector.<int> = Vector.<int>( [ 0 ] );
		protected var originalResources: PdfDictionary;
		protected var patternDictionary: PdfDictionary = new PdfDictionary();
		protected var propertyDictionary: PdfDictionary = new PdfDictionary();
		protected var shadingDictionary: PdfDictionary = new PdfDictionary();
		protected var usedNames: HashMap;
		protected var xObjectDictionary: PdfDictionary = new PdfDictionary();

		public function PageResources()
		{
		}

		public function addDefaultColorDiff( dic: PdfDictionary ): void
		{
			colorDictionary.mergeDifferent( dic );
		}

		public function getResources(): PdfDictionary
		{
			var resources: PdfResources = new PdfResources();

			if ( originalResources != null )
				resources.putAll( originalResources );
			resources.put( PdfName.PROCSET, new PdfLiteral( "[/PDF /Text /ImageB /ImageC /ImageI]" ) );
			resources.add( PdfName.FONT, fontDictionary );
			resources.add( PdfName.XOBJECT, xObjectDictionary );
			resources.add( PdfName.COLORSPACE, colorDictionary );
			resources.add( PdfName.PATTERN, patternDictionary );
			resources.add( PdfName.SHADING, shadingDictionary );
			resources.add( PdfName.EXTGSTATE, extGStateDictionary );
			resources.add( PdfName.PROPERTIES, propertyDictionary );
			return resources;
		}

		internal function addColor( name: PdfName, reference: PdfIndirectReference ): PdfName
		{
			name = translateName( name );
			colorDictionary.put( name, reference );
			return name;
		}

		internal function addDefaultColor( dic: PdfDictionary ): void
		{
			colorDictionary.merge( dic );
		}

		internal function addDefaultColor2( name: PdfName, obj: PdfObject ): void
		{
			if ( obj == null || obj.isNull() )
				colorDictionary.remove( name );
			else
				colorDictionary.put( name, obj );
		}

		internal function addExtGState( name: PdfName, reference: PdfIndirectReference ): PdfName
		{
			name = translateName( name );
			extGStateDictionary.put( name, reference );
			return name;
		}

		internal function addFont( name: PdfName, reference: PdfIndirectReference ): PdfName
		{
			name = translateName( name );
			fontDictionary.put( name, reference );
			return name;
		}

		internal function addPattern( name: PdfName, reference: PdfIndirectReference ): PdfName
		{
			name = translateName( name );
			patternDictionary.put( name, reference );
			return name;
		}

		internal function addProperty( name: PdfName, reference: PdfIndirectReference ): PdfName
		{
			name = translateName( name );
			propertyDictionary.put( name, reference );
			return name;
		}

		internal function addShading( name: PdfName, reference: PdfIndirectReference ): PdfName
		{
			name = translateName( name );
			shadingDictionary.put( name, reference );
			return name;
		}

		internal function addXObject( name: PdfName, reference: PdfIndirectReference ): PdfName
		{
			name = translateName( name );
			xObjectDictionary.put( name, reference );
			return name;
		}

		internal function setOriginalResources( resources: PdfDictionary, newNamePtr: Vector.<int> ): void
		{
			if ( newNamePtr != null )
				namePtr = newNamePtr;
			forbiddenNames = new HashMap();
			usedNames = new HashMap();

			if ( resources == null )
				return;
			originalResources = new PdfDictionary();
			originalResources.merge( resources );
			var i: Iterator = new VectorIterator( resources.getKeys() );

			for ( i; i.hasNext();  )
			{
				var key: PdfName = PdfName( i.next() );
				var sub: PdfObject = PdfReader.getPdfObject( resources.getValue( key ) );

				if ( sub != null && sub.isDictionary() )
				{
					var dic: PdfDictionary = PdfDictionary( sub );
					var j: Iterator = new VectorIterator( dic.getKeys() );

					for ( j; j.hasNext();  )
					{
						forbiddenNames.put( j.next(), null );
					}
					var dic2: PdfDictionary = new PdfDictionary();
					dic2.merge( dic );
					originalResources.put( key, dic2 );
				}
			}
		}

		private function translateName( name: PdfName ): PdfName
		{
			var translated: PdfName = name;

			if ( forbiddenNames != null )
			{
				translated = usedNames.getValue( name );

				if ( translated == null )
				{
					while ( true )
					{
						throw new Error( "check namePtr[0]++" );
						translated = new PdfName( "Xi" + ( namePtr[ 0 ]++ ) );

						if ( !forbiddenNames.containsKey( translated ) )
							break;
					}
					usedNames.put( name, translated );
				}
			}
			return translated;
		}
	}
}