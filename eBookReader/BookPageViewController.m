//
//  BookPageViewController.m
//  eBookReader
//
//  Created by Shang Wang on 6/19/14.
//  Copyright (c) 2014 Andreea Danielescu. All rights reserved.
//

#import "BookPageViewController.h"
#import "LogFileController.h"
#import <DropboxSDK/DropboxSDK.h>
@interface BookPageViewController ()

@end

@implementation BookPageViewController
@synthesize bookView;
@synthesize cmapView;
@synthesize restClient;
@synthesize logWrapper;
@synthesize QA;
@synthesize bulbImageView;
@synthesize ShowingQA;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
        logWrapper= [LogDataParser loadLogData];
        ShowingQA=true;
    }
    return self;
}

-(void)test{
    NSLog(@"Test");
}


-(void)addSwitchView{
    
    bulbImageView = [[UIImageView alloc]initWithFrame:CGRectMake(498, 350, 30, 30)];
    [bulbImageView setImage:[UIImage imageNamed:@"switch.png"]];
    //bulbImageView.alpha=0.8;
    bulbImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *bulbTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnBulb:)];
    
    [self.bulbImageView addGestureRecognizer:bulbTap];
    
    [self.view addSubview:bulbImageView];
    [bulbImageView setHidden:YES];
    bulbImageView.layer.shadowOpacity = 0.4;
    bulbImageView.layer.shadowRadius = 4;
    bulbImageView.layer.shadowColor = [UIColor blackColor].CGColor;
   bulbImageView.layer.shadowOffset = CGSizeMake(2, 2);

}

- (IBAction)clickOnBulb : (id)sender
{
    if(ShowingQA){
        [self.view bringSubviewToFront:cmapView.view];
        [cmapView loadConceptMap:nil];
        
        ShowingQA=false;
    }else{
        [self.view bringSubviewToFront:QA.view];
        ShowingQA=true;
    }
    [self.view bringSubviewToFront:bulbImageView];
    
}


- (IBAction)QAonConcpet
{
    if(ShowingQA){
        [self.view bringSubviewToFront:cmapView.view];
        [cmapView loadConceptMap:nil];
        
        ShowingQA=false;
    }else{
        [self.view bringSubviewToFront:QA.view];
        ShowingQA=true;
    }
    [self.view bringSubviewToFront:bulbImageView];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createCmapView];
    [self createQA];
    [self addSwitchView];
    bookView.parent_BookPageViewController=self;
    bookView.logWrapper=logWrapper;
    
    if( ([[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationLandscapeLeft)||([[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationLandscapeRight)){
        [self splitScreen];
    }
    
  
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)createCmapView{
    cmapView=[[CmapController alloc] initWithNibName:@"CmapView" bundle:nil];
    cmapView.bookLogDataWrapper=logWrapper;
    cmapView.showType=1;
    cmapView.parentBookPageViewController=self;
    cmapView.neighbor_BookViewController=self.bookView;
    [self addChildViewController:cmapView];
    [self.view addSubview:cmapView.view];
    [cmapView.view setUserInteractionEnabled:YES];
    cmapView.view.center=CGPointMake(768, 384);
    [cmapView.view setHidden:YES];
}

-(void)createQA{
    QA=[[QAViewController alloc] initWithNibName:@"QAViewController" bundle:nil];
    [self addChildViewController:QA];
    [self.view addSubview:QA.view];
    [QA.view setUserInteractionEnabled:YES];
    QA.view.center=CGPointMake(768, 384);
    [QA.view setHidden:YES];
}



-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //when retating the device, clear the thumbnail icons and reload
    if(fromInterfaceOrientation==UIInterfaceOrientationPortrait||fromInterfaceOrientation==UIInterfaceOrientationPortraitUpsideDown){
        [self splitScreen];
    }
    //otherwise, hide the concept map view.
    if(fromInterfaceOrientation==UIInterfaceOrientationLandscapeLeft||fromInterfaceOrientation==UIInterfaceOrientationLandscapeRight){
        [self resumeNormalScreen ];
    }
}



-(void)splitScreen{
    CGRect rec=CGRectMake(0, 0, 512, 768);
    [bookView.view setFrame:rec];
    [cmapView.view setHidden:NO];
    [QA.view setHidden:NO];
    [bulbImageView setHidden:NO];
    LogFileController *logFile=[[LogFileController alloc]init];
    [logFile writeToTextFile:@"Show concept map view.\n" logTimeStampOrNot:YES];
    [self.view bringSubviewToFront:bulbImageView];
}


-(void)resumeNormalScreen{
    CGRect rec=CGRectMake(0, 0, 768, 1024);
    [bookView.view setFrame:rec];
     [cmapView.view setHidden:YES];
    [QA.view setHidden:YES];
     [bulbImageView setHidden:YES];
    LogFileController *logFile=[[LogFileController alloc]init];
    [logFile writeToTextFile:@"Show book view.\n" logTimeStampOrNot:YES];
}


-(void)searchAndHighlight{
    
}


-(void)upLoadLogFile{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/LogData.xml",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    
    NSString *text = content;
    NSString *filename = @"LogData.xml";
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath = [localDir stringByAppendingPathComponent:filename];
    [text writeToFile:localPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    // Upload file to Dropbox
    NSString *destDir = @"/";
    [self.restClient uploadFile:filename toPath:destDir withParentRev:nil fromPath:localPath];
}


-(void)uploadCmapLink{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/ExpertCmapLinkList.xml",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    
    NSString *text = content;
    NSString *filename = @"ExpertCmapLinkList.xml";
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath = [localDir stringByAppendingPathComponent:filename];
    [text writeToFile:localPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    // Upload file to Dropbox
    NSString *destDir = @"/";
    [self.restClient uploadFile:filename toPath:destDir withParentRev:nil fromPath:localPath];

}

-(void)uploadCmapNode{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/ExpertCmapNodeList.xml",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    
    NSString *text = content;
    NSString *filename = @"ExpertCmapNodeList.xml";
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath = [localDir stringByAppendingPathComponent:filename];
    [text writeToFile:localPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    // Upload file to Dropbox
    NSString *destDir = @"/";
    [self.restClient uploadFile:filename toPath:destDir withParentRev:nil fromPath:localPath];

    
}

-(void)upLoadCmap{
    
    [self uploadCmapNode];
    [self uploadCmapLink];
}


- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    NSLog(@"File upload failed with error: %@", error);
}

@end
