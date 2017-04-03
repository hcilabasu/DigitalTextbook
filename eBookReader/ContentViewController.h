//
//  ContentViewController.h
//  eBookReader
//
//  Created by Shang Wang on 3/19/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>
#import "KnowledgeModule.h"
#import "ThumbNailController.h"
#import "PopoverView.h"
#import "LogFileController.h"
#import <OpenEars/LanguageModelGenerator.h>
#import <OpenEars/AcousticModel.h>
#import "AVFoundation/AVSpeechSynthesis.h"
#import "ConceptViewController.h"
#import "CmapController.h"
#import "NodeCell.h"
#import <NodeViewController.h>
#import "LogData.h"
#import "LogDataParser.h"
#import "LogDataWrapper.h"
#import "QuizViewController.h"
#ifndef CONTENTVIEWCONTROLLER_H
#define CONTENTVIEWCONTROLLER_H

@class NoteViewController;
@class BookViewController;
@class HighLightWrapper;
@class HighLight;
@class ThumbNailIconWrapper;
@class CmapController;

@interface ContentViewController : UIViewController< PopoverViewDelegate, UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate,UIWebViewDelegate,UIScrollViewDelegate,UICollectionViewDataSource, UICollectionViewDelegate,UIGestureRecognizerDelegate>
{
    PopoverView *pv; //popOver view
    CGPoint pvPoint;// position where pop over view shows
}
#endif

@property (strong, nonatomic) NSString *bookTitle;
@property (strong, nonatomic) IBOutlet UIWebView *webView; // the webview which displays the content
@property (strong, nonatomic) IBOutlet UIScrollView *ThumbScrollViewLeft;
@property (strong, nonatomic) IBOutlet UIScrollView *ThumbScrollViewRight;
//@property (strong, nonatomic) CmapController *cmapView;
@property BOOL isleftThumbShow;
@property BOOL isSplit;//check if the concept map construction  view is showing.
@property (strong, nonatomic) NSString *firstRespondConcpet;//the concept the student is working on

@property (strong, nonatomic) id dataObject;// sotres the HTML data
@property (strong, nonatomic) id url; //the URL link to display HTML content
@property (nonatomic) BOOL isMenuShow;
@property (nonatomic, retain) IBOutlet UILabel *currentPageLabel; //indicates the current page number
@property (nonatomic) int pageNum; //current page number
@property (nonatomic) int totalpageNum;//total page number
@property (strong, nonatomic) BookViewController *parent_BookViewController; //stores the its parent view, in order to call the parent controlller methods
@property (strong, nonatomic) NSMutableArray *highlightTextArray;//stores the highlighted text in an array
@property (strong, nonatomic) KnowledgeModule *knowledge_module;
@property (strong, nonatomic) LanguageModelGenerator *lmGenerator;// open ear languange generater
@property (strong, nonatomic) NSString *userName;


@property (strong, nonatomic) AVSpeechSynthesizer* syn;

@property (strong, nonatomic) ThumbNailController *thumbNailController; //thumbnail controller which controls the thunbail icon position
@property (strong, nonatomic) LogFileController* logFileController;
@property (nonatomic, retain) HighLightWrapper *bookHighLight;//the highlight wrapper pased from the bookviewcontroller to control the highlight info in the book
@property (nonatomic, retain) ThumbNailIconWrapper *bookthumbNailIcon;
@property (nonatomic, retain) LogDataWrapper* bookLogData;

@property (nonatomic, retain) CmapController *overLayCmapView;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *CmapStart;
@property(strong,nonatomic)UIImageView *bulbImageView;
@property (strong, nonatomic) NSMutableArray*  conceptNamesArray;
@property (nonatomic, strong) IBOutlet UICollectionView *linkCollectionView;
@property (nonatomic) BOOL isCollectionShow;
@property  BOOL showingOverLayCmap;


@property NSTimeInterval totalCountdownInterval;
@property NSTimeInterval remainTime;
@property NSDate* startDate;
@property (weak, nonatomic) IBOutlet UILabel *timerLable;





-(void)showRecourseFullScreen;

@property NSArray *linkItems;
-(void)setingUpMenuItem;
-(void)refresh;
-(void)createWebNote : (CGPoint) show_at_point URL:(NSURLRequest*) urlrequest isWriteToFile:(BOOL)iswrite isNewIcon: (BOOL)isNew;
-(NoteViewController*)createNote : (CGPoint) show_at_point NoteText:(NSString*) m_note_text isWriteToFile:(BOOL)iswrite;
- (void)highlightStringWithColor:(NSString*)color;
- (void)callJavaScriptMethod:(NSString*)method;
-(void)saveHighlightToXML:(NSString*)color_string;
- (NSInteger)highlightAllOccurencesOfString:(NSString*)str;
-(void)loadHghLight;
-(int)ifHighlightCollapse: (HighLight*) temp_highlight;
-(void)loadThumbNailIcon: (NSString*)concpet;
-(void)updateNoteText:(CGPoint) show_at_point PreText: (NSString*)pre_text NewText: (NSString *)new_text;
-(UIImage*)getScreenShot;
-(ConceptViewController*)createConceptIcon : (CGPoint) show_at_point NoteText:(NSString*) m_note_text isWriteToFile:(BOOL)iswrite;
-(void)splitScreen;
-(void)showPageAtINdex:(int)pageNumber;
-(void)expandSubNode:(UIView*)node;
-(void)showOverLayCmapView;
-(void)hideOverLayCmapView;
-(void)showFlipPageHint;
@end
