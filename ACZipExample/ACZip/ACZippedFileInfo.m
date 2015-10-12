//
//  ACZippedFileInfo.m
//  ACZipApp
//
//  Created by Alejandro Cotilla on 7/15/13.
//  Copyright (c) 2013 Alejandro Cotilla. All rights reserved.
//

#import "ACZippedFileInfo.h"
#import "ACZipDefs.h"

#import "ARCHelper.h"

#define ACZippedFileInfoErrorDomain @"com.spissa.Error.ACZippedFileInfo"

#define kACCouldNotAccessZippedFileInfo 1101

@implementation ACZippedFileInfo

- (ACZippedFileInfo *)initFileInfoWithArchive:(struct zip *)archive index:(NSUInteger)index filePath:(NSString *)filePath options:(ACZipOptions)options error:(NSError **)error;
{
    //TODO: assert if archive is nil
    
	self = [super init];
	
    if (archive == NULL)
    {
        [self release];
        return nil;
    }
    
    options = (options & ZIP_FL_ENC_UTF_8);
    
    int idx; // FIXME: libzip shouldn’t use int, it should use zip_int64_t
    const char *file_path = NULL;
    
    if (filePath != nil)
    {
        file_path = [filePath UTF8String]; // autoreleased
        idx = (int)zip_name_locate(archive, file_path, options);
    }
    else
    {
        idx = (int)index;
    }
    
    if ((idx < 0) || (zip_stat_index(archive, (zip_uint64_t)idx, options, &_file_info) < 0))
    {
        if (error != NULL)
        {
            NSString *errorDescription = nil;
            if (filePath != nil)
            {
                errorDescription = [NSString stringWithFormat:NSLocalizedString(@"Could not access file info for “%@” in zipped file: %s", @"Cannot access file info in zipped file"),
                                    filePath, zip_strerror(archive)];
            }
            else
            {
                errorDescription = [NSString stringWithFormat:NSLocalizedString(@"Could not access file info for file %lu in zipped file: %s", @"Cannot access file info in zipped file"),
                                    (unsigned long)index, zip_strerror(archive)];
            }
            NSDictionary *errorDetail = [NSDictionary dictionaryWithObjectsAndKeys:
                                         errorDescription, NSLocalizedDescriptionKey,
                                         nil];
            *error = [NSError errorWithDomain:ACZippedFileInfoErrorDomain code:kACCouldNotAccessZippedFileInfo userInfo:errorDetail];
        }
        
        [self release];
        return nil;
    }
	
	return self;
}

- (ACZippedFileInfo *)initFileInfoWithArchive:(struct zip *)archive filePath:(NSString *)filePath options:(ACZipOptions)options error:(NSError **)error;
{
	if (filePath == nil)
    {
        return nil;
    }
	else
    {
        return [self initFileInfoWithArchive:archive index:0 filePath:filePath options:options error:error];
    }
}

+ (ACZippedFileInfo *)zippedFileInfoWithArchive:(struct zip *)archive filePath:(NSString *)filePath options:(ACZipOptions)options error:(NSError **)error;
{
	return [[[ACZippedFileInfo alloc] initFileInfoWithArchive:archive index:0 filePath:filePath options:options error:error] autorelease];
}

- (ACZippedFileInfo *)initFileInfoWithArchive:(struct zip *)archive index:(NSUInteger)index options:(ACZipOptions)options error:(NSError **)error;
{
	return [self initFileInfoWithArchive:archive index:index filePath:nil options:options error:error];
}

+ (ACZippedFileInfo *)zippedFileInfoWithArchive:(struct zip *)archive index:(NSUInteger)index options:(ACZipOptions)options error:(NSError **)error;
{
	return [[[ACZippedFileInfo alloc] initFileInfoWithArchive:archive index:index filePath:nil options:options error:error] autorelease];
}

- (void)dealloc
{
	// We don’t need to free anything here:
	// the only non-scalar value, the name string, must not be freed (or modified), and becomes invalid when the archive itself is closed.
	
	[super ah_dealloc];
}


- (NSString *)path;
{
	if (_file_info.valid & ZIP_STAT_NAME)
    {
		// FIXME: We assume the file names are UTF-8.
		return [NSString stringWithCString:_file_info.name encoding:NSUTF8StringEncoding];
	}
	else
    {
		return nil;
	}
}

- (NSUInteger)index;
{
	if (_file_info.valid & ZIP_STAT_INDEX)  return (NSUInteger)_file_info.index;
	else  return NSNotFound;
}

- (NSUInteger)size;
{
	if (_file_info.valid & ZIP_STAT_SIZE)  return (NSUInteger)_file_info.size;
	else  return NSNotFound;
}

- (NSUInteger)compressedSize;
{
	if (_file_info.valid & ZIP_STAT_COMP_SIZE)  return (NSUInteger)_file_info.comp_size;
	else  return NSNotFound;
}

- (NSDate *)modificationDate;
{
	if (_file_info.valid & ZIP_STAT_MTIME)
    {
		return [NSDate dateWithTimeIntervalSince1970:_file_info.mtime];
	}
	else
    {
		return nil;
	}
}


- (BOOL)hasCRC;
{
	if (_file_info.valid & ZIP_STAT_CRC)  return YES;
	else  return NO;
}

- (uint32_t)CRC;
{
	return (uint32_t)_file_info.crc;
}


- (uint16_t)compressionMethod;
{
	if (_file_info.comp_method & ZIP_STAT_COMP_METHOD)  return (uint16_t)_file_info.crc;
	else  return ZIP_EM_UNKNOWN;
}

- (uint16_t)encryptionMethod;
{
	if (_file_info.encryption_method & ZIP_STAT_ENCRYPTION_METHOD)  return (uint16_t)_file_info.crc;
	else  return 0xffff; // Unknown
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"path : %@\nindex : %d\nsize : %d\ncompressed size : %d\nmodification date : %@\nhasCRC : %d", [self path], [self index], [self size], [self compressedSize], [self modificationDate], [self hasCRC]];
}

@end
