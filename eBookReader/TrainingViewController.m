//
//  TrainingViewController.m
//  TurkStudy
//
//  Created by Shang Wang on 3/14/16.
//  Copyright © 2016 Shang Wang. All rights reserved.
//

#import "TrainingViewController.h"
#import "BookPageViewController.h"
@interface TrainingViewController ()

@end

@implementation TrainingViewController
@synthesize cmapView;
@synthesize mywebView;
@synthesize webFocusQuestionLable;
@synthesize cmapFocusQuestionLable;
@synthesize hintImg;
@synthesize bookImporter;
@synthesize bookTitle;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createCmapView];
    [self setingUpMenuItem];
     mywebView =[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 512, 768)];
    // webView.delegate=self;
     [self.view addSubview:mywebView];
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sample" ofType:@"html" inDirectory:@"WebTutorial"]];
    
    [mywebView loadRequest:[NSURLRequest requestWithURL:url]];
   
   // [webView becomeFirstResponder];
    
    
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpressAction:)];
    longpress.delegate=self;
    [mywebView addGestureRecognizer:longpress];
    [mywebView becomeFirstResponder];
    //[cmapView.focusQuestionLable setHidden:NO];
    [self showWebhint];
    mywebView.scrollView.scrollEnabled = NO;
    mywebView.scrollView.bounces = NO;
    [self showAlertWithString:@"Try to add a concept node from the book"];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    
    BookPageViewController*  bookPage=[[BookPageViewController alloc] initWithNibName:@"BookPageViewController" bundle:nil];
    bookPage.isTraining=YES;
   // bookPage.userName=userName;
    [self.navigationController pushViewController:bookPage animated:YES];
    
    bookPage.bookView = [[BookViewController alloc]init];
    //bookPage.bookView.userName=userName;
    
    bookPage.bookView.parent_BookPageViewController=bookPage;
    bookPage.bookView.bookImporter = bookImporter;
    bookPage.bookView.bookTitle = bookTitle;
    //bookPage.bookView.parent_LibraryViewController=self;
    // bookPage.bookView.parent_BookPageViewController=bookPage;
    [ bookPage.bookView createContentPages]; //create page content
    [ bookPage.bookView initialPageView];    //initial page view
    //CGRect rect=CGRectMake(0, 0, bookPage.view.frame.size.height, bookPage.view.frame.size.width);
    //[destination.view setFrame:rect];
    [bookPage.view addSubview: bookPage.bookView.view];
    [bookPage addChildViewController: bookPage.bookView];
    [bookPage showWebhint];

}



-(void)webViewDidFinishLoad:(UIWebView *)m_webView{
    [mywebView becomeFirstResponder];

}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

//give permission to show the menu item we added
- (BOOL) canPerformAction:(SEL)action withSender:(id)sender
{
    if (  action == @selector(markHighlightedString:)
        ||action == @selector(dragAndDrop:))
    {
        return YES;
    }
    
    if (action == @selector(copy:))
    {
        return NO;
    }
    if (action == @selector(define:))
    {
        return NO;
    }
    return NO;
}

- (void)dragAndDrop:(id)sender{
      [mywebView becomeFirstResponder];
    
    
    NSString* h_text=[mywebView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    if(h_text.length>25){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You can not add concepts that have more than 25 charaters!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [cmapView createNodeFromBook:CGPointMake( arc4random() % 400+30, 690) withName:h_text BookPos:CGPointMake(0, 0) page:1];

    [self showLinkingHint];
    
   NodeCell* cell= [cmapView createNodeFromBookForLink:CGPointMake( 250, 300) withName:@"link me" BookPos:CGPointMake(0, 0) page:1];
    cell.text.backgroundColor=[UIColor colorWithRed:247.0/255.0 green:176.0/255.0 blue:143.0/255.0 alpha:1];
}


- (BOOL)canBecomeFirstResponder{
    return YES;
}


- (void)longpressAction:(UITapGestureRecognizer *)tap
{

    [self becomeFirstResponder];
    // UIMenuController *menuController = [UIMenuController sharedMenuController];
    // [menuController setMenuVisible:YES animated:YES];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)createCmapView{
    cmapView=[[CmapController alloc] initWithNibName:@"CmapView" bundle:nil];
    cmapView.parentTrainingCtr=self;
    cmapView.isTraining=YES;
    //cmapView.userName=userName;
    //cmapView.bookLogDataWrapper=logWrapper;
    cmapView.showType=1;
    //cmapView.enableHyperLink=enableHyperLink;
    //cmapView.parentBookPageViewController=self;
    //cmapView.neighbor_BookViewController=self.bookView;
    [self addChildViewController:cmapView];
    [self.view addSubview:cmapView.view];
    [cmapView.view setUserInteractionEnabled:YES];
    float wid=self.view.frame.size.width*3/4;
   cmapView.view.center=CGPointMake(346, 384);
     CGRect cmapRec=CGRectMake(512, 0, 512, 768);
}


-(void) setingUpMenuItem{ //set the menu items in the content view
    // use notification to check if the menu is showing
    
    
    // Menu Controller, controls the manu list which will pop up when the user click a selected word or string
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    CXAMenuItemSettings *markIconSettingsConcpet = [CXAMenuItemSettings new];
    markIconSettingsConcpet.image = [UIImage imageNamed:@"bb"];

    CXAMenuItemSettings *takeNoteSetting = [CXAMenuItemSettings new];
    takeNoteSetting.image = [UIImage imageNamed:@"take_note"];
    takeNoteSetting.shadowDisabled = NO;
    takeNoteSetting.shrinkWidth = 4; //set menu item size and picture.
    
    UIMenuItem *concept = [[UIMenuItem alloc] initWithTitle: @"concept" action: @selector(dragAndDrop:)];
    [concept cxa_setSettings:markIconSettingsConcpet];
  
    [menuController setMenuItems: [NSArray arrayWithObjects: concept, nil]];
    
}


-(void)showWebhint{
    webFocusQuestionLable = [[UILabel alloc] initWithFrame:CGRectMake(90, 55, 350, 33)];
    webFocusQuestionLable.backgroundColor=[UIColor colorWithRed:247.0/255.0 green:176.0/255.0 blue:143.0/255.0 alpha:1];
    webFocusQuestionLable.text=@"Long press on the word you want to add";
    webFocusQuestionLable.alpha=0.8;
    webFocusQuestionLable.textAlignment = NSTextAlignmentCenter;
    webFocusQuestionLable.layer.shadowOpacity = 0.4;
    webFocusQuestionLable.layer.shadowRadius = 3;
    webFocusQuestionLable.layer.shadowColor = [UIColor blackColor].CGColor;
    webFocusQuestionLable.layer.shadowOffset = CGSizeMake(2, 2);
    [self.view addSubview:webFocusQuestionLable];
    UIImage *image = [UIImage imageNamed:@"hintbulb"];
    image=[self imageWithImage:image scaledToSize:CGSizeMake(26, 36)];
    
    hintImg = [[UIImageView alloc] initWithFrame:CGRectMake(50, 55, 28, 35)];
    [hintImg setImage:image];

    [self.view addSubview: hintImg];
}


-(void)showLinkingHint{
    [self showAlertWithString:@"Good job! Now link the concept you created with the node named link me"];
   [ webFocusQuestionLable setFrame: CGRectMake(90, 35, 430, 50)];
    webFocusQuestionLable.text=@"Long click on a concept and drag to the linking option. When the node is blinking, click on the node you want to link it with.";
    webFocusQuestionLable.font=[webFocusQuestionLable.font fontWithSize:14];
    webFocusQuestionLable.lineBreakMode = NSLineBreakByWordWrapping;
    webFocusQuestionLable.numberOfLines = 0;
    webFocusQuestionLable.center=CGPointMake(780, 73);
    hintImg.center=CGPointMake(530, 75);
    
}


- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


-(void)showAlertWithString: (NSString*) str{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Task"
                                                    message:str
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    
    UIImage *image = [UIImage imageNamed:@"Train_AddNode"];
    image=[self imageWithImage:image scaledToSize:CGSizeMake(200, 300)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];

    [alert setValue:imageView forKey:@"accessoryView"];
    [alert show];
}



-(void)createDeleteTraining{
    for (NodeCell *cell in cmapView.conceptNodeArray)
    {
        [cell removeLink];
        [cell.view removeFromSuperview];
    }
    NodeCell* cell= [cmapView createNodeFromBookForLink:CGPointMake( 250, 300) withName:@"delete me" BookPos:CGPointMake(0, 0) page:1];
    cell.text.backgroundColor=[UIColor colorWithRed:247.0/255.0 green:176.0/255.0 blue:143.0/255.0 alpha:1];
    webFocusQuestionLable.text=@"Long click on a concept and drag to the delete option.";
}

@end
