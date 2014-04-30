//  Copyright 2009 Arizona State University School of Arts, Media, + Engineering. All rights reserved.

/**************************************************************************************************//**
 * \class MainWindowController
 * \author Andreea Danielescu
 * \date 12/10/09
 * \brief Main controller for the program.
 *
 * All interaction between windows passes through this controller. This controller also handles all 
 * menu item actions, such as opening workspaces and importing and exporting files.
 *****************************************************************************************************/

/*! \mainpage
 *
 * \sec/Users/andreea/Desktop/AME 598 - Experiential Media Theory/Assignments/Final Project/Cmapping with Kinect/Cmapping with Kinect/MainWindowController.mtion intro_sec Introduction
 *
 * Welcome to the MIReR API.
 *
 * \section install_sec Installation
 *
 */

#import "MainWindowController.h"

///#define cursorUsed flatHand
#define cursorUsed pointingHand

int orderViews(id one, id two, void *context);

/*
int orderViews(id one, id two, void *context){
    if (([one class] == [HandCursorView class]) && ([two class] != [HandCursorView class]))
        return NSOrderedDescending;
    else if (([one class] != [HandCursorView class]) && ([two class] == [HandCursorView class]))
        return NSOrderedAscending;
    else
        return NSOrderedSame;
}*/

@implementation MainWindowController

enum cursor {flatHand, pointingHand, grabbingHand, symbol, cursorAlternativesCount};

@synthesize workSpaceFile;
@synthesize cmapFile;

@synthesize cmapView;
//@synthesize buttonView;
//@synthesize rightHandCursorView;
//@synthesize leftHandCursorView;

@synthesize OSCPreferences;
@synthesize window;

@synthesize changesMade;

/**
 * initiallize all variables.
 */
- (id)init
{
    if (self = [super init]) {
		importerExporter = [[CMapImporterExporter alloc] init];
		
		workSpaceFile=@"";
		cmapFile = @"";
		changesMade = FALSE;
        leftHandSelecting = FALSE;
        rightHandSelecting = FALSE;
        
		return self;
    }
    
    return nil;
}








@end
