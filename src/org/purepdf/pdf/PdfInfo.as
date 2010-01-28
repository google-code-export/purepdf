/*
*                             ______ _____  _______ 
* .-----..--.--..----..-----.|   __ \     \|    ___|
* |  _  ||  |  ||   _||  -__||    __/  --  |    ___|
* |   __||_____||__|  |_____||___|  |_____/|___|    
* |__|
* $Id$
* $Author Alessandro Crugnola $
* $Rev$ $LastChangedDate$
* $URL$
*
* The contents of this file are subject to  LGPL license 
* (the "GNU LIBRARY GENERAL PUBLIC LICENSE"), in which case the
* provisions of LGPL are applicable instead of those above.  If you wish to
* allow use of your version of this file only under the terms of the LGPL
* License and not to allow others to use your version of this file under
* the MPL, indicate your decision by deleting the provisions above and
* replace them with the notice and other provisions required by the LGPL.
* If you do not delete the provisions above, a recipient may use your version
* of this file under either the MPL or the GNU LIBRARY GENERAL PUBLIC LICENSE
*
* Software distributed under the License is distributed on an "AS IS" basis,
* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
* for the specific language governing rights and limitations under the License.
*
* The Original Code is 'iText, a free JAVA-PDF library' ( version 4.2 ) by Bruno Lowagie.
* All the Actionscript ported code and all the modifications to the
* original java library are written by Alessandro Crugnola (alessandro@sephiroth.it)
*
* This library is free software; you can redistribute it and/or modify it
* under the terms of the MPL as stated above or under the terms of the GNU
* Library General Public License as published by the Free Software Foundation;
* either version 2 of the License, or any later version.
*
* This library is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
* FOR A PARTICULAR PURPOSE. See the GNU LIBRARY GENERAL PUBLIC LICENSE for more
* details
*
* If you didn't download this code from the following link, you should check if
* you aren't using an obsolete version:
* http://code.google.com/p/purepdf
*
*/
package org.purepdf.pdf
{
	import org.purepdf.utils.StringUtils;

	public class PdfInfo extends PdfDictionary
	{
		public function PdfInfo()
		{
			super();
			addProducer();
			addCreationDate();
		}
		
		public function addTitle( title: String ): void
		{
			put( PdfName.TITLE, new PdfString( title, PdfObject.TEXT_UNICODE ) );
		}
		
		public function addSubject( subject: String ): void
		{
			put( PdfName.SUBJECT, new PdfString( subject, PdfObject.TEXT_UNICODE ) );
		}
		
		public function addAuthor( author: String ): void
		{
			put( PdfName.AUTHOR, new PdfString( author, PdfObject.TEXT_UNICODE ) );
		}
		
		public function addKeywords( keywords: String ): void
		{
			put( PdfName.KEYWORDS, new PdfString( keywords, PdfObject.TEXT_UNICODE ) );
		}
		
		public function addCreator( creator: String ): void
		{
			put( PdfName.CREATOR, new PdfString( creator, PdfObject.TEXT_UNICODE ) );
		}
		
		public function addProducer(): void
		{
			put( PdfName.PRODUCER, new PdfString( PdfWriter.VERSION ) );
		}
		
		public static function getCreationDate(): String
		{
			var date: Date = new Date();
			var str: String = 'D:';
			str += date.getFullYear().toString();
			str += StringUtils.padLeft( date.getMonth().toString(), "0", 2 );
			str += StringUtils.padLeft( date.getDate().toString(), "0", 2 );
			str += StringUtils.padLeft( date.getHours().toString(), "0", 2 );
			str += StringUtils.padLeft( date.getMinutes().toString(), "0", 2 );
			str += StringUtils.padLeft( date.getSeconds().toString(), "0", 2 );
			str += "+01'00'";
			
			return str;
		}
		
		public function addCreationDate(): void
		{
			var str: String = getCreationDate();
			put( PdfName.CREATIONDATE, new PdfString( str ) );
			put( PdfName.MODDATE, new PdfString( str ) );
		}
	}
}