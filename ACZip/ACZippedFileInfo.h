//
//  ACZippedFileInfo.h
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

#import <Foundation/Foundation.h>
#import "libzip/zip.h"

@interface ACZippedFileInfo : NSObject
{
	struct zip_stat	_file_info;    
}

// FIXME: the properties currently are read only

- (NSString *)path;				// path of the file
- (NSUInteger)index;			// index within the archive
- (NSUInteger)size;				// size of the file (uncompressed)
- (NSUInteger)compressedSize;	// size of the file (compressed)
- (NSDate *)modificationDate;	// modification date

- (BOOL)hasCRC;
- (uint32_t)CRC;				// crc of file data

// To get more info about the values returned from the following two methods,
// check the libzip header file for now!
- (uint16_t)compressionMethod;	// compression method used
- (uint16_t)encryptionMethod;	// encryption method used

@end
