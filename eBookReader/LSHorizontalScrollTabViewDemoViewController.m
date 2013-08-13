//
//  LSHorizontalScrollTabViewDemoViewController.m
//  LSTabs
//
//  Created by Marco Mussini on 6/18/12.
//  Copyright (c) 2012 Lucky Software. All rights reserved.
//

#import "LSHorizontalScrollTabViewDemoViewController.h"
#import "LSScrollTabBarView.h"
#import "HorizontalTabControl.h"
#import "LSTabItem.h"



@interface LSHorizontalScrollTabViewDemoViewController () {
    LSScrollTabBarView *tabView;
}

@end


@implementation LSHorizontalScrollTabViewDemoViewController
@synthesize isMenuShow;

+ (NSString *)viewTitle {
    return @"Horizontal Scroll Tab View";
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
    
    [self.controlPanelBG setFrame:CGRectMake(0, 0, 1024, 45)];
    self.borderImageView.image = [UIImage imageNamed:@"scrolltabs_horizontal_border"];
    self.controlPanelView.image = [UIImage imageNamed:@"controlpanel_view_background"];
    self.controlPanelBG.image=[UIImage imageNamed:@"controlUpBarBG"];
    

    
    NSArray *tabItems = @[ [[LSTabItem alloc] initWithTitle:@"Highlights"] ,
                           [[LSTabItem alloc] initWithTitle:@"BookMarks"] ,
                           [[LSTabItem alloc] initWithTitle:@"WebLinks"] ,
                           [[LSTabItem alloc] initWithTitle:@"Notes"],
                           [[LSTabItem alloc] initWithTitle:@"Other"],
                 

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
    

}


- (void)oneFingerTwoTaps:(UITapGestureRecognizer *)tap
{
    if(!isMenuShow){  //is the menu bar is showing, disable the gesture action
        //set navigation bar animation, which uses the QuartzCore framework.
        CATransition *navigationBarAnimation = [CATransition animation];
        navigationBarAnimation.duration = 0.7;
        navigationBarAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];;
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
    self.selectedTabLabel.text = [NSString stringWithFormat:@"%@ selected", item.title];
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
