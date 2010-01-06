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