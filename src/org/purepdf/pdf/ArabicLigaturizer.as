/*
* $Id: SimpleCell.as 177 2010-01-26 08:36:57Z alessandro.crugnola $
* $Author Alessandro Crugnola $
* $Rev: 177 $ $LastChangedDate: 2010-01-26 09:36:57 +0100 (Tue, 26 Jan 2010) $
* $URL: https://purepdf.googlecode.com/svn/trunk/src/org/purepdf/elements/SimpleCell.as $
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
* The Original Code is 'iText, a free JAVA-PDF library' by Bruno Lowagie.
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
	import org.purepdf.errors.NonImplementatioError;

	public class ArabicLigaturizer
	{
		public static const DIGITS_MASK: int = 0xe0;
		public static const DIGIT_TYPE_MASK: int = 0x0100; // 0x3f00?
		public static const DIGITS_EN2AN: int = 0x20;
		public static const DIGITS_AN2EN: int = 0x40;
		public static const DIGITS_EN2AN_INIT_LR: int = 0x60;
		public static const DIGITS_EN2AN_INIT_AL: int = 0x80;
		public static const DIGIT_TYPE_AN: int = 0;
		public static const DIGIT_TYPE_AN_EXTENDED: int = 0x100;

		public function ArabicLigaturizer()
		{
		}

		static public function processNumbers( text: Vector.<int>, offset: int, length: int, options: int ): void
		{
			var limit: int = offset + length;
			var i: int;
			var ch: int;
			var digitTop: int;
			var digitDelta: int;
			var digitBase: int;

			if ( ( options & DIGITS_MASK ) != 0 )
			{
				digitBase = 48; // European digits

				switch ( options & DIGIT_TYPE_MASK )
				{
					case DIGIT_TYPE_AN:
						digitBase = 1632; // Arabic-Indic digits
						break;
					case DIGIT_TYPE_AN_EXTENDED:
						digitBase = 1776; // Eastern Arabic-Indic digits (Persian and Urdu)
						break;
					default:
						break;
				}

				switch ( options & DIGITS_MASK )
				{
					case DIGITS_EN2AN:
						digitDelta = digitBase - 48;
						for ( i = offset; i < limit; ++i )
						{
							ch = text[i];
							if ( ch <= 57 && ch >= 48 )
								text[i] += digitDelta;
						}
						break;
					
					case DIGITS_AN2EN:
						digitTop = ( digitBase + 9 );
						digitDelta = 48 - digitBase;

						for ( i = offset; i < limit; ++i )
						{
							ch = text[i];
							if ( ch <= digitTop && ch >= digitBase )
								text[i] += digitDelta;
						}
						break;
					
					case DIGITS_EN2AN_INIT_LR:
						throw new NonImplementatioError("DIGITS_EN2AN_INIT_LR not yet implemented");
						break;
					case DIGITS_EN2AN_INIT_AL:
						throw new NonImplementatioError("DIGITS_EN2AN_INIT_AL not yet implemented");
						break;
					default:
						break;
				}
			}
		}
	}
}