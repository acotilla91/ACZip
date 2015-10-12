//
//  ACZip.h
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
#import "ACZipDefs.h"

@class ACZippedFileInfo;

typedef void(^ACZippedFilesInfoIterBlock)(ACZippedFileInfo *zippedFileInfo, BOOL *stop);

@interface ACZip : NSObject

@property (nonatomic, readonly, retain) NSString *zipFilePath;

+ (ACZip *)zipWithPath:(NSString *)pZipfilePath error:(NSError **)error;
+ (ACZip *)zipWithPath:(NSString *)pZipfilePath options:(ACZipOptions)options error:(NSError **)error;

- (ACZip *)initWithPath:(NSString *)pZipfilePath error:(NSError **)error;
- (ACZip *)initWithPath:(NSString *)pZipfilePath options:(ACZipOptions)options error:(NSError **)error;

- (NSUInteger)fileCount;
- (void)enumerateZippedFilesInfoWithBlock:(ACZippedFilesInfoIterBlock)block;

- (ACZippedFileInfo *)zippedFileInfoForIndex:(NSUInteger)index error:(NSError **)error;
- (ACZippedFileInfo *)zippedFileInfoForIndex:(NSUInteger)index options:(ACZipOptions)options error:(NSError **)error;
- (ACZippedFileInfo *)zippedFileInfoForFilePath:(NSString *)filePath error:(NSError **)error;
- (ACZippedFileInfo *)zippedFileInfoForFilePath:(NSString *)filePath options:(ACZipOptions)options error:(NSError **)error;
- (ACZippedFileInfo *)zippedFileInfoForFileWithName:(NSString *)fileName;
- (ACZippedFileInfo *)zippedFileInfoForFileWithName:(NSString *)fileName onPathLevel:(NSUInteger)level;

- (NSData *)dataForFileAtIndex:(NSUInteger)index error:(NSError **)error;
- (NSData *)dataForFileAtIndex:(NSUInteger)index options:(ACZipOptions)options error:(NSError **)error;
- (NSData *)dataForFilePath:(NSString *)filePath error:(NSError **)error;
- (NSData *)dataForFilePath:(NSString *)filePath options:(ACZipOptions)options error:(NSError **)error;
- (NSData *)dataForZippedFileInfo:(ACZippedFileInfo *)zippedFileInfo error:(NSError **)error;
- (NSData *)dataForZippedFileInfo:(ACZippedFileInfo *)zippedFileInfo options:(ACZipOptions)options error:(NSError **)error;

- (BOOL)addFileWithPath:(NSString *)filePath forData:(NSData *)data error:(NSError **)error;

- (BOOL)replaceFile:(ACZippedFileInfo *)zippedFileInfo withData:(NSData *)data error:(NSError **)error;
- (BOOL)renameFile:(ACZippedFileInfo  *)zippedFileInfo withNewName:(NSString *)newName error:(NSError **)error;
// TODO: deleteFile

- (BOOL)closeAndSave:(NSError **)error;

@end



