//
//  CmapView.m
//  MIReR
//
//  Created by Andreea Danielescu on 9/16/09.
//  Copyright 2009 Arizona State University. All rights reserved.
//

#import "CmapView.h"

@implementation CmapView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	if (self)
	{
		//initialize arrays.
		nodes = [[NSMutableArray alloc] init];
		relations = [[NSMutableArray alloc] init];
		selectedNodes = [[NSMutableArray alloc] init]; 
		selectedRelations = [[NSMutableArray alloc] init]; 
		addingRelation = FALSE;	
		//dragView = [[DragView alloc] initWithFrame:frame];
		//[self addSubview:dragView];
		dragView = [[DragView alloc] init];
		movingObjects = FALSE;
		
		//[[self window] acceptsMouseMovedEvents:YES];
		importerExporter = [[CMapImporterExporter alloc] init];
	}
	return self;
}



@end
