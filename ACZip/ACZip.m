//
//  ACZip.m
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

#import "ACZip.h"
#import "ARCHelper.h"
#import "libzip/zip.h"

#import "ACZippedFileInfo.h"

#define ACZipErrorDomain @"com.spissa.Error.ACZip"

@interface ACZippedFileInfo (Protected)
+ (ACZippedFileInfo *)zippedFileInfoWithArchive:(struct zip *)archive filePath:(NSString *)filePath options:(ACZipOptions)options error:(NSError **)error;
- (ACZippedFileInfo *)initFileInfoWithArchive:(struct zip *)archive filePath:(NSString *)filePath options:(ACZipOptions)options error:(NSError **)error;
+ (ACZippedFileInfo *)zippedFileInfoWithArchive:(struct zip *)archive index:(NSUInteger)index options:(ACZipOptions)options error:(NSError **)error;
- (ACZippedFileInfo *)initFileInfoWithArchive:(struct zip *)archive index:(NSUInteger)index options:(ACZipOptions)options error:(NSError **)error;
@end

@interface ACZip ()
@property (nonatomic, readwrite, retain) NSString *zipFilePath;
@property (nonatomic, readwrite, assign) struct zip *za;
@end

@implementation ACZip
{
    NSString *_zipFilePath;
	struct zip *_za;
}

@synthesize zipFilePath = _zipFilePath;
@synthesize za = _za;

+ (ACZip *)zipWithPath:(NSString*)pZipFilePath error:(NSError **)error
{
	return [[[ACZip alloc] initWithPath:pZipFilePath options:0 error:error] autorelease];
}

+ (ACZip *)zipWithPath:(NSString *)pZipFilePath options:(ACZipOptions)options error:(NSError **)error
{
	return [[[ACZip alloc] initWithPath:pZipFilePath options:options error:error] autorelease];
}

- (ACZip *)initWithPath:(NSString *)pZipFilePath error:(NSError **)error
{
	return [self initWithPath:pZipFilePath options:0 error:error];
}

- (ACZip *)initWithPath:(NSString *)pZipFilePath options:(ACZipOptions)options error:(NSError **)error
{
	self = [super init];

    if (pZipFilePath == nil)
    {
        [self release];
        return nil;
    }
    
    self.zipFilePath = pZipFilePath;
    
    // NOTE: We could rewrite this using file descriptors.
    const char *zip_file_path = [pZipFilePath UTF8String];
    int err;
    
    _za = zip_open(zip_file_path, (options & ZIP_FL_ENC_UTF_8), &err);
    
    if (_za == NULL)
    {
        if (error != NULL)
        {
            char errstr[1024];
            zip_error_to_str(errstr, sizeof(errstr), err, errno);
            NSString *errorDescription = [NSString stringWithFormat:NSLocalizedString(@"The zip archive “%@” could not be opened: %s", @"Cannot open zip archive"), pZipFilePath, errstr];
            NSDictionary *errorDetail = [NSDictionary dictionaryWithObjectsAndKeys: errorDescription, NSLocalizedDescriptionKey, nil];
            *error = [NSError errorWithDomain:ACZipErrorDomain code:kACCouldNotOpenZip userInfo:errorDetail];
        }
        
        [self release];
        return nil;
    }
	
	return self;
}

- (void)dealloc
{
	self.zipFilePath = nil;
	
	if (_za != NULL)
    {
		zip_unchange_all(_za);
		zip_close(_za);
		_za = NULL;
	}
    
	[super ah_dealloc];
}

- (NSUInteger)fileCount
{
	if (_za == NULL)  return NSNotFound;
	
	// The underlying library uses an int to store the count so this is safe in any case.
	return (NSUInteger)zip_get_num_entries(_za, ZIP_FL_UNCHANGED);
}

- (void)enumerateZippedFilesInfoWithBlock:(ACZippedFilesInfoIterBlock)block
{
    NSUInteger filesCount = [self fileCount];
    
    for (int i = 0; i < filesCount; i++)
    {
        NSError *infoGettingError = nil;
        ACZippedFileInfo *zippedFileInfo = [self zippedFileInfoForIndex:i error:&infoGettingError];
        if (infoGettingError)
        {
            NSLog(@"%s ERROR : %@", __FUNCTION__, infoGettingError);
            return;
        }
        
        //Making the block call
        BOOL stop = NO;
        block(zippedFileInfo, &stop);
        
        if (stop)
        {
            return;
        }
    }
}

