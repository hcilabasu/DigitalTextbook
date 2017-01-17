//
//  MainWindowController.h
//  MIReR
//
//  Created by Andreea Danielescu on 12/10/09.
//  Copyright 2009 Arizona State University School of Arts, Media, + Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CmapView.h"
//#import "ButtonView.h"
#import "CMapImporterExporter.h"
#import "Node.h"
//#import "HandCursorView.h"

@class CmapView;

@interface MainWindowController : UIViewController {
    IBOutlet CmapView *cmapView; ///< A reference to the CmapView.
    //IBOutlet ButtonView *buttonView; ///< A reference to the ButtonView.
    //IBOutlet HandCursorView *rightHandCursorView;
    //IBOutlet HandCursorView *leftHandCursorView;
    
    IBOutlet UIWindow *OSCPreferences;
    IBOutlet UIWindow *window;
            
	CMapImporterExporter *importerExporter; ///< A reference to the CMapImporterExporter.
	
	NSString* workSpaceFile; ///< A filename of the current workspace. If empty then this is a new workspace and hasn't been named yet.
	NSString* cmapFile; ///< The name of the concept map currently being displayed.
	
	BOOL changesMade;

    BOOL leftHandSelecting;
    BOOL rightHandSelecting;
    CGPoint leftHandSelectLoc;
    CGPoint rightHandSelectLoc;
}

@property (retain) CmapView* cmapView;
//@property (retain) ButtonView* buttonView;
//@property (retain) HandCursorView* rightHandCursorView;
//@property (retain) HandCursorView* leftHandCursorView;

@property (retain) UIWindow* OSCPreferences;
@property (retain) UIWindow* window;

@property (retain) NSString* workSpaceFile;
@property (retain) NSString* cmapFile;
@property (assign) BOOL changesMade;

-(void) cmapImport;

-(IBAction)exportCMap:(id)sender;

-(IBAction)saveWorkspace:(id)sender;

-(IBAction)saveWorkspaceAs:(id)sender;

-(void)saveWorkspace;

-(IBAction)newWorkspace:(id)sender;

-(IBAction)closeWorkspace:(id)sender;

-(void)clearWorkspace;

-(void)openWorkspace:(NSString*)filename;

-(NSString*) getAttributeValue:(NSString*) tag :(NSString*)currLine;

-(IBAction)zoomInCmap:(id)sender;

-(IBAction)zoomOutCmap:(id)sender;

-(IBAction)addRelation:(id)sender;

-(IBAction)groupConcepts:(id)sender;

-(IBAction)eraseConcept:(id)sender;

-(IBAction)openFile:(id)sender;

-(IBAction)showOSCPreferences:(id)sender;

-(void) rightHandMoved:(CGPoint) normNewPoint;

-(void) leftHandMoved:(CGPoint) normNewPoint;

-(void) rightHandSelect:(CGPoint) normPoint;

-(void) leftHandSelect:(CGPoint) normPoint;

-(void) doubleHandSelect:(CGPoint) rightHandPoint :(CGPoint) leftHandPoint;

-(void) rightHandDeselect:(CGPoint) normPoint;

-(void) leftHandDeselect:(CGPoint) normPoint;

-(void) doubleHandDeselect:(CGPoint) rightHandPoint :(CGPoint) leftHandPoint;

-(CGPoint) convertNormPointToScreenCoords:(CGPoint) normPoint;

-(BOOL) pointInButtonView:(CGPoint) point;

-(BOOL) pointInCmapView:(CGPoint) point;

-(void) cmapObjectsSelected:(int) numSelected;

@end
