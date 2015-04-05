//
//  ThumbNailController.m
//  eBookReader
//
//  Created by Shang Wang on 7/11/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import "ThumbNailController.h"

@interface ThumbNailController ()

@end

@implementation ThumbNailController

@synthesize showPoint;
@synthesize totalIconNum;
@synthesize iconArray;
@synthesize screenSize;
@synthesize topSpace;
@synthesize bottomSpace;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        iconArray= [[NSMutableArray alloc] init];
        topSpace=25;
        bottomSpace=79;
        screenSize=[self screenSize];
        totalIconNum=(screenSize.height-topSpace-bottomSpace)/30*2;
       // NSLog(@"Total Num: %d",totalIconNum);
        for(int i=0; i<totalIconNum;i++){
            [iconArray addObject: @"Empty"];
        }
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

-(int) getIconPos: (CGPoint) m_showPoint type:(int)thumbtype{
     int thumbHeight;
    if(1==thumbtype){
        thumbHeight=45;
    }else{
        thumbHeight=35;
    }
   
    int tempPos= (m_showPoint.y-25)/thumbHeight;
   // NSLog(@"Tem Pos: %d\n",tempPos);
    int pos=0;
    for(int i=tempPos; i<[iconArray count];i++){
        NSString *tempString=[iconArray objectAtIndex:i];
        if([tempString isEqualToString: @"Empty"]){
            pos=i*thumbHeight+25;
            [iconArray replaceObjectAtIndex:i withObject:@"Full"];
            break;
        }
    }
    if(pos==0){
        NSLog(@"Icon array is full!\n");
    }
    return pos;
}



-(void)clearAllThumbnail{
    for(int i=0; i<[iconArray count];i++){
        [iconArray replaceObjectAtIndex:i withObject:@"Empty"];
    }
}

//get the screen sie
- (CGSize) screenSize
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        size = CGSizeMake(size.height, size.width);
    }
    if (application.statusBarHidden == NO)
    {
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    }
    return size;
}

@end