- (ACZippedFileInfo *)zippedFileInfoForIndex:(NSUInteger)index error:(NSError **)error
{
	return [ACZippedFileInfo zippedFileInfoWithArchive:_za index:index options:0 error:error];
}

- (ACZippedFileInfo *)zippedFileInfoForIndex:(NSUInteger)index options:(ACZipOptions)options error:(NSError **)error
{
	return [ACZippedFileInfo zippedFileInfoWithArchive:_za index:index options:options error:error];
}

- (ACZippedFileInfo *)zippedFileInfoForFilePath:(NSString *)filePath error:(NSError **)error
{
	return [ACZippedFileInfo zippedFileInfoWithArchive:_za filePath:filePath options:0 error:error];
}

- (ACZippedFileInfo *)zippedFileInfoForFilePath:(NSString *)filePath options:(ACZipOptions)options error:(NSError **)error
{
	return [ACZippedFileInfo zippedFileInfoWithArchive:_za filePath:filePath options:options error:error];
}

- (NSData *)dataForFileAtIndex:(NSUInteger)index error:(NSError **)error
{
	return [self dataForFileAtIndex:index options:0 error:error];
}

- (NSData *)dataForFileAtIndex:(NSUInteger)index options:(ACZipOptions)options error:(NSError **)error
{
	ACZippedFileInfo *zippedFileInfo = [self zippedFileInfoForIndex:index error:error];
	if (zippedFileInfo == nil)  return nil;
	else  return [self dataForZippedFileInfo:zippedFileInfo options:0 error:error];
}

- (NSData *)dataForFilePath:(NSString *)filePath error:(NSError**)error
{
	return [self dataForFilePath:filePath options:0 error:error];
}

- (NSData *)dataForFilePath:(NSString *)filePath options:(ACZipOptions)options error:(NSError **)error
{
	ACZippedFileInfo *zippedFileInfo = [self zippedFileInfoForFilePath:filePath error:error];
	if (zippedFileInfo == nil)  return nil;
	else  return [self dataForZippedFileInfo:zippedFileInfo options:0 error:error];
}

- (NSData *)dataForZippedFileInfo:(ACZippedFileInfo *)zippedFileInfo error:(NSError**)error
{
	return [self dataForZippedFileInfo:zippedFileInfo options:0 error:error];
}

- (NSData *)dataForZippedFileInfo:(ACZippedFileInfo *)zippedFileInfo options:(ACZipOptions)options error:(NSError**)error
{
	if (zippedFileInfo == nil)  return nil;
    
	zip_uint64_t zipped_file_index = zippedFileInfo.index;
	zip_uint64_t zipped_file_size = zippedFileInfo.size;
	
	if ((zipped_file_index == NSNotFound) || (zipped_file_size == NSNotFound))
    {
		if (error != NULL)
        {
			NSString *errorDescription = [NSString stringWithFormat:NSLocalizedString(@"Invalid zipped file info.", @"Invalid zipped file info")];
			NSDictionary *errorDetail = [NSDictionary dictionaryWithObjectsAndKeys: errorDescription, NSLocalizedDescriptionKey, nil];
			*error = [NSError errorWithDomain:ACZipErrorDomain code:kACInvalidZippedFileInfo userInfo:errorDetail];
		}
		
		return nil;
	}
    
	struct zip_file *zipped_file = zip_fopen_index(_za, zipped_file_index, (options & ZIP_FL_ENC_UTF_8));
	if (zipped_file == NULL)
    {
		if (error != NULL)
        {
			NSString *errorDescription = [NSString stringWithFormat:NSLocalizedString(@"Could not open zipped file “%@” in archive “%@”: %s", @"Could not open zipped file"), zippedFileInfo.path, self.zipFilePath, zip_strerror(_za)];
			NSDictionary *errorDetail = [NSDictionary dictionaryWithObjectsAndKeys: errorDescription, NSLocalizedDescriptionKey, nil];
			*error = [NSError errorWithDomain:ACZipErrorDomain code:kACCouldNotOpenZippedFile userInfo:errorDetail];
		}
		
		return nil;
	}

	char *buf = malloc((size_t)zipped_file_size); // freed by NSData
	
	zip_int64_t n = zip_fread(zipped_file, buf, zipped_file_size);
	if (n < (zip_int64_t)zipped_file_size)
    {
		if (error != NULL)
        {
			NSString *errorDescription = [NSString stringWithFormat:NSLocalizedString(@"Error while reading zipped file “%@” in archive “%@”: %s", @"Error while reading zipped file"), zippedFileInfo.path, self.zipFilePath, zip_file_strerror(zipped_file)];
			NSDictionary *errorDetail = [NSDictionary dictionaryWithObjectsAndKeys: errorDescription, NSLocalizedDescriptionKey, nil];
			*error = [NSError errorWithDomain:ACZipErrorDomain code:kACCouldNotReadZippedFile userInfo:errorDetail];
		}
		
		zip_fclose(zipped_file);
		
		free(buf);
		
		return nil;
	}
	
	zip_fclose(zipped_file);
	
	return [NSData dataWithBytesNoCopy:buf length:(NSUInteger)zipped_file_size freeWhenDone:YES];
}


