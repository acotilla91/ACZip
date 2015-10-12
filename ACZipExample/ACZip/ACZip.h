//
//  ACZip.h
//  ACZipApp
//
//  Created by Alejandro Cotilla on 7/15/13.
//  Copyright (c) 2013 Alejandro Cotilla. All rights reserved.
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



