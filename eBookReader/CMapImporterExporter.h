//
//  CMapImporterExporter.h
//  MIReR
//
//  Created by Andreea Danielescu on 10/2/09.
//  Copyright 2009 Arizona State University School of Arts, Media, + Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Node.h"
#import "GroupingNode.h"
#import "ConceptNode.h"
#import "Relation.h"
#import "Connection.h"
#import "NSString+XMLEntities.h"
#import "Base64.h"

@interface CMapImporterExporter : NSObject {
	bool cmapLargerThanView;
	CGRect cmapSize;
}

-(NSMutableArray*) importCmapFromFile:(NSString*)fileName :(CGSize)viewSize;
-(void) exportCmapToFile:(NSString*)fileName :(NSMutableArray*)nodesAndRelations :(CGSize)cmapSize;

-(NSString*) getAttributeValue:(NSString*)tag :(NSString*)currLine;

//Calculates the midpoint of 2 points. 
-(CGPoint)calculateMidPoint:(NSMutableArray*)points;

//Check to see the node with the given id already exists.
-(Node*) findNodeWithId:(NSString*)id :(NSMutableArray*)nodes;

-(bool) isCmapLargerThanView;
-(CGRect) getCmapSize;

@end
