//
//  CmapView.h
//  MIReR
//
//  Created by Andreea Danielescu on 9/16/09.
//  Copyright 2009 Arizona State University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Node.h"
#import "GroupingNode.h"
#import "Relation.h"
#import "DragView.h"
#import "CMapImporterExporter.h"

@interface CmapView : UIView {
	NSMutableArray *nodes;
	NSMutableArray *relations;
	Boolean addingRelation;
	CGPoint rightClickPoint;
	CGPoint mouseLocation;
	DragView* dragView;
	CGPoint startDragLocation;
	Boolean movingObjects;
	NSMutableArray *selectedNodes;
	NSMutableArray *selectedRelations;

	
	CMapImporterExporter *importerExporter;
}

//textDelegate
-(void)controlTextDidEndEditing:(NSNotification *)aNotification;

//Create the new concept
-(Node*) addConcept: (CGPoint)point;

//Temporary function to fix the right click point stuff.
- (void)addConceptRightClick:(CGPoint)point;

//Add a relationship between concepts
-(void)addRelation:(CGPoint)point;

//change pre-existing relation
- (void)changeRelation:(Relation*)relation;
	
//Find the node concept in the rect
//-(Node*) findNodeInRect: (CGRect)rect;
-(NSMutableArray*) findNodesInRect: (CGRect)rect;

//Find the relation in the rect
//-(Relation*) findRelationInRect:(CGRect) rect;
-(NSMutableArray*) findRelationsInRect:(CGRect) rect;

//Check if point in pre-existing node.
-(Node*) pointInNode:(CGPoint) point;

//Check if point in pre-existing relation.
-(Relation*) pointInRelation:(CGPoint) point;

//Delete the concept by sending in the right click point.
- (void)deleteConceptRightClick:(CGPoint)point;

//Delete an existing concept
-(void)deleteConcept:(CGPoint)point;

//Delete an existing concept
-(void)deleteRelation:(CGPoint)point;

-(void)groupConcepts:(CGPoint) point;

//Calculates the midpoint of 2 points. 
-(CGPoint)calculateMidPoint:(NSMutableArray*)points;
@end
