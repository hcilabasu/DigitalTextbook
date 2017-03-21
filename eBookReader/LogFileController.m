//
//  LogFileController.m
//  eBookReader
//
//  Created by Shang Wang on 7/16/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import "LogFileController.h"

@interface LogFileController ()

@end
@implementation LogFileController
@synthesize logDataWrapper;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        logDataWrapper=[[LogDataWrapper alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*) readContent{
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/LogFile.txt",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    return content;
}


-(void) writeToTextFile: (NSString*) textString logTimeStampOrNot: (BOOL) isLogTime{
    
    NSArray* nsDateArray = [[[NSDate dateWithTimeIntervalSinceNow:0] description] componentsSeparatedByString:@" "];
    // date
    NSString* dateString = [nsDateArray objectAtIndex:0];
    NSArray*  adate = [dateString componentsSeparatedByString:@"-"];
    NSInteger ayear=[[adate objectAtIndex:0] integerValue];
    NSInteger amon=[[adate objectAtIndex:1] integerValue];
    NSInteger aday=[[adate objectAtIndex:2] integerValue];
    // time
    NSString* timeString = [nsDateArray objectAtIndex:1];
    NSArray*  timeArray = [timeString componentsSeparatedByString:@":"];
    NSInteger ahour=[[timeArray objectAtIndex:0] integerValue];
    ahour=ahour-7;
    if(ahour<0){
        ahour=ahour+24;
    }
    NSInteger amin=[[timeArray objectAtIndex:1] integerValue];
    NSInteger asec=[[timeArray objectAtIndex:2] integerValue];
    
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/LogFile.txt",
                          documentsDirectory];
    NSFileHandle *handler = [NSFileHandle fileHandleForUpdatingAtPath: fileName];
    //if the file doesn't exist, create a new file.
    if(!handler){
        NSString *newContent=@"Create File!\n\n";
        [newContent writeToFile:fileName
                     atomically:NO
                       encoding:NSStringEncodingConversionAllowLossy
                          error:nil];
        handler = [NSFileHandle fileHandleForUpdatingAtPath: fileName];
    }
    //if isLogTime is true, add the time stamp in front of the logString.
    if(isLogTime){
        NSString *timeString= [NSString stringWithFormat:@"Time Stamp: %d.%d.%d - %d:%d:%d     ",ayear, amon, aday,ahour,amin,asec];
        textString=[timeString stringByAppendingString:textString];
    }
    [handler seekToEndOfFile];//append to the end of the file
    [handler writeData: [textString dataUsingEncoding: NSUTF8StringEncoding]];
    [handler closeFile];
}


-(void)logHighlightActivity: (NSString*) colorString Text: (NSString*) highlightText PageNumber: (int) pageNum {
    NSString* logString=[NSString stringWithFormat:@" Page:%d   Highlight text \"",pageNum];
    logString= [logString stringByAppendingString:highlightText];
    logString= [logString stringByAppendingString:@"\" into "];
    logString= [logString stringByAppendingString:colorString];
    logString= [logString stringByAppendingString:@". \n\n"];
    [self writeToTextFile: logString logTimeStampOrNot: YES];
    
}


@end
