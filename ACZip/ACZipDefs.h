//
//  ACZipDefs.h
//  ACZip
//
//  Created by Alejandro D. Cotilla on 7/15/13.
//
//  Copyright (c) 2013 Spissa Software Solutions, http://www.spissa.com
//
//  MIT LICENSE
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//


#ifndef ACZipApp_ACZipDefs_h
#define ACZipApp_ACZipDefs_h

enum
{
	ACZipCaseInsensitivePathLookup =		1,		// Ignore case on path lookup
	ACZipReadCompressedData =				4,		// Read compressed data
	ACZipUseOriginalDataIgnoringChanges = 	8,		// Use original data, ignoring changes
	ACZipForceRecompressionOfData =			16, 	// Force recompression of data
	ACZipWantEncryptedData =				32, 	// Read encrypted data (implies JXZipReadCompressedData)
	ACZipWantUnmodifiedString =				64, 	// Get unmodified string
	ACZipOverwrite =						8192	// When adding a file to a ZIP archive and a file with same path exists, replace it
};
typedef int ACZipOptions;

#define kACCouldNotOpenZip              1001
#define kACCouldNotSaveZip              1002
#define kACCouldNotOpenZippedFile       1003
#define kACCouldNotReadZippedFile       1004
#define kACInvalidZippedFileInfo        1005
#define kACCouldNotAddZippedFile        1006
#define kACCouldNotReplaceZippedFile    1007
#define kACCouldNotRenameZippedFile     1008


#endif