- (BOOL)addFileWithPath:(NSString *)filePath forData:(NSData *)data error:(NSError **)error
{
	if ((filePath == nil) || (data == nil))  return NO;
	
	// CHANGEME: Passing the index back might be helpful
	
	const char * file_path = [filePath UTF8String];
	struct zip_source *file_zip_source = zip_source_buffer(_za, [data bytes], [data length], 0);
	zip_int64_t index;
	
	if ((file_zip_source == NULL) || ((index = zip_file_add(_za, file_path, file_zip_source, (ZIP_FL_ENC_UTF_8))) < 0))
    {
		if (error != NULL)
        {
			NSString *errorDescription = [NSString stringWithFormat:NSLocalizedString(@"Error while adding zipped file “%@” in archive “%@”: %s", @"Error while adding zipped file"), filePath, self.zipFilePath, zip_strerror(_za)];
			NSDictionary *errorDetail = [NSDictionary dictionaryWithObjectsAndKeys: errorDescription, NSLocalizedDescriptionKey, nil];
			*error = [NSError errorWithDomain:ACZipErrorDomain code:kACCouldNotAddZippedFile userInfo:errorDetail];
		}
		
		if (file_zip_source != NULL)  zip_source_free(file_zip_source);
		
		return NO;
	}
	
	return YES;
}

- (BOOL)replaceFile:(ACZippedFileInfo *)zippedFileInfo withData:(NSData *)data error:(NSError **)error
{
	if ((zippedFileInfo == nil) || (data == nil))  return NO;
	
	struct zip_source *file_zip_source = zip_source_buffer(_za, [data bytes], [data length], 0);
	
	if ((file_zip_source == NULL) || (zip_file_replace(_za, zippedFileInfo.index, file_zip_source, 0) < 0))
    {
		if (error != NULL)
        {
			NSString *errorDescription = [NSString stringWithFormat:NSLocalizedString(@"Error while replacing zipped file “%@” in archive “%@”: %s", @"Error while replacing zipped file"), zippedFileInfo.path, self.zipFilePath, zip_strerror(_za)];
			NSDictionary *errorDetail = [NSDictionary dictionaryWithObjectsAndKeys: errorDescription, NSLocalizedDescriptionKey, nil];
			*error = [NSError errorWithDomain:ACZipErrorDomain code:kACCouldNotReplaceZippedFile userInfo:errorDetail];
		}
		
		if (file_zip_source != NULL)  zip_source_free(file_zip_source);
		
		return NO;
	}
	
	// We don’t need to zip_source_free() here, as libzip has taken care of it once we have reached this line.
	
	return YES;
}

