//
//  LSHorizontalScrollTabViewDemoViewController.m
//  LSTabs
//
//

#import "LSHorizontalScrollTabViewDemoViewController.h"
#import "LSScrollTabBarView.h"
#import "HorizontalTabControl.h"
#import "LSTabItem.h"
#import "HighlightParser.h"
#import "HighLightWrapper.h"
#import "GDataXMLNode.h"
#import "HighLight.h"
#import "ThumbNailIcon.h"
#import "ThumbNailIconParser.h"
#import "ThumbNailIconWrapper.h"


@interface LSHorizontalScrollTabViewDemoViewController () {
    LSScrollTabBarView *tabView;
}
@end


@implementation LSHorizontalScrollTabViewDemoViewController
@synthesize isMenuShow;
@synthesize contentTableView;
@synthesize thumbNailWrapper;
@synthesize highlightWrapper;
@synthesize dataList;
@synthesize bookTitle;
@synthesize tagToShow;
@synthesize noteIcons;
@synthesize webIcons;
@synthesize showType;
@synthesize originSize;
@synthesize parentContentViewController;
@synthesize QAWebview;
@synthesize webviewIsShow;
+ (NSString *)viewTitle {
    return @"Review Section";
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:@"LSHorizontalScrollTabView" bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
	isMenuShow=NO;
    self.navigationItem.title = [[self class] viewTitle];
    if(1==showType){
    [self.controlPanelBG setFrame:CGRectMake(0, 0, 494, 45)];
        CGRect rect=CGRectMake(0, 0, 494, 768);
        [self.view setFrame:rect];
        
    }else{
        if([UIApplication sharedApplication].statusBarOrientation==UIInterfaceOrientationLandscapeLeft||[UIApplication sharedApplication].statusBarOrientation==UIInterfaceOrientationLandscapeRight){
             [self.controlPanelBG setFrame:CGRectMake(0, 0, 1024, 45)];
              [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
        }else{
        [self.controlPanelBG setFrame:CGRectMake(0, 0, 1024, 45)];
        [self.view setFrame:[[UIScreen mainScreen] bounds]];
        }
    }
    self.borderImageView.image = [UIImage imageNamed:@"scrolltabs_horizontal_border"];
    self.controlPanelView.image = [UIImage imageNamed:@"controlpanel_view_background"];
    self.controlPanelBG.image=[UIImage imageNamed:@"controlUpBarBG"];
    NSArray *tabItems = @[ [[LSTabItem alloc] initWithTitle:@"Highlights"] ,
                           [[LSTabItem alloc] initWithTitle:@"BookMarks"] ,
                           [[LSTabItem alloc] initWithTitle:@"WebLinks"] ,
                           [[LSTabItem alloc] initWithTitle:@"Q&A"],
                           [[LSTabItem alloc] initWithTitle:@"Note"],
      ];
    // Assigns some badge number
    ((LSTabItem *)tabItems[1]).badgeNumber = 5;
    ((LSTabItem *)tabItems[2]).badgeNumber = 1;
    [((LSTabItem *)tabItems[1]).parentTabControl setButtonBg:@"TabNormal_red"];
    
    tabView = [[LSScrollTabBarView alloc] initWithItems:tabItems delegate:self];
    tabView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    tabView.itemPadding = -65.0f;
    tabView.margin = -15.0f;
    tabView.frame = CGRectMake(0.0f, 3.0f, self.view.bounds.size.width, 42.0f);
    [self.view addSubview:tabView];
    
    [self.view bringSubviewToFront:self.borderImageView];
    [self.view bringSubviewToFront:tabView];
    [self.view bringSubviewToFront:self.controlPanelView];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationController setNavigationBarHidden: YES animated:YES];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerTwoTaps:)];
    [doubleTap setNumberOfTapsRequired:2];
    doubleTap.delegate=self;
    [self.controlPanelView addGestureRecognizer:doubleTap];

    contentTableView.dataSource=self;
    contentTableView.delegate= self;
    [contentTableView reloadData];
    tagToShow=0 ;
    
    webIcons=[[NSMutableArray alloc]init];
    noteIcons=[[NSMutableArray alloc]init];

    //filter the highlights from other books
    NSMutableArray *temp=[[NSMutableArray alloc]init];
    for(HighLight *highlights in highlightWrapper.highLights){
        if([highlights.bookTitle isEqualToString:bookTitle]){
            [temp addObject:highlights];
        }
    }
    highlightWrapper.highLights=temp;
    
    NSMutableArray *temp2=[[NSMutableArray alloc]init];
    for(ThumbNailIcon *thms in thumbNailWrapper.thumbnails){
        if([thms.bookTitle isEqualToString:bookTitle]){
            [temp2 addObject:thms];
        }
    }
    thumbNailWrapper.thumbnails=temp2;
    
    for(ThumbNailIcon* icon in thumbNailWrapper.thumbnails){
        if(1==icon.type){
            [noteIcons addObject:icon];
        }else if(2==icon.type){
            [webIcons addObject:icon];
        }
    }

    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    pinchGesture.delegate=self;
    if(1==showType){
    [self.view addGestureRecognizer:pinchGesture];
    }
    originSize=self.view.frame;
    
    
    
    QAWebview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0,480 ,768)];
    NSString* url = @"http://2sigma.asu.edu/qa/";
    QAWebview.backgroundColor=[UIColor whiteColor];
    NSURL* nsUrl = [NSURL URLWithString:url];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    
    [QAWebview loadRequest:request];
    
    //[contentTableView addSubview:QAWebview];
   // [QAWebview setHidden:YES];
   // webviewIsShow=YES;
}



- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer
{
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
    
    if(recognizer.state == UIGestureRecognizerStateEnded){
        if(originSize.size.width*1.2<recognizer.view.frame.size.width||1==showType){
            [self.view setFrame:CGRectMake(0, 0, 494, 768)];                                     
            [parentContentViewController showRecourseFullScreen];
        }
    }
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}




- (void)oneFingerTwoTaps:(UITapGestureRecognizer *)tap
{
    if(!isMenuShow){  //is the menu bar is showing, disable the gesture action
        //set navigation bar animation, which uses the QuartzCore framework.
        CATransition *navigationBarAnimation = [CATransition animation];
        navigationBarAnimation.duration = 0.7;
        navigationBarAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        //navigationBarAnimation.type = kCATransitionMoveIn;
        //navigationBarAnimation.subtype = kCATransitionFromBottom;
        navigationBarAnimation.removedOnCompletion = YES;
        [self.navigationController.navigationBar.layer addAnimation:navigationBarAnimation forKey:nil];
        //click with one finger to show or hind the navigaion bar.
        BOOL navBarState = [self.navigationController isNavigationBarHidden];
        if(!navBarState ){
            [self.navigationController setNavigationBarHidden: YES animated:YES];
        }else {
            [self.navigationController setNavigationBarHidden: NO animated:YES];
        }
    }else{
        [self.navigationController setNavigationBarHidden: YES animated:YES];
    } 
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellWithIdentifier];
    }
    NSUInteger row = [indexPath row];
    
    NSLog(@"Tag to show: %d",tagToShow);
    
    if(0==tagToShow){

        
        if(highlightWrapper.highLights.count>row){
         HighLight *highlightContent=[highlightWrapper.highLights objectAtIndex:row];
        cell.detailTextLabel.text = highlightContent.text;
         cell.textLabel.text =   [NSString stringWithFormat:@"Page: %d",highlightContent.page ];
         cell.tag=highlightContent.page;
        }
    }
    if(1==tagToShow){

        if(thumbNailWrapper.thumbnails.count>row){
        ThumbNailIcon *thunmnailContent=[thumbNailWrapper.thumbnails objectAtIndex:row];
        if(1==thunmnailContent.type){
            cell.detailTextLabel.text=thunmnailContent.text;
            cell.textLabel.text =   [NSString stringWithFormat:@"Page: %d",thunmnailContent.page ];
           // cell.tag=thunmnailContent.page;
        }else if(2==thunmnailContent.type){
            cell.detailTextLabel.text=thunmnailContent.url;
            cell.textLabel.text =   [NSString stringWithFormat:@"Page: %d",thunmnailContent.page ];
        }
        }
    }
    if(2==tagToShow){

        if(webIcons.count>row){
        ThumbNailIcon *webIconContent= [webIcons objectAtIndex:row];
        cell.detailTextLabel.text=webIconContent.url;
        cell.textLabel.text =   [NSString stringWithFormat:@"Page: %d",webIconContent.page];
        }
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 60;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(0==tagToShow){
        return [highlightWrapper.highLights count];
    }
    if(1==tagToShow){
        return [thumbNailWrapper.thumbnails count];
    }
    if(2==tagToShow){

        return [webIcons count];
    }
    if(3==tagToShow){
        return [noteIcons count];
    }
    else return 0;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark LSTabBarViewDelegate Methods

- (LSTabControl *)tabBar:(LSTabBarView *)tabBar
          tabViewForItem:(LSTabItem *)item
                 atIndex:(NSInteger)index
{
    return [[HorizontalTabControl alloc] initWithItem:item];
}


- (void)tabBar:(LSTabBarView *)tabBar
   tabSelected:(LSTabItem *)item
       atIndex:(NSInteger)selectedIndex
{
    NSLog(@"Tab bar select");
    self.selectedTabLabel.text = [NSString stringWithFormat:@"%@", item.title];
    tagToShow=selectedIndex;
    [contentTableView reloadData];
    
    NSLog(@"%@",self.selectedTabLabel.text);
    if([self.selectedTabLabel.text isEqualToString:@"Q&A"]){
       
        [contentTableView addSubview: QAWebview];
        webviewIsShow=YES;
    
      // [QAWebview setHidden:NO];
    }else if(webviewIsShow){
        [QAWebview removeFromSuperview];
        webviewIsShow=NO;
       //[QAWebview setHidden:YES];
    }
    
    
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
  //  NSLog(@"%d", indexPath.row);
   UITableViewCell *cell= [tableView cellForRowAtIndexPath:indexPath];
    NSString* text=cell.textLabel.text;
   [text stringByReplacingOccurrencesOfString:@"Page:" withString:@""];
    NSLog(@"Page num: %d",cell.tag);
    [parentContentViewController showPageAtINdex:cell.tag-1];
    
}


- (BOOL) canPerformAction:(SEL)action withSender:(id)sender
{
    if (  action == @selector(oneFingerTwoTaps:))
    {
        return YES;
    }
    return NO;
}

// check if the menu bar is showing
- (IBAction)didHideEditMenu : (id)sender {
    isMenuShow=NO;
}
//if the menu bar is about popup, hide the navigation bar
- (IBAction)willShowEditMenu : (id)sender {
    [self.navigationController setNavigationBarHidden: YES animated:YES];
    isMenuShow=YES;
}

- (IBAction)didShowEditMenu : (id)sender {
    isMenuShow=YES;
}


@end
