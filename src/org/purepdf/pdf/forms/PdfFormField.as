package org.purepdf.pdf.forms
{
	import it.sephiroth.utils.collections.iterators.Iterator;
	
	import mx.effects.Resize;
	
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.errors.NonImplementatioError;
	import org.purepdf.pdf.PdfAnnotation;
	import org.purepdf.pdf.PdfArray;
	import org.purepdf.pdf.PdfDictionary;
	import org.purepdf.pdf.PdfFont;
	import org.purepdf.pdf.PdfName;
	import org.purepdf.pdf.PdfNumber;
	import org.purepdf.pdf.PdfObject;
	import org.purepdf.pdf.PdfReader;
	import org.purepdf.pdf.PdfRectangle;
	import org.purepdf.pdf.PdfString;
	import org.purepdf.pdf.PdfTemplate;
	import org.purepdf.pdf.PdfWriter;
	
	public class PdfFormField extends PdfAnnotation
	{
		public static const FF_READ_ONLY: int = 1;
		public static const FF_REQUIRED: int = 2;
		public static const FF_NO_EXPORT: int = 4;
		public static const FF_NO_TOGGLE_TO_OFF: int = 16384;
		public static const FF_RADIO: int = 32768;
		public static const FF_PUSHBUTTON: int = 65536;
		public static const FF_MULTILINE: int = 4096;
		public static const FF_PASSWORD: int = 8192;
		public static const FF_COMBO: int = 131072;
		public static const FF_EDIT: int = 262144;
		public static const FF_FILESELECT: int = 1048576;
		public static const FF_MULTISELECT: int = 2097152;
		public static const FF_DONOTSPELLCHECK: int = 4194304;
		public static const FF_DONOTSCROLL: int = 8388608;
		public static const FF_COMB: int = 16777216;
		public static const FF_RADIOSINUNISON: int = 1 << 25;
		public static const Q_LEFT: int = 0;
		public static const Q_CENTER: int = 1;
		public static const Q_RIGHT: int = 2;
		public static const MK_NO_ICON: int = 0;
		public static const MK_NO_CAPTION: int = 1;
		public static const MK_CAPTION_BELOW: int = 2;
		public static const MK_CAPTION_ABOVE: int = 3;
		public static const MK_CAPTION_RIGHT: int = 4;
		public static const MK_CAPTION_LEFT: int = 5;
		public static const MK_CAPTION_OVERLAID: int = 6;
		public static const IF_SCALE_ALWAYS: PdfName = PdfName.A;
		public static const IF_SCALE_BIGGER: PdfName = PdfName.B;
		public static const IF_SCALE_SMALLER: PdfName = PdfName.S;
		public static const IF_SCALE_NEVER: PdfName = PdfName.N;
		public static const IF_SCALE_ANAMORPHIC: PdfName = PdfName.A;
		public static const IF_SCALE_PROPORTIONAL: PdfName = PdfName.P;
		public static const MULTILINE: Boolean = true;
		public static const SINGLELINE: Boolean = false;
		public static const PLAINTEXT: Boolean = false;
		public static const PASSWORD: Boolean = true;
		
		protected var _parent: PdfFormField;
		protected var _kids: Vector.<PdfFormField>;
		
		private static const mergeTarget: Vector.<PdfName> = Vector.<PdfName>( [PdfName.FONT, PdfName.XOBJECT, PdfName.COLORSPACE, PdfName.PATTERN] );
		
		public function PdfFormField( $writer: PdfWriter, rect: RectangleElement = null )
		{
			super($writer, rect);
		}
		
		public function setWidget( rect: RectangleElement, highlight: PdfName) : void 
		{
			put(PdfName.TYPE, PdfName.ANNOT);
			put(PdfName.SUBTYPE, PdfName.WIDGET);
			put(PdfName.RECT, PdfRectangle.createFromRectangle(rect));
			annotation = true;
			if (highlight != null && !highlight.equals(HIGHLIGHT_INVERT))
				put(PdfName.H, highlight);
		}
		
		public static function createEmpty( writer: PdfWriter ): PdfFormField
		{
			var field: PdfFormField = new PdfFormField( writer, null );
			return field;
		}
		
		public function setButton( flags: int ): void
		{
			put(PdfName.FT, PdfName.BTN);
			if (flags != 0)
				put(PdfName.FF, new PdfNumber(flags));
		}
		
		protected static function createButton( writer: PdfWriter, flags: int ): PdfFormField
		{
			var field: PdfFormField = new PdfFormField(writer, null);
			field.setButton(flags);
			return field;
		}
		
		public static function createPushButton( writer: PdfWriter ): PdfFormField
		{
			return createButton(writer, FF_PUSHBUTTON);
		}
		
		public static function createCheckBox( writer: PdfWriter): PdfFormField
		{
			return createButton(writer, 0);
		}
		
		public static function createRadioButton( writer: PdfWriter,  noToggleToOff: Boolean) : PdfFormField
		{
			return createButton(writer, FF_RADIO + (noToggleToOff ? FF_NO_TOGGLE_TO_OFF : 0));
		}
		
		public static function createTextField(writer: PdfWriter,  multiline: Boolean,  password: Boolean,  maxLen: int ): PdfFormField
		{
			var field: PdfFormField = new PdfFormField(writer);
			field.put(PdfName.FT, PdfName.TX);
			var flags: int = (multiline ? FF_MULTILINE : 0);
			flags += (password ? FF_PASSWORD : 0);
			field.put(PdfName.FF, new PdfNumber(flags));
			if (maxLen > 0)
				field.put(PdfName.MAXLEN, new PdfNumber(maxLen));
			return field;
		}
		
		protected static function createChoice( writer: PdfWriter, flags: int, options: PdfArray, topIndex: int ): PdfFormField
		{
			var field: PdfFormField = new PdfFormField(writer);
			field.put(PdfName.FT, PdfName.CH);
			field.put(PdfName.FF, new PdfNumber(flags));
			field.put(PdfName.OPT, options);
			if (topIndex > 0)
				field.put(PdfName.TI, new PdfNumber(topIndex));
			return field;
		}
		
		public static function createList( writer: PdfWriter, options: Vector.<String>, topIndex: int ): PdfFormField
		{
			return createChoice(writer, 0, processOptions(options), topIndex);
		}
		
		public static function createLists(writer: PdfWriter,  options: Vector.<Vector.<String>>, topIndex: int ): PdfFormField
		{
			return createChoice(writer, 0, processOptions2(options), topIndex);
		}
		
		public static function createCombo( writer: PdfWriter,  edit: Boolean, options: Vector.<String>, topIndex: int ): PdfFormField
		{
			return createChoice(writer, FF_COMBO + (edit ? FF_EDIT : 0), processOptions(options), topIndex);
		}
		
		public static function createCombos( writer: PdfWriter,  edit: Boolean, options: Vector.<Vector.<String>>, topIndex: int ): PdfFormField
		{
			return createChoice(writer, FF_COMBO + (edit ? FF_EDIT : 0), processOptions2(options), topIndex);
		}
		
		protected static function processOptions( options: Vector.<String> ): PdfArray {
			var array: PdfArray = new PdfArray();
			for ( var k: int = 0; k < options.length; ++k) 
			{
				array.add(new PdfString(options[k], PdfObject.TEXT_UNICODE));
			}
			return array;
		}
		
		protected static function processOptions2(options: Vector.<Vector.<String>>): PdfArray
		{
			var  array: PdfArray = new PdfArray();
			for ( var k: int = 0; k < options.length; ++k) {
				var subOption: Vector.<String> = options[k];
				var ar2: PdfArray = new PdfArray(new PdfString(subOption[0], PdfObject.TEXT_UNICODE));
				ar2.add(new PdfString(subOption[1], PdfObject.TEXT_UNICODE));
				array.add(ar2);
			}
			return array;
		}
		
		public static function createSignature( writer: PdfWriter ): PdfFormField
		{
			var field: PdfFormField = new PdfFormField(writer);
			field.put(PdfName.FT, PdfName.SIG);
			return field;
		}
		
		public function addKid( field: PdfFormField ): void {
			field.parent = this;
			if (_kids == null)
				_kids = new Vector.<PdfFormField>();
			_kids.push( field );
		}
		
		public function setFieldFlags( value: int ): int
		{
			var obj: PdfNumber = getValue( PdfName.FF ) as PdfNumber;
			var old: int;
			if (obj == null)
				old = 0;
			else
				old = obj.intValue();
			fieldFlags = value;
			return old;
		}
		
		public function set fieldFlags( flags: int ): void
		{
			var obj: PdfNumber = getValue(PdfName.FF) as PdfNumber;
			var old: int;
			if (obj == null)
				old = 0;
			else
				old = obj.intValue();
			var v: int = old | flags;
			put(PdfName.FF, new PdfNumber(v));
		}
		
		public function set valueAsString( s: String): void
		{
			put(PdfName.V, new PdfString(s, PdfObject.TEXT_UNICODE));
		}
		
		public function set valueAsName( s: String ): void
		{
			put(PdfName.V, new PdfName(s));
		}
		
		public function set defaultValueAsString( s: String): void
		{
			put(PdfName.DV, new PdfString(s, PdfObject.TEXT_UNICODE));
		}
		
		public function set defaultValueAsName( s: String ): void
		{
			put(PdfName.DV, new PdfName(s));
		}
		
		public function set fieldName( s: String ): void {
			if (s != null)
				put(PdfName.T, new PdfString(s, PdfObject.TEXT_UNICODE));
		}
		
		public function set userName( s: String ): void
		{
			put(PdfName.TU, new PdfString(s, PdfObject.TEXT_UNICODE));
		}
		
		public function set mappingName( s: String ): void
		{
			put(PdfName.TM, new PdfString(s, PdfObject.TEXT_UNICODE));
		}
		
		public function set quadding( v: int ): void
		{
			put(PdfName.Q, new PdfNumber(v));
		}
		
		protected static function mergeResources2( result: PdfDictionary, source: PdfDictionary, writer: Object ): void {
			var dic: PdfDictionary = null;
			var res: PdfDictionary = null;
			var target: PdfName = null;
			for ( var k: int = 0; k < mergeTarget.length; ++k )
			{
				target = mergeTarget[k];
				var pdfDict: PdfDictionary = source.getAsDict(target);
				if ((dic = pdfDict) != null) {
					res = PdfReader.getPdfObjects(result.getValue(target), result) as PdfDictionary;
					if (res == null) 
					{
						res = new PdfDictionary();
					}
					res.mergeDifferent(dic);
					result.put(target, res);
					if (writer != null)
						throw new NonImplementatioError();
				}
			}
		}
		
		protected static function mergeResources( result: PdfDictionary, source: PdfDictionary ): void
		{
			mergeResources2(result, source, null);
		}
		
		public function setUsed(): void
		{
			used = true;
			if (parent != null)
				put(PdfName.PARENT, parent.getIndirectReference());
			if (_kids != null) {
				var array: PdfArray = new PdfArray();
				for ( var k: int = 0; k < kids.length; ++k)
					array.add( PdfFormField(kids[k]).getIndirectReference() );
				put(PdfName.KIDS, array);
			}
			if (templates == null)
				return;
			var dic: PdfDictionary = new PdfDictionary();
			for ( var it: Iterator = templates.keySet().iterator(); it.hasNext();)
			{
				var template: PdfTemplate = PdfTemplate(it.next());
				mergeResources(dic, PdfDictionary(template.resources));
			}
			put(PdfName.DR, dic);
		}

		
		public function get parent(): PdfFormField
		{
			return _parent;
		}
		
		public function get kids(): Vector.<PdfFormField>
		{
			return _kids;
		}
		
		public function set parent( value: PdfFormField ): void
		{
			_parent = value;
		}
		
		public static function shallowDuplicate( annot: PdfAnnotation ): PdfAnnotation
		{
			var dup: PdfAnnotation;
			if ( annot.isForm ) {
				dup = new PdfFormField( annot.writer, null );
				var dupField: PdfFormField = PdfFormField(dup);
				var srcField: PdfFormField = PdfFormField(annot);
				dupField._parent = srcField.parent;
				dupField._kids = srcField.kids;
			} else
			{
				dup = new PdfAnnotation( annot.writer, null );
			}
			dup.merge(annot);
			dup.form = annot.form;
			dup.annotation = annot.annotation;
			dup.templates = annot.templates;
			return dup;
		}
	}
}