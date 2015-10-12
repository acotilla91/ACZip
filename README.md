#ACZip
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)

ACZip is a lightweight Objective-C wrapper for some libzip functions. It's strongly based on https://github.com/JanX2/JXZip. This class allows you to enumerate all files inside a zip file, add new files, rename files, replace files and much more.

Last tested on Xcode 7.0.1 & iOS 9.0.2

##Installation and Setup

####Manual
1. Add ACZip folder to your project.
2. In the project editor, select your target, click Build Phases and then under Link Binary With Libraries add the libz library to your target.

##Usage
```objective-c
//
// Create zip file object
//

ACZip *zipFile = [ACZip zipWithPath:zipPath error:nil];

//
// Enumerate all files on zip, including folders
//

[zipFile enumerateZippedFilesInfoWithBlock:^(ACZippedFileInfo *zippedFileInfo, BOOL *stop) {
NSString *fileName = [zippedFileInfo.path lastPathComponent];
NSLog(@"File name : %@", fileName);
}];

//
// Add new file
//

NSString *newImgPath = [[NSBundle mainBundle] pathForResource:@"san_jose" ofType:@"jpg"];
NSData *newImgData = [NSData dataWithContentsOfFile:newImgPath];
NSString *newImgPathOnZip = @"/california/new_images/san_jose.jpg";
[zipFile addFileWithPath:newImgPathOnZip forData:newImgData error:nil];

//
// Rename file on zip
//

ACZippedFileInfo *fileInfo1 = [zipFile zippedFileInfoForFileWithName:@"los_angeles.jpg"]; // get file info by its name
NSString *fileNewName = [[fileInfo1.path stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"los_angeles_ca.jpg"];
[zipFile renameFile:fileInfo1 withNewName:fileNewName error:nil]; // the name takes into account the whole path

//
// Replace file on zip
//

ACZippedFileInfo *fileInfo2 = [zipFile zippedFileInfoForFileWithName:@"sacramento.jpg"]; // get file info by its name
NSString *newReplacementImgPath = [[NSBundle mainBundle] pathForResource:@"sacramento_new_img" ofType:@"jpg"];
NSData *newReplacementImgData = [NSData dataWithContentsOfFile:newReplacementImgPath];
[zipFile replaceFile:fileInfo2 withData:newReplacementImgData error:nil];

//
//  Save and close
//

[zipFile closeAndSave:nil];
```

###Licensing
This project is licensed under the terms of the MIT license.
