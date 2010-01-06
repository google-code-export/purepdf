package org.purepdf.pdf
{
	public class Indentation
	{
		/** This represents the current indentation of the PDF Elements on the left side. */
		public var indentLeft: Number = 0;
		
		/** Indentation to the left caused by a section. */
		public var sectionIndentLeft: Number = 0;
		
		/** This represents the current indentation of the PDF Elements on the left side. */
		public var listIndentLeft: Number = 0;
		
		/** This is the indentation caused by an image on the left. */
		public var imageIndentLeft: Number = 0;
		
		/** This represents the current indentation of the PDF Elements on the right side. */
		public var indentRight: Number = 0;
		
		/** Indentation to the right caused by a section. */
		public var sectionIndentRight: Number = 0;
		
		/** This is the indentation caused by an image on the right. */
		public var imageIndentRight: Number = 0;
		
		/** This represents the current indentation of the PDF Elements on the top side. */
		public var indentTop: Number = 0;
		
		/** This represents the current indentation of the PDF Elements on the bottom side. */
		public var indentBottom: Number = 0;
	}
}