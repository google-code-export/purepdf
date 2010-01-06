package 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.LigatureLevel;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	import org.purepdf.pdf.PdfDocument;
	
	public class DefaultBasicExample extends Sprite
	{
		protected var buffer: ByteArray;
		protected var document: PdfDocument;
		protected var filename: String;
		
		protected var create_button: Sprite;
		
		public function DefaultBasicExample()
		{
			super();
			filename = getQualifiedClassName( this ).split("::").pop() + ".pdf";;
			addEventListener( Event.ADDED_TO_STAGE, added );
		}
		
		protected function added( event: Event ): void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			createchildren();
		}
		
		protected function createchildren(): void
		{
			// To be implemented
			create_default_button();
			createDescription();
		}
		
		protected function createDescription(): void
		{
			//description();
		}
		
		protected function create_default_button( title: String = null ): void
		{
			create_button = createButton( 0xDDDDDD, title ? title : "create", execute );
			center( create_button, null );
			addChild( create_button );
		}
		
		protected function execute( event: Event = null ): void
		{
			buffer = new ByteArray();
		}
		
		protected function save( e: * = null ): void
		{
			var f: FileReference = new FileReference();
			f.save( buffer, filename );
		}
		
		protected function description( ...texts: Array ): void
		{
			var font: FontDescription = new FontDescription();
			font.fontName = "Arial";
			
			var elementFormat: ElementFormat = new ElementFormat();
			elementFormat.fontDescription = font;
			elementFormat.fontSize = 14;
			elementFormat.color = 0;
			elementFormat.ligatureLevel = LigatureLevel.COMMON;
			
			
			var textline: TextLine;
			
			for each( var text: String in texts )
			{
				var tb: TextBlock = new TextBlock();
				tb.content = new TextElement( text, elementFormat );
			
				var tl: TextLine = tb.createTextLine();
				tl.x = ( stage.stageWidth - tl.width ) / 2;
				if( textline )
					tl.y = textline.y + textline.height + 5;
				else
					tl.y = tl.height + 5;
				
				addChild( tl );
				
				textline = tl;
			}
		}
		
		protected function center( obj: DisplayObject, below: DisplayObject = null ): void
		{
			obj.x = ( stage.stageWidth - obj.width ) / 2;
			
			if( below )
				obj.y = below.y + below.height + 5;
			else
				obj.y = ( stage.stageHeight - obj.height ) / 2;
		}
		
		protected function createButton( color: uint = 0xDDDDDD, label: String = "", callBack: Function = null ): Sprite
		{
			var s: Sprite = new Sprite();			
			s.buttonMode = true;
			s.mouseChildren = false;
			
			var font: FontDescription = new FontDescription();
			font.fontName = "Arial";
			
			var elementFormat: ElementFormat = new ElementFormat();
			elementFormat.fontDescription = font;
			elementFormat.fontSize = 26;
			elementFormat.color = 0;
			elementFormat.ligatureLevel = LigatureLevel.COMMON;
			
			var tb: TextBlock = new TextBlock();
			tb.content = new TextElement( label, elementFormat );
			var tl: TextLine = tb.createTextLine();
			
			s.addEventListener( MouseEvent.MOUSE_UP, callBack );
			s.graphics.beginFill( color, 1 );
			s.graphics.drawRoundRect( 0, 0, tl.width + 20, tl.height + 10, 8, 8 );
			s.graphics.endFill();
			
			tl.x = 10;
			tl.y = s.height - 10;
			
			s.addChild( tl );
			return s;
		}
	}
}