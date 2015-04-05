//
//  LSHorizontalScrollTabViewDemoViewController.h
//  LSTabs
//
//

#import <UIKit/UIKit.h>

//#import "DemoViewControllerProtocol.h"
#import "LSTabBarView.h"
#import "ContentViewController.h"
@class HighLightWrapper;
@class ThumbNailIconWrapper;
//@class ContentViewController;
@interface LSHorizontalScrollTabViewDemoViewController : UIViewController <LSTabBarViewDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSString *bookTitle;
@property (nonatomic, retain) IBOutlet UIImageView *controlPanelBG;
@property (nonatomic, retain) IBOutlet UIImageView *controlPanelView;
@property (nonatomic, retain) IBOutlet UIImageView *borderImageView;
@property (nonatomic, retain) IBOutlet UILabel     *selectedTabLabel;
@property (nonatomic, retain) IBOutlet UITableView *contentTableView;
@property (nonatomic, retain) UIWebView *QAWebview;
@property (nonatomic, retain) NSArray* dataList;
@property (nonatomic) int tagToShow;
@property (nonatomic) BOOL isMenuShow;
@property (nonatomic) int showType;//0: full screen, 1: half screen
@property (nonatomic, retain) HighLightWrapper *highlightWrapper;
@property (nonatomic, retain) ThumbNailIconWrapper *thumbNailWrapper;
@property (nonatomic, retain) NSMutableArray *noteIcons;
@property (nonatomic, retain) NSMutableArray *webIcons;
@property (nonatomic, strong) ContentViewController* parentContentViewController;
@property CGRect originSize;
@property BOOL webviewIsShow;
@end
