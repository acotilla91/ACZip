//
//  ViewController.m
//  ACZipExample
//
//  Created by Alejandro David Cotilla Rojas on 10/9/15.
//  Copyright © 2015 Alejandro David Cotilla Rojas. All rights reserved.
//

#import "ViewController.h"

#import "ACZip.h"
#import "ACZippedFileInfo.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *noticeLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [noticeLb setTextAlignment:NSTextAlignmentCenter];
    [noticeLb setText:@"Tap on the screen to run all tests"];
    [noticeLb setFont:[UIFont systemFontOfSize:18]];
    [noticeLb setTag:666];
    [self.view addSubview:noticeLb];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewTapped:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}


/* Called when view it's tapped. Now we run all tests together. */
- (void)onViewTapped:(UITapGestureRecognizer *)tapGestureRecognizer
{
    //
    // Copy zip file to documents
    //
    
    NSString *zipPath = [[NSBundle mainBundle] pathForResource:@"california" ofType:@"zip"];
    NSString *zipNewPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/california.zip"];
    NSData *originalZipFileData = [NSData dataWithContentsOfFile:zipPath];
    [originalZipFileData writeToFile:zipNewPath atomically:YES];
    zipPath = zipNewPath;
    
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
    
    //
    // All tests have been executed so now we notify user and cancel future interactions
    //
    
    [tapGestureRecognizer setEnabled:NO];
    [(UILabel *)[self.view viewWithTag:666] setText:@"All tests have been executed !"];
}

@end
