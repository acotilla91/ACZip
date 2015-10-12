//
//  ACZippedFileInfo.h
//  ACZipApp
//
//  Created by Alejandro Cotilla on 7/15/13.
//  Copyright (c) 2013 Alejandro Cotilla. All rights reserved.
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
