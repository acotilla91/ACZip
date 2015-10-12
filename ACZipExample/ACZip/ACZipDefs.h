//
//  ACZipDefs.h
//  ACZipApp
//
//  Created by Alejandro Cotilla on 7/15/13.
//  Copyright (c) 2013 Alejandro Cotilla. All rights reserved.
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