- (BOOL)renameFile:(ACZippedFileInfo *)zippedFileInfo withNewName:(NSString *)newName error:(NSError **)error
{
	if ((zippedFileInfo == nil) || (newName == nil) || (newName.length == 0))
    {
        if (error != NULL)
        {
			NSString *errorDescription = [NSString stringWithFormat:NSLocalizedString(@"Error while renaming zipped file “%@” in archive “%@”: %s", @"Error while renaming zipped file. (zippedFileInfo == nil) || (newName == nil) || (newName.length == 0)"), zippedFileInfo.path, self.zipFilePath, zip_strerror(_za)];
			NSDictionary *errorDetail = [NSDictionary dictionaryWithObjectsAndKeys: errorDescription, NSLocalizedDescriptionKey, nil];
			*error = [NSError errorWithDomain:ACZipErrorDomain code:kACCouldNotRenameZippedFile userInfo:errorDetail];
		}
        
        return NO;
    }
    
    if ([newName hasSuffix:@"/"])
    {
        if (error != NULL)
        {
			NSString *errorDescription = [NSString stringWithFormat:NSLocalizedString(@"Error while renaming zipped file “%@” in archive “%@”: %s", @"Error while renaming zipped file. Can't rename folder -> (ToDo)."), zippedFileInfo.path, self.zipFilePath, zip_strerror(_za)];
			NSDictionary *errorDetail = [NSDictionary dictionaryWithObjectsAndKeys: errorDescription, NSLocalizedDescriptionKey, nil];
			*error = [NSError errorWithDomain:ACZipErrorDomain code:kACCouldNotRenameZippedFile userInfo:errorDetail];
		}
        
        return NO;
    }
		
    const char *newNameChars = [newName UTF8String];
    
	if ((newNameChars == NULL) || (zip_file_rename(_za, zippedFileInfo.index, newNameChars, 0) < 0))
    {
		if (error != NULL)
        {
			NSString *errorDescription = [NSString stringWithFormat:NSLocalizedString(@"Error while renaming zipped file “%@” in archive “%@”: %s", @"Error while renaming zipped file"), zippedFileInfo.path, self.zipFilePath, zip_strerror(_za)];
			NSDictionary *errorDetail = [NSDictionary dictionaryWithObjectsAndKeys: errorDescription, NSLocalizedDescriptionKey, nil];
			*error = [NSError errorWithDomain:ACZipErrorDomain code:kACCouldNotRenameZippedFile userInfo:errorDetail];
		}
				
		return NO;
	}
		
	return YES;
}

- (BOOL)closeAndSave:(NSError **)error
{
	if (_za == NULL)  return NO;
	
	if (zip_close(_za) < 0)
    {
		if (error != NULL)
        {
			NSString *errorDescription = [NSString stringWithFormat:NSLocalizedString(@"The zip archive “%@” could not be saved: %s", @"Cannot save zip archive"), self.zipFilePath, zip_strerror(_za)];
			NSDictionary *errorDetail = [NSDictionary dictionaryWithObjectsAndKeys: errorDescription, NSLocalizedDescriptionKey,  nil];
			*error = [NSError errorWithDomain:ACZipErrorDomain code:kACCouldNotSaveZip userInfo:errorDetail];
		}
        
		return NO;
	}
	else
    {
		_za = NULL;
		return YES;
	}
}

- (ACZippedFileInfo *)zippedFileInfoForFileWithName:(NSString *)fileName
{
    __block ACZippedFileInfo *foundedInfo = nil;
    
    [self enumerateZippedFilesInfoWithBlock:^(ACZippedFileInfo *zippedFileInfo, BOOL *stop)
    {
        if ([[zippedFileInfo.path lastPathComponent] isEqualToString:fileName])
        {
            foundedInfo = zippedFileInfo;
            *stop = YES;
        }
    }];
    
    return foundedInfo;    
}

- (ACZippedFileInfo *)zippedFileInfoForFileWithName:(NSString *)fileName onPathLevel:(NSUInteger)level
{
    __block ACZippedFileInfo *foundedInfo = nil;
    
    [self enumerateZippedFilesInfoWithBlock:^(ACZippedFileInfo *zippedFileInfo, BOOL *stop)
     {
         if ([[zippedFileInfo.path lastPathComponent] isEqualToString:fileName] && [[zippedFileInfo.path pathComponents] count] == level)
         {
             foundedInfo = zippedFileInfo;
             *stop = YES;
         }
     }];
    
    return foundedInfo;
}

@end
