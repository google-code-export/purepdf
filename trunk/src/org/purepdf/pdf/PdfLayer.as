package org.purepdf.pdf
{
	import org.purepdf.pdf.interfaces.IPdfOCG;
	import org.purepdf.utils.assertTrue;

	public class PdfLayer extends PdfDictionary implements IPdfOCG
	{
		protected var _children: Vector.<IPdfOCG>;
		protected var _parent: PdfLayer;
		protected var _title: String;
		protected var _ref: PdfIndirectReference;

		private var _on: Boolean = true;
		private var _onPanel: Boolean = true;

		/**
		 * Create a new layer.
		 * If only name is passed then a new title layer will be created
		 */
		public function PdfLayer( $name: String = null, writer: PdfWriter = null )
		{
			if( writer == null )
			{
				_title = $name;
			} else 
			{
				super( PdfName.OCG );
				name = $name;
				_ref = writer.getPdfIndirectReference();
				writer.registerLayer( this );
			}
		}

		/**
		 * Adds a new child to the children list
		 * @throws Error
		 */
		public function addChild( child: PdfLayer ): void
		{
			if ( child.parent != null )
				throw new Error( "child has already a parent" );
			child._parent = this;

			if ( _children == null )
				_children = new Vector.<IPdfOCG>();
			_children.push( child );
		}

		public function get children(): Vector.<IPdfOCG>
		{
			return _children;
		}

		/**
		 * Get the dictionary representing the layer.
		 */
		public function get pdfObject(): PdfObject
		{
			return this;
		}

		public function get ref(): PdfIndirectReference
		{
			return _ref;
		}

		/**
		 * Set the name of this layer
		 */
		public function set name( value: String ): void
		{
			put( PdfName.NAME, new PdfString( value, PdfObject.TEXT_UNICODE ) );
		}

		public function get onPanel(): Boolean
		{
			return _onPanel;
		}

		/**
		 * Sets the visibility of the layer in Acrobat's layer panel.
		 * If <CODE>false</CODE> the layer can not be manipulated by users
		 */
		public function set onPanel( value: Boolean ): void
		{
			_onPanel = value;
		}

		public function get parent(): PdfLayer
		{
			return _parent;
		}

		/**
		 * @param creator a text string specifying the application that created the group
		 * @param subtype a string defining the type of content controlled by the group
		 */
		public function setCreatorInfo( creator: String, subtype: String ): void
		{
			var u: PdfDictionary = usage;
			var dic: PdfDictionary = new PdfDictionary();
			dic.put( PdfName.CREATOR, new PdfString( creator, PdfObject.TEXT_UNICODE ) );
			dic.put( PdfName.SUBTYPE, new PdfName( subtype ) );
			u.put( PdfName.CREATORINFO, dic );
		}

		/**
		 * Specifies the recommended state for content in this group when the document
		 * is saved by a viewer application to a format that does not support optional content
		 */
		public function setExport( export: Boolean ): void
		{
			var u: PdfDictionary = usage;
			var dic: PdfDictionary = new PdfDictionary();
			dic.put( PdfName.EXPORTSTATE, export ? PdfName.ON : PdfName.OFF );
			u.put( PdfName.EXPORT, dic );
		}


		/**
		 * Specifies the language of the content controlled by this optional content group
		 */
		public function setLanguage( language: String, preferred: Boolean ): void
		{
			var u: PdfDictionary = usage;
			var dic: PdfDictionary = new PdfDictionary();
			dic.put( PdfName.LANG, new PdfString( language, PdfObject.TEXT_UNICODE ) );

			if ( preferred )
				dic.put( PdfName.PREFERRED, PdfName.ON );
			u.put( PdfName.LANGUAGE, dic );
		}

		/**
		 * Specifies that the content in this group is intended for use in printing
		 */
		public function setPrint( subtype: String, printstate: Boolean ): void
		{
			var u: PdfDictionary = usage;
			var dic: PdfDictionary = new PdfDictionary();
			dic.put( PdfName.SUBTYPE, new PdfName( subtype ) );
			dic.put( PdfName.PRINTSTATE, printstate ? PdfName.ON : PdfName.OFF );
			u.put( PdfName.PRINT, dic );
		}

		public function set ref( value: PdfIndirectReference ): void
		{
			_ref = value;
		}

		/**
		 * Indicates that the group should be set to that state when the
		 * document is opened in a viewer application.
		 */
		public function setView( view: Boolean ): void
		{
			var u: PdfDictionary = usage;
			var dic: PdfDictionary = new PdfDictionary();
			dic.put( PdfName.VIEWSTATE, view ? PdfName.ON : PdfName.OFF );
			u.put( PdfName.VIEW, dic );
		}

		/**
		 * Specifies a range of magnifications at which the content
		 * in this optional content group is best viewed.
		 */
		public function setZoom( min: Number, max: Number ): void
		{
			if ( min <= 0 && max < 0 )
				return;
			var u: PdfDictionary = usage;
			var dic: PdfDictionary = new PdfDictionary();

			if ( min > 0 )
				dic.put( PdfName.MIN_LOWER_CASE, new PdfNumber( min ) );

			if ( max > 0 )
				dic.put( PdfName.MAX_LOWER_CASE, new PdfNumber( max ) );
			u.put( PdfName.ZOOM, dic );
		}

		public function get title(): String
		{
			return _title;
		}

		/**
		 * The the layer visibility
		 */
		public function get visible(): Boolean
		{
			return _on;
		}

		/**
		 * The the visibility of this layer
		 */
		public function set visible( value: Boolean ): void
		{
			_on = value;
		}

		private function get usage(): PdfDictionary
		{
			var u: PdfDictionary = getValue( PdfName.USAGE ) as PdfDictionary;

			if ( u == null )
			{
				u = new PdfDictionary();
				put( PdfName.USAGE, u );
			}
			return u;
		}

		/**
		 * Creates a titled layer. A title layer is not really a layer but a collection
		 * of layers under the same title heading
		 * 
		 * @throws ArgumentError
		 */
		public static function createTitle( title: String, writer: PdfWriter ): PdfLayer
		{
			if ( title == null )
				throw new ArgumentError( "title cannot be null" );
			var layer: PdfLayer = new PdfLayer( title );
			writer.registerLayer( layer );
			return layer;
		}
	}
}