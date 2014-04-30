//  Copyright 2009 Arizona State University School of Arts, Media, + Engineering. All rights reserved.

/**************************************************************************************************//**
 * \class CMapImporterExporter
 * \author Andreea Danielescu
 * \date 10/2/09
 * \brief Imports and exports cmap files with the .cxl in xml format.
 *
 *****************************************************************************************************/

#import "CMapImporterExporter.h"

@implementation CMapImporterExporter

- (id) init {
	if ( self = [super init] ) 
	{ 
		cmapLargerThanView = FALSE;
	} 
	
	return self; 
}

/**
 * Imports a concept map from the given cxl file.
 @param fileName The filename of the concept map to import.
 @param viewSize The size of the CmapView. Used to calculate relative 
 * size and position of the Node objects being imported.
 @returns an array containing 2 other arrays in it.  These two arrays hold references to the
 * Node and Relation / Connection objects created in the import function.
 */
-(NSMutableArray*) importCmapFromFile:(NSString*) fileName :(CGSize)viewSize{
	//NSLog(@"Importing cmap from file: %@", fileName);
	
	//Create the nodes and relations data structures.
	NSMutableArray *nodesAndRelations = [[NSMutableArray alloc] init];
	NSMutableArray *nodes = [[NSMutableArray alloc] init];
	NSMutableArray *relations = [[NSMutableArray alloc] init];
	//NSMutableArray *links = [[NSMutableArray alloc] init];
	
	//Get the file contents
	NSString *fileInput = [NSString stringWithContentsOfFile:fileName];
	//NSLog(fileInput);
	
	//parse the clx file to get the nodes and relations
	NSScanner *scanner = [NSScanner scannerWithString:fileInput];
	NSCharacterSet *newlineCharSet = [NSCharacterSet newlineCharacterSet];
	
	NSString* map = @"<map ";
	NSString* concept = @"<concept ";
    NSString* image = @"<image ";
	NSString* idTag = @"id=\"";
	//NSCharacterSet *endQuote = [NSCharacterSet characterSetWithCharactersInString:@"\""];
	NSCharacterSet *comma = [NSCharacterSet characterSetWithCharactersInString:@","];
	NSString* labelTag = @"label=\"";
    NSString* imageTag = @"background-image=\"";
    NSString* imageByteTag = @"bytes=\"";
	NSString* linkingPhrase = @"<linking-phrase ";
	NSString* connection = @"<connection ";
	NSString* fromIdTag = @"from-id=\"";
	NSString* toIdTag = @"to-id=\"";
	NSString* conceptAppearance = @"<concept-appearance ";
	NSString* relationAppearance = @"<linking-phrase-appearance ";
	NSString* conceptWidthTag = @"width=\"";
	NSString* conceptHeightTag = @"height=\"";
	NSString* conceptXTag = @"x=\"";
	NSString* conceptYTag = @"y=\"";
	NSString* backgroundColorTag = @"background-color=\"";
	//NSString* parentidTag = @"parent-id=\"";
	NSString* noLabel = @"????";
	
	NSString* objId = @"";
    NSString* imageId = @"";
	NSString* fromId = @"";
	NSString* toId = @"";
	NSString* objLabel = @"";
    NSString* imageBytes = @"";
	//NSString *nodeParentId = @"";
	NSString* currLine = @"";
	CGFloat x, y, width, height, mapWidth, mapHeight, widthRatio = 0, heightRatio = 0; 
	NSString* backgroundColor;
	
	//change scanner to be more dynamic so it doesn't explode when there's information it doesn't need. 
	while ([scanner isAtEnd] == NO)
	{
		if([scanner scanString:map intoString:NULL] && 
		   [scanner scanString:conceptWidthTag intoString:NULL] &&
		   [scanner scanDouble:&mapWidth] &&
		   [scanner scanString:@"\" " intoString:NULL] && 	
		   [scanner scanString:conceptHeightTag intoString:NULL] && 
		   [scanner scanDouble:&mapHeight])
		{
			//NSLog(@"cmap width: %f height: %f", mapWidth, mapHeight);
			
			widthRatio = viewSize.width/mapWidth;
			heightRatio = viewSize.height/mapHeight;
        
            cmapSize=CGRectMake(0, 0, mapWidth, mapHeight);
			
			if(widthRatio < 1.0 || heightRatio < 1.0)
				cmapLargerThanView = TRUE;
			
			//NSLog(@"widthRatio: %f heightRatio: %f", widthRatio, heightRatio);
		}
		//If scanned in a node, create node with information
		else if([scanner scanString:concept intoString:NULL]) 
		{
			//NSLog(@"scanning node");
			[scanner scanUpToCharactersFromSet:newlineCharSet intoString:&currLine];
			currLine = [currLine stringByDecodingXMLEntities];
			
			objId = [self getAttributeValue:idTag :currLine];
			objLabel = [self getAttributeValue:labelTag :currLine];
			
			ConceptNode *currNode =  (ConceptNode*)[self findNodeWithId:objId :nodes];
			
			if(!currNode)
				currNode = [[ConceptNode alloc] init];
			
			[currNode setId:objId];
			[currNode setLabel:objLabel];	
                       
            [nodes addObject:currNode];
			
			//if node has parent node.
			//Come back and fix later.
			/*if([scanner scanString:nodeParentId intoString:NULL] && 
			   [scanner  scanUpToCharactersFromSet:endQuote intoString:&objLabel] && 
			   [scanner scanString:@"\"" intoString:NULL] &&
			   [scanner scanString:labelTag intoString:NULL] && 
			   [scanner  scanUpToCharactersFromSet:endQuote intoString:&objLabel] && 
			   [scanner scanString:@"\"" intoString:NULL] &&
			   [scanner scanString:endTag intoString:NULL])
			{
				//if node is parent node itself.
				if([objLabel compare:noLabel] == NSOrderedSame)
				{
					GroupingNode *currNode =  (GroupingNode*)[self findNodeWithId:objId :nodes];
					
					if(!currNode)
						currNode = [[GroupingNode alloc] init];		
					
					[currNode setId:objId];
					[nodes addObject:currNode];
				}
				//if node isn't parent node.
				else 
				{
					ConceptNode *currNode =  (ConceptNode*)[self findNodeWithId:objId :nodes];
					
					if(!currNode)
						currNode = [[ConceptNode alloc] init];

					[currNode setId:objId];
					[currNode setLabel:objLabel];	
					[nodes addObject:currNode];
				}
				
				Node* currNode = [nodes lastObject];
				
				//check to see if parent node exists.
				GroupingNode *currParentNode = (GroupingNode*)[self findNodeWithId:nodeParentId :nodes];
				
				//if parent node doesn't exist, create.
				if(!currParentNode)
					currParentNode = [[GroupingNode alloc] init];
					
				[currParentNode addChild:currNode];
				[currNode setParent:currParentNode];
			}	
			//if node doesn't have parent node. 
			else if([scanner scanString:labelTag intoString:NULL] && 
					[scanner  scanUpToCharactersFromSet:endQuote intoString:&objLabel] && 
					[scanner scanString:@"\"" intoString:NULL] &&
					[scanner scanString:endTag intoString:NULL])
			{
				//if node is parent node itself.
				if([objLabel compare:noLabel] == NSOrderedSame)
				{
					GroupingNode *currNode =  (GroupingNode*)[self findNodeWithId:objId :nodes];
					
					if(!currNode)
						currNode = [[GroupingNode alloc] init];		
					
					[currNode setId:objId];
					[nodes addObject:currNode];
				}
				//if node isn't parent node.
				else 
				{
					ConceptNode *currNode =  (ConceptNode*)[self findNodeWithId:objId :nodes];
					
					if(!currNode)
						currNode = [[ConceptNode alloc] init];
					
					[currNode setId:objId];
					[currNode setLabel:objLabel];	
					[nodes addObject:currNode];
				}
				
				Node* currNode = [nodes lastObject];
			}*/
		}
		//if scanned a relation, create relation with information
		else if([scanner scanString:linkingPhrase intoString:NULL])
		{
			//NSLog(@"scanning linking phrase");
			[scanner scanUpToCharactersFromSet:newlineCharSet intoString:&currLine];
			currLine = [currLine stringByDecodingXMLEntities];

			objId = [self getAttributeValue:idTag :currLine];
			objLabel = [self getAttributeValue:labelTag :currLine];
			Connection* currLink;
			
			if([objLabel compare:noLabel] == NSOrderedSame)
			{
				currLink = [[Connection alloc] init];
			}
			else
			{
				currLink = [[Relation alloc] init];
				[(Relation*)currLink setLabel:objLabel];
			}		
			[currLink setConnectionId:objId];
			[relations addObject:currLink];
		}
		//list of connections.
		else if([scanner scanString:connection intoString:NULL])
		{
			//NSLog(@"scanning connection");
			[scanner scanUpToCharactersFromSet:newlineCharSet intoString:&currLine];
			currLine = [currLine stringByDecodingXMLEntities];
			
			objId = [self getAttributeValue:idTag :currLine];
			fromId = [self getAttributeValue:fromIdTag :currLine];
			toId = [self getAttributeValue:toIdTag :currLine];
			
			NSObject* fromObj = nil;
			NSObject* toObj = nil;
			
			//go through nodes and links and find which objects are connected.
			for(Node *n in nodes)
			{
				if([[n nodeId] compare:fromId] == NSOrderedSame)
					fromObj = n;
				else if([[n nodeId] compare:toId] == NSOrderedSame)
					toObj = n;
			}
			
			//if both to and from are concepts, then create a link connecting both concepts
			if(fromObj  != nil && toObj != nil)
			{
				//NSLog(@"both from and to are nodes");
				Connection* newlink = [[Connection alloc] init];
				[newlink setConnectionId:objId];
				//NSLog(@"before adding objects");
				[newlink addObject:fromObj];
				[newlink addObject:toObj];
				//NSLog(@"after adding objects");
				[relations addObject:newlink];
			}
			else
			{
				//NSLog(@"at least one object is not a node");
				for(Connection *r in relations)
				{
					if([[r connectionId] compare:fromId] == NSOrderedSame)
						fromObj = r;
					if([[r connectionId] compare:toId] == NSOrderedSame)
						toObj = r;
				}

				//if fromId is a link or relation.
				if([fromObj class] == [Relation class] || [fromObj class] == [Connection class])
					[(Connection*)fromObj addObject:toObj];
				else
					[(Connection*)toObj addObject:fromObj];				
			}
			
			/*Link *currLink = [[Link alloc] init];
			[currLink setId:objId];
			
			for(Link *r in relations)
			{
				NSString *currRelationId = [r linkId];
				if([currRelationId compare:fromId] == NSOrderedSame ||[currRelationId compare:toId] == NSOrderedSame)
				{
					[currLink addObject:r];
				}
			}

			for(Node *n in nodes)
			{
				NSString *currNodeId = [n nodeId];
				if([currNodeId compare:fromId] == NSOrderedSame ||[currNodeId compare:toId] == NSOrderedSame)
				{
					[currLink addObject:n];
				}
			}
						
			[links addObject:currLink];*/
		}		
		//concept appearance
		else if([scanner scanString:conceptAppearance intoString:NULL]) 
		{
			//NSLog(@"scanning concept appearance");
			[scanner scanUpToCharactersFromSet:newlineCharSet intoString:&currLine];
			currLine = [currLine stringByDecodingXMLEntities];
			
			objId = [self getAttributeValue:idTag :currLine];
            imageId = [self getAttributeValue:imageTag :currLine];
			x = [[self getAttributeValue:conceptXTag :currLine] floatValue];
			y = [[self getAttributeValue:conceptYTag :currLine] floatValue];
			width = [[self getAttributeValue:conceptWidthTag :currLine] floatValue];
			height = [[self getAttributeValue:conceptHeightTag :currLine] floatValue]; 
			backgroundColor = [self getAttributeValue:backgroundColorTag :currLine];
			UIColor* nodeColor;
			
            if(backgroundColor != nil)
			{
				NSArray *colors = [backgroundColor componentsSeparatedByCharactersInSet:comma];
				CGFloat red = [[colors objectAtIndex:0] floatValue] / 255.0;
				CGFloat green = [[colors objectAtIndex:1] floatValue] / 255.0; 
				CGFloat blue = [[colors objectAtIndex:2] floatValue] / 255.0; 
				CGFloat alpha = [[colors objectAtIndex:3] floatValue] / 255.0;
                nodeColor=[UIColor colorWithRed:red green:green blue:blue alpha:alpha];
			}
			else
				
            nodeColor= [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
			
			for(Node *n in nodes)
			 {
				 NSString *currNodeId = [n nodeId];
				 
				 if([currNodeId compare:objId] == NSOrderedSame)
				 {
					 if([n class] == [ConceptNode class])
					 { 
                         ConceptNode* cNode = (ConceptNode*) n;
                         
                         if([imageId compare:@""] == NSOrderedSame) {
                             
                             NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:12], NSFontAttributeName,[UIColor blackColor], NSForegroundColorAttributeName, nil];
                             NSAttributedString * currentText=[[NSAttributedString alloc] initWithString:[(ConceptNode*)n label] attributes: attributes];
                             CGSize attrSize = [currentText size];
					 		 
                             if(attrSize.width + 10 > width)
                                 width = attrSize.width + 10;

                             if(attrSize.height + 10 > height)
                                 height = attrSize.height + 10;
                         }
                         else {
                             [cNode setImageId:imageId];
                             NSLog(@"image id: %@", imageId);    
                         }
					 }
						 
					 CGSize nodeSize = CGSizeMake(width, height);
					 
					 //scale location based on size of the screen.
					 //NSPoint nodelocation = NSMakePoint(viewSize.width - (x * widthRatio),viewSize.height - (y * heightRatio));
					 CGPoint nodelocation;
					 if(cmapLargerThanView)
						 nodelocation = CGPointMake(x,y);
					 else
						 nodelocation = CGPointMake(x * widthRatio, y * heightRatio);
					 //NSPoint nodelocation = NSMakePoint((x * widthRatio), viewSize.height - (y * heightRatio));
					 
					 [n setSize:nodeSize];
					 [n setLocation:nodelocation];
					 [n setColor:nodeColor];
					 
					 printf("size: (%f, %f) location: (%f, %f)\n", [n size].width, [n size].height, [n location].x, [n location].y);
				 }
			 }
		}
		//image list with byte information.
        else if([scanner scanString:image intoString:NULL]) 
        {
            [scanner scanUpToCharactersFromSet:newlineCharSet intoString:&currLine];
			currLine = [currLine stringByDecodingXMLEntities];
			
			imageId = [self getAttributeValue:idTag :currLine];
            imageBytes = [self getAttributeValue:imageByteTag :currLine];

            for(Node *n in nodes)
            {
                if([n class] == [ConceptNode class])
                {
                    ConceptNode* cNode = (ConceptNode*)n;
                    
                    if([[cNode imageId] compare:imageId] == NSOrderedSame)   
                    {
                        
                        //NSLog(@"image bytes: %@", imageBytes);
                        
                        //NSData* imageByteData = [imageBytes dataUsingEncoding:NSUTF8StringEncoding];
                        Base64* decoder = [[Base64 alloc] init];
                        NSData* imageByteData = [decoder decodeBase64WithString:imageBytes];
                        UIImage* image = [[UIImage alloc] initWithData:imageByteData];
                        [cNode setImage:image];
                    }
                }
            }
        }
		//relation appearance
		else if([scanner scanString:relationAppearance intoString:NULL]) 
		{
			//NSLog(@"scanning relation appearance");
			[scanner scanUpToCharactersFromSet:newlineCharSet intoString:&currLine];
			currLine = [currLine stringByDecodingXMLEntities];
			
			objId = [self getAttributeValue:idTag :currLine];			
			x = [[self getAttributeValue:conceptXTag :currLine] floatValue];
			y = [[self getAttributeValue:conceptYTag :currLine] floatValue];
			width = [[self getAttributeValue:conceptWidthTag :currLine] floatValue];
			height = [[self getAttributeValue:conceptHeightTag :currLine] floatValue]; 
			
			for(Connection *r in relations)
			{
				NSString *currRelationId = [r connectionId];
				if([currRelationId compare:objId] == NSOrderedSame)
				{	
					//scale location based on size of the screen
					//NSPoint relationlocation = NSMakePoint(viewSize.width - (x * widthRatio),viewSize.height - (y * heightRatio));
					CGPoint relationlocation;
					
					if(cmapLargerThanView)
						relationlocation = CGPointMake(x, y);
					else
						relationlocation = CGPointMake((x * widthRatio),(y * heightRatio));
					
					//NSPoint relationlocation = NSMakePoint((x * widthRatio), viewSize.height - (y * heightRatio));
					[r setLocation:relationlocation];
					[r setRecalculatePos:FALSE];
					
					printf("location: (%f, %f)\n", [r location].x, [r location].y);
				}
				
			}
		}		
		//scan up to > until reach something we're interested in.
		else
		{
			[scanner scanUpToCharactersFromSet:newlineCharSet intoString:&currLine];
			//NSLog(@"scanned line: @%", &currLine);
			//NSLog(currLine);
		}
	}
	
	//NSLog(@"finished parsing");
	
	//go through relations and add all links to that relation
	/*for(Link* r in relations)
	{
		Relation* linkRelation;
		NSLog(@"going through relations");
		
		for(Link* currLink in links)
		{
			if ([[[currLink linkedObjects] objectAtIndex:0] class] == [Relation class])
			{
				linkRelation= (Relation*) [[currLink linkedObjects] objectAtIndex:0];

				if([[r linkId] compare:[linkRelation linkId]] == NSOrderedSame)
					[r addObject: [[currLink linkedObjects] objectAtIndex:1]];
			}
			else if ([[[currLink linkedObjects] objectAtIndex:1] class] == [Relation class])
			{
				linkRelation= (Relation*) [[currLink linkedObjects] objectAtIndex:1];

				if([[r linkId] compare:[linkRelation linkId]] == NSOrderedSame)
					[r addObject: [[currLink linkedObjects] objectAtIndex:0]];
			}
			//else
			//{
			//	linkRelation = [[Link alloc] init];
			//	[linkRelation setId:[currLink linkId]];
			//	[linkRelation addObject:[[currLink linkedObjects] objectAtIndex:0]];
			//	[linkRelation addObject:[[currLink linkedObjects] objectAtIndex:1]];
			//}
			
			
			//NSLog(@"after if/else");
			//NSLog(@"link relation class: %@", [linkRelation class]);
			
	
			//if([[r relationId] compare:[linkRelation relationId]] == NSOrderedSame)
			//	[r addNode: [[currLink linkedObjects] objectAtIndex:1]];
		}
	}

	NSLog(@"link size: %d", [links count]);
	//go through links and see which links connect 2 nodes. 
	for(Link* link in links)
	{
		//NSMutableArray* linkedObjects = [link linkedObjects];	
		
		//NSLog(@"linked Objects size: %d", [linkedObjects count]);
		//NSLog(@"linked objects 1 class: %@", [[linkedObjects objectAtIndex:0] class]);
		//NSLog(@"linked objects 2 class: %@", [[linkedObjects objectAtIndex:1] class]);
		
		if ([[[link linkedObjects] objectAtIndex:0] class] == [ConceptNode class] && 
			[[[link linkedObjects] objectAtIndex:1] class] == [ConceptNode class])
		{
			NSLog(@"this link is between two nodes");
			Link *rel = [[Link alloc] init];
			
			for(Node* node in nodes)
			{
				if([[[[link linkedObjects] objectAtIndex:0] nodeId] compare:[node nodeId]] == NSOrderedSame ||
					[[[[link linkedObjects] objectAtIndex:1] nodeId] compare:[node nodeId]] == NSOrderedSame)
				{
					[rel addObject:node];
					[rel setRecalculatePos:TRUE];
				}
			}
			
			[relations addObject:rel];
			
			NSLog(@"this link is between nodes: %@ and %@", [[[link linkedObjects] objectAtIndex:0] nodeId],  [[[link linkedObjects] objectAtIndex:1] nodeId]);
		}
	}*/
	
	//Pass nodes and relations back to view for display.
	[nodesAndRelations addObject:nodes];
	[nodesAndRelations addObject:relations];
	
	//NSLog(@"returning from import function:");
	
	/*for(Relation* r in relations)
	{
		NSLog(@"relation: %@ between", [r label]);
		for(ConceptNode* n in [r connectedNodes])
		{
			NSLog(@"node: %@", [n label]);	
		}
	}*/
	
	return nodesAndRelations;
}

/**
 * Parses a line imported from a cxl file and finds the value of an 
 * xml attribute with the give tag.
 @param tag The tag of the attribute being searched for.
 @param currLine The line to parse.
 @returns The value of the attribute with the given tag.
 */
-(NSString*) getAttributeValue:(NSString*) tag :(NSString*)currLine{
	NSRange range = [currLine rangeOfString:tag];
	
	if(range.length > 0)
	{
		NSRange searchRange = NSMakeRange(range.location + range.length, [currLine length] - (range.location + range.length));
		NSRange range2 = [currLine rangeOfString:@"\"" options:0 range:searchRange];
		NSRange	range3 = NSMakeRange((range.location + range.length), range2.location - (range.location + range.length));
		return [currLine substringWithRange:range3];
	}
	
	return NULL;
}

/* old semi-working version
-(NSMutableArray*) importCmapFromFile:(NSString*) fileName :(NSSize)viewSize{
	//printf("Importing cmap from file: %s\n", fileName);
	NSLog(@"Importing cmap from file: %@", fileName);
	
	//Create the nodes and relations data structures.
	NSMutableArray *nodesAndRelations = [[NSMutableArray alloc] init];
	NSMutableArray *nodes = [[NSMutableArray alloc] init];
	NSMutableArray *relations = [[NSMutableArray alloc] init];
	NSMutableArray *links = [[NSMutableArray alloc] init];
	
	//Get the file contents
	NSString *fileInput = [NSString stringWithContentsOfFile:fileName];
	//NSLog(fileInput);
	
	//parse the clx file to get the nodes and relations
	NSScanner *scanner = [NSScanner scannerWithString:fileInput];
	
	NSString* map = @"<map ";
	NSString* concept = @"<concept ";
	//NSCharacterSet *closeTag = [NSCharacterSet characterSetWithCharactersInString:@">"];
	NSCharacterSet *endLine = [NSCharacterSet characterSetWithCharactersInString:@"\n"];
	NSString* endTag = @"/>";
	NSString* idTag = @"id=\"";
	NSCharacterSet *endQuote = [NSCharacterSet characterSetWithCharactersInString:@"\""];
	NSString* labelTag = @"label=\"";
    NSString* imageTag = @"image=\"";
	NSString* linkingPhrase = @"<linking-phrase ";
	NSString* connection = @"<connection ";
	NSString* fromIdTag = @"from-id=\"";
	NSString* toIdTag = @"to-id=\"";
	NSString* conceptAppearance = @"<concept-appearance ";
	NSString* relationAppearance = @"<linking-phrase-appearance ";
	NSString* conceptWidthTag = @"width=\"";
	NSString* conceptHeightTag = @"height=\"";
	NSString* conceptXTag = @"x=\"";
	NSString* conceptYTag = @"y=\"";
	//NSString* parentidTag = @"parent-id=\"";
	NSString* noLabel = @"????";
	
	NSString *objId = @"";
    NSString* objImage = @"";
	NSString *fromId = @"";
	NSString *toId = @"";
	NSString *objLabel = @"";
	NSString *nodeParentId = @"";
	CGFloat x, y, width, height, mapWidth, mapHeight, widthRatio = 0, heightRatio = 0; 
	
	//change scanner to be more dynamic so it doesn't explode when there's information it doesn't need. 
	while ([scanner isAtEnd] == NO)
	{
		if([scanner scanString:map intoString:NULL] && 
		   [scanner scanString:conceptWidthTag intoString:NULL] &&
		   [scanner scanDouble:&mapWidth] &&
		   [scanner scanString:@"\" " intoString:NULL] && 	
		   [scanner scanString:conceptHeightTag intoString:NULL] && 
		   [scanner scanDouble:&mapHeight])
		{
			//NSLog(@"cmap width: %f height: %f", mapWidth, mapHeight);
			
			widthRatio = viewSize.width/mapWidth;
			heightRatio = viewSize.height/mapHeight;
			
			//NSLog(@"widthRatio: %f heightRatio: %f", widthRatio, heightRatio);
		}
		//If scanned in a node, create node with information
		else if([scanner scanString:concept intoString:NULL] && 
				[scanner scanString:idTag intoString:NULL] &&
				[scanner scanUpToCharactersFromSet:endQuote intoString:&objId] &&
				[scanner scanString:@"\" " intoString:NULL])
		{
			//if node has parent node.
			if([scanner scanString:nodeParentId intoString:NULL] && 
			   [scanner  scanUpToCharactersFromSet:endQuote intoString:&objLabel] && 
			   [scanner scanString:@"\"" intoString:NULL] &&
			   [scanner scanString:labelTag intoString:NULL] && 
			   [scanner  scanUpToCharactersFromSet:endQuote intoString:&objLabel] && 
			   [scanner scanString:@"\"" intoString:NULL] &&
			   [scanner scanString:endTag intoString:NULL])
			{
				//if node is parent node itself.
				if([objLabel compare:noLabel] == NSOrderedSame)
				{
					GroupingNode *currNode =  (GroupingNode*)[self findNodeWithId:objId :nodes];
					
					if(!currNode)
						currNode = [[GroupingNode alloc] init];		
					
					[currNode setId:objId];
					[nodes addObject:currNode];
				}
				//if node isn't parent node.
				else 
				{
					ConceptNode *currNode =  (ConceptNode*)[self findNodeWithId:objId :nodes];
					
					if(!currNode)
						currNode = [[ConceptNode alloc] init];
					
					[currNode setId:objId];
					[currNode setLabel:objLabel];	
					[nodes addObject:currNode];
				}
				
				Node* currNode = [nodes lastObject];
				
				//check to see if parent node exists.
				GroupingNode *currParentNode = (GroupingNode*)[self findNodeWithId:nodeParentId :nodes];
				
				//if parent node doesn't exist, create.
				if(!currParentNode)
					currParentNode = [[GroupingNode alloc] init];
				
				[currParentNode addChild:currNode];
				[currNode setParent:currParentNode];
				
			}	
			//if node doesn't have parent node. 
			else if([scanner scanString:labelTag intoString:NULL] && 
					[scanner  scanUpToCharactersFromSet:endQuote intoString:&objLabel] && 
					[scanner scanString:@"\"" intoString:NULL] &&
					[scanner scanString:endTag intoString:NULL])
			{
				//if node is parent node itself.
				if([objLabel compare:noLabel] == NSOrderedSame)
				{
					GroupingNode *currNode =  (GroupingNode*)[self findNodeWithId:objId :nodes];
					
					if(!currNode)
						currNode = [[GroupingNode alloc] init];		
					
					[currNode setId:objId];
					[nodes addObject:currNode];
				}
				//if node isn't parent node.
				else 
				{
					ConceptNode *currNode =  (ConceptNode*)[self findNodeWithId:objId :nodes];
					
					if(!currNode)
						currNode = [[ConceptNode alloc] init];
					
					[currNode setId:objId];
					[currNode setLabel:objLabel];	
					[nodes addObject:currNode];
				}
				
				Node* currNode = [nodes lastObject];
				
			}
		}
		//if scanned a relation, create relation with information
		else if([scanner scanString:linkingPhrase intoString:NULL] && 
				[scanner scanString:idTag intoString:NULL] &&
				[scanner scanUpToCharactersFromSet:endQuote intoString:&objId] &&
				[scanner scanString:@"\" " intoString:NULL] && 	
				[scanner scanString:labelTag intoString:NULL] && 
				[scanner scanUpToCharactersFromSet:endQuote intoString:&objLabel] && 
				[scanner scanString:@"\"" intoString:NULL] &&
				[scanner scanString:endTag intoString:NULL])
		{
			Relation *currRelation = [[Relation alloc] init];
			[currRelation setId:objId];
			[currRelation setLabel:objLabel];
			[relations addObject:currRelation];
			
		}
		//connections between nodes.
		else if([scanner scanString:connection intoString:NULL] && 
				[scanner scanString:idTag intoString:NULL] &&
				[scanner scanUpToCharactersFromSet:endQuote intoString:&objId] &&
				[scanner scanString:@"\" " intoString:NULL] && 	
				[scanner scanString:fromIdTag intoString:NULL] && 
				[scanner scanUpToCharactersFromSet:endQuote intoString:&fromId] && 
				[scanner scanString:@"\" " intoString:NULL] && 	
				[scanner scanString:toIdTag intoString:NULL] && 
				[scanner scanUpToCharactersFromSet:endQuote intoString:&toId] && 
				[scanner scanString:@"\"" intoString:NULL] &&
				[scanner scanString:endTag intoString:NULL])
		{
			//connections in cmap tools is between node and relation or 2 nodes. so need to make one relation out of multiple connections.
			//also need figure out what's a link and what's a relation.
			//instead we create links for everything when we read in and then go back to fix the relations.
			
			Link *currLink = [[Link alloc] init];
			[currLink setId:objId];
			
			for(Relation *r in relations)
			{
				NSString *currRelationId = [r relationId];
				if([currRelationId compare:fromId] == NSOrderedSame ||[currRelationId compare:toId] == NSOrderedSame)
				{
					[currLink addObject:r];
				}
			}
			
			for(Node *n in nodes)
			{
				NSString *currNodeId = [n nodeId];
				if([currNodeId compare:fromId] == NSOrderedSame ||[currNodeId compare:toId] == NSOrderedSame)
				{
					[currLink addObject:n];
				}
			}
			
			[links addObject:currLink];
			
			//NSLog(@"new link id:");
			//NSLog([currLink linkId]);
		}		
		//concept appearance
		else if([scanner scanString:conceptAppearance intoString:NULL] && 
				[scanner scanString:idTag intoString:NULL] &&
				[scanner scanUpToCharactersFromSet:endQuote intoString:&objId] &&
				[scanner scanString:@"\" " intoString:NULL] && 	
				[scanner scanString:conceptXTag intoString:NULL] && 
				[scanner scanFloat:&x] &&
				[scanner scanString:@"\" " intoString:NULL] && 	
				[scanner scanString:conceptYTag intoString:NULL] &&
				[scanner scanFloat:&y] &&
				[scanner scanString:@"\" " intoString:NULL] && 	
				[scanner scanString:conceptWidthTag intoString:NULL] && 
				[scanner scanFloat:&width] &&
				[scanner scanString:@"\" " intoString:NULL] && 	
				[scanner scanString:conceptHeightTag intoString:NULL] && 
				[scanner scanFloat:&height] &&
				[scanner scanString:@"\"" intoString:NULL] &&
				[scanner scanString:endTag intoString:NULL])
		{
			for(Node *n in nodes)
			{
				NSString *currNodeId = [n nodeId];
				if([currNodeId compare:objId] == NSOrderedSame)
				{
					NSSize nodeSize = NSMakeSize(width, height);
					
					//scale location based on size of the screen.
					//NSPoint nodelocation = NSMakePoint(viewSize.width - (x * widthRatio),viewSize.height - (y * heightRatio));
					NSPoint nodelocation = NSMakePoint(x * widthRatio, y * heightRatio);
					//NSPoint nodelocation = NSMakePoint((x * widthRatio), viewSize.height - (y * heightRatio));
					[n setSize:nodeSize];
					[n setLocation:nodelocation];
					
					//printf("size: (%f, %f) location: (%f, %f)\n", [n size].width, [n size].height, [n location].x, [n location].y);
				}
			}
		}		
		//relation appearance
		else if([scanner scanString:relationAppearance intoString:NULL] && 
				[scanner scanString:idTag intoString:NULL] &&
				[scanner scanUpToCharactersFromSet:endQuote intoString:&objId] &&
				[scanner scanString:@"\" " intoString:NULL] && 	
				[scanner scanString:conceptXTag intoString:NULL] && 
				[scanner scanFloat:&x] &&
				[scanner scanString:@"\" " intoString:NULL] && 	
				[scanner scanString:conceptYTag intoString:NULL] &&
				[scanner scanFloat:&y] &&
				[scanner scanString:@"\" " intoString:NULL] && 	
				[scanner scanString:conceptWidthTag intoString:NULL] && 
				[scanner scanFloat:&width] &&
				[scanner scanString:@"\" " intoString:NULL] && 	
				[scanner scanString:conceptHeightTag intoString:NULL] && 
				[scanner scanFloat:&height] &&
				[scanner scanString:@"\"" intoString:NULL] &&
				[scanner scanString:endTag intoString:NULL])
		{
			for(Relation *r in relations)
			{
				NSString *currRelationId = [r relationId];
				if([currRelationId compare:objId] == NSOrderedSame)
				{
					//scale location based on size of the screen
					//NSPoint relationlocation = NSMakePoint(viewSize.width - (x * widthRatio),viewSize.height - (y * heightRatio));
					NSPoint relationlocation = NSMakePoint((x * widthRatio),(y * heightRatio));
					//NSPoint relationlocation = NSMakePoint((x * widthRatio), viewSize.height - (y * heightRatio));
					[r setLocation:relationlocation];
					
					//printf("location: (%f, %f)\n", [r location].x, [r location].y);
				}
				
			}
			
			for(Node *n in nodes)
			{
				NSString *currNodeId = [n nodeId];
				if([currNodeId compare:objId] == NSOrderedSame)
				{
					NSSize nodeSize = NSMakeSize(width, height);
					//NSPoint nodelocation = NSMakePoint(viewSize.width - (x * widthRatio),viewSize.height - (y * heightRatio));
					NSPoint nodelocation = NSMakePoint((x * widthRatio), (y * heightRatio));
					//NSPoint nodelocation = NSMakePoint((x * widthRatio), viewSize.height - (y * heightRatio));
					[n setSize:nodeSize];
					[n setLocation:nodelocation];
					
					//printf("size: (%f, %f) location: (%f, %f)\n", [n size].width, [n size].height, [n location].x, [n location].y);
				}
			}
		}		
		//scan up to > until reach something we're interested in.
		else
		{
			NSString* tempString = @"";
			//[scanner scanUpToCharactersFromSet:closeTag intoString:&tempString];
			[scanner scanUpToCharactersFromSet:endLine intoString:&tempString];
			NSLog(@"scanned line: @%", &tempString);
			NSLog(tempString);
		}
	}
	
	NSLog(@"finished parsing");
	
	//go through relations and add all links to that relation
	for(Relation* r in relations)
	{
		Relation* linkRelation;
		NSLog(@"going through relations");
		
		for(Link* currLink in links)
		{
			NSMutableArray* linkedObjects = [currLink linkedObjects];
			
			//NSLog(@"linked Objects size: %d", [linkedObjects count]);
			//NSLog(@"linked objects 1 class: %@", [[[currLink linkedObjects] objectAtIndex:0] class]);
			//NSLog(@"linked objects 2 class: %@", [[[currLink linkedObjects] objectAtIndex:1] class]);
			
			if ([[[currLink linkedObjects] objectAtIndex:0] class] == [Relation class])
			{
				linkRelation= (Relation*) [[currLink linkedObjects] objectAtIndex:0];
				
				if([[r relationId] compare:[linkRelation relationId]] == NSOrderedSame)
					[r addNode: [[currLink linkedObjects] objectAtIndex:1]];
			}
			else if ([[[currLink linkedObjects] objectAtIndex:1] class] == [Relation class])
			{
				linkRelation= (Relation*) [[currLink linkedObjects] objectAtIndex:1];
				
				if([[r relationId] compare:[linkRelation relationId]] == NSOrderedSame)
					[r addNode: [[currLink linkedObjects] objectAtIndex:0]];
			}
		}
	}
	
	NSLog(@"link size: %d", [links count]);
	//go through links and see which links connect 2 nodes. 
	for(Link* link in links)
	{
		//NSMutableArray* linkedObjects = [link linkedObjects];
		
		//NSLog(@"linked Objects size: %d", [linkedObjects count]);
		//NSLog(@"linked objects 1 class: %@", [[linkedObjects objectAtIndex:0] class]);
		//NSLog(@"linked objects 2 class: %@", [[linkedObjects objectAtIndex:1] class]);
		
		if ([[[link linkedObjects] objectAtIndex:0] class] == [ConceptNode class] && 
			[[[link linkedObjects] objectAtIndex:1] class] == [ConceptNode class])
		{
			NSLog(@"this link is between two nodes");
			Relation *rel = [[Relation alloc] init];
			
			for(Node* node in nodes)
			{
				if([[[[link linkedObjects] objectAtIndex:0] nodeId] compare:[node nodeId]] == NSOrderedSame ||
				   [[[[link linkedObjects] objectAtIndex:1] nodeId] compare:[node nodeId]] == NSOrderedSame)
				{
					[rel addNode:node];
					[rel setRecalculatePos:TRUE];
				}
			}
			
			[relations addObject:rel];
			
			//NSLog(@"this link is between nodes: %@ and %@", [[[link linkedObjects] objectAtIndex:0] nodeId],  [[[link linkedObjects] objectAtIndex:1] nodeId]);
		}
	}
	
	//Pass nodes and relations back to view for display.
	[nodesAndRelations addObject:nodes];
	[nodesAndRelations addObject:relations];
	
	
	return nodesAndRelations;
}*/

/**
 * Exports a concept map to a cxl file with the given fileName.
 @param fileName The filename of the file to export the concept map to.
 @param nodesAndRelations An array of the Node objects and Relation / Connection objects for this concept map.
 * The array is of size 2 and holds 2 more arrays. One of these holds the Node objects. The other holds the 
 * Relation / Connection objects. 
 @param mapSize The size of the concept map (the size of the CmapView currently).
 */
-(void) exportCmapToFile:(NSString*) fileName :(NSMutableArray*)nodesAndRelations :(CGSize)mapSize{
	NSLog(@"Exporting cmap to file: %@", fileName);
	
	NSMutableArray *nodes = [nodesAndRelations objectAtIndex:0];
	NSMutableArray *relations = [nodesAndRelations objectAtIndex:1];
	
	NSString* output = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
	output = [output stringByAppendingString:@"<cmap xmlns=\"http://cmap.ihmc.us/xml/cmap/\"\n\t"];
	output = [output stringByAppendingString:@"xmlns:dc=\"http://purl.org/dc/elements/1.1/\">\n\n\t"];
	output = [output stringByAppendingString:[NSString stringWithFormat:@"<map width=\"%d\" height=\"%d\">\n\t\t",(int) mapSize.width, (int) mapSize.height]];
	output = [output stringByAppendingString:@"<concept-list>\n\t\t"];
	
	//add concepts to file.
	for(Node *n in nodes)
	{
		NSString *conceptId = [n nodeId];
		NSString *conceptString = @"\t<concept id=\"";
		
		if([conceptId compare:@""] == NSOrderedSame)
			conceptId = [NSString stringWithFormat:@"%d", [nodes indexOfObject:n] + 1];
		
		conceptString = [conceptString stringByAppendingString:conceptId];
            
        if([n class] == [ConceptNode class])
        {
            ConceptNode* conceptN = (ConceptNode*) n;
            
            conceptString = [conceptString stringByAppendingString:@"\" label=\""];
            conceptString = [conceptString stringByAppendingString:[[conceptN label] stringByEncodingXMLEntities]];
            
            if([conceptN image] )
            {
                conceptString = [conceptString stringByAppendingString:@"\" background-image=\""];
                conceptString = [conceptString stringByAppendingString:[(ConceptNode*)n imageId]];
            }
        }
        else if([n class] == [GroupingNode class])
        {
            
        }
        
        conceptString = [conceptString stringByAppendingString:@"\"/>\n\t\t"];
		output = [output stringByAppendingString:conceptString];
	}
	
	output = [output stringByAppendingString:@"</concept-list>\n\t\t"];
	output = [output stringByAppendingString:@"<linking-phrase-list>\n\t\t"];
	
	//add relations to file.	
	for(Connection *r in relations)
	{
		NSString *relationId = [r connectionId];
		NSString *relationString = @"\t<linking-phrase id=\"";
		
		if([relationId compare:@""] == NSOrderedSame)
			relationId = [NSString stringWithFormat:@"%d", [relations indexOfObject:r] + 1 + [nodes count]];
		
		relationString = [relationString stringByAppendingString:relationId];
		relationString = [relationString stringByAppendingString:@"\" label=\""];
		if([r class] == [Connection class])
			relationString = [relationString stringByAppendingString:@"????"];
		else if([[(Relation*)r label] compare:@""] == NSOrderedSame)
			relationString = [relationString stringByAppendingString:@"????"];
		else
			relationString = [relationString stringByAppendingString:[[(Relation*)r label] stringByEncodingXMLEntities]];
		relationString = [relationString stringByAppendingString:@"\"/>\n\t\t"];		
		output = [output stringByAppendingString:relationString];
	}
	
	output = [output stringByAppendingString:@"</linking-phrase-list>\n\t\t"];
	output = [output stringByAppendingString:@"<connection-list>\n\t\t"];
	
	int connectionId = (int)[relations count] + (int)[nodes count] + 1;
	
	//add connections to file (relations as well as links.
	for(Connection *r in relations)
	{
		NSString *relationId = [r connectionId];
		NSMutableArray* connectedNodes = [r linkedObjects];
		
		for(Node* n in connectedNodes)
		{
			NSString* nodeId = [n nodeId];
			if([relationId compare:@""] == NSOrderedSame)
				relationId = [NSString stringWithFormat:@"%d", [relations indexOfObject:r] + 1 + [nodes count]];
			if([nodeId compare:@""] == NSOrderedSame)
				nodeId = [NSString stringWithFormat:@"%d", [nodes indexOfObject:n] + 1];
			NSString *relationString = [NSString stringWithFormat:@"\t<connection id=\"%d\" from-id=\"%@\" to-id=\"%@\"/>\n\t\t", connectionId, relationId, nodeId];
			output = [output stringByAppendingString:relationString];
			connectionId ++;
		}
		
		/*NSString* node1Id = [[connectedNodes objectAtIndex:0] nodeId];
		NSString* node2Id = [[connectedNodes objectAtIndex:1] nodeId];*/
		
		/*if([relationId compare:@""] == NSOrderedSame)
			relationId = [NSString stringWithFormat:@"%d", [relations indexOfObject:r] + 1 + [nodes count]];
		if([node1Id compare:@""] == NSOrderedSame)
			node1Id = [NSString stringWithFormat:@"%d", [nodes indexOfObject:[connectedNodes objectAtIndex:0]] + 1];
		if([node2Id compare:@""] == NSOrderedSame)
			node2Id = [NSString stringWithFormat:@"%d", [nodes indexOfObject:[connectedNodes objectAtIndex:1]] + 1];
		
		relationString = [relationString stringByAppendingString:node1Id];
		relationString = [relationString stringByAppendingString:@"\" to-id=\""];
		relationString = [relationString stringByAppendingString:relationId];
		relationString = [relationString stringByAppendingString:@"\"/>\n\t\t"];
		relationString = [relationString stringByAppendingString:@"\t<connection from-id=\""];
		relationString = [relationString stringByAppendingString:relationId];
		relationString = [relationString stringByAppendingString:@"\" to-id=\""];
		relationString = [relationString stringByAppendingString:node2Id];
		relationString = [relationString stringByAppendingString:@"\"/>\n\t\t"];*/
	}
	
	output = [output stringByAppendingString:@"</connection-list>\n\n\t\t"];
	output = [output stringByAppendingString:@"<concept-appearance-list>\n\t\t"];
	
	//add concept appearances to file. 
	for(Node *n in nodes)
	{
		NSString *conceptId = [n nodeId];
		NSString *conceptString = @"\t<concept-appearance id=\"";
		
		if([conceptId compare:@""] == NSOrderedSame)
			conceptId = [NSString stringWithFormat:@"%d", [nodes indexOfObject:n] + 1];
		
		conceptString = [conceptString stringByAppendingString:conceptId];
		conceptString = [conceptString stringByAppendingString:@"\" x=\""];
		conceptString = [conceptString stringByAppendingString:[NSString stringWithFormat:@"%d", (int)[n location].x]];
		conceptString = [conceptString stringByAppendingString:@"\" y=\""];
		conceptString = [conceptString stringByAppendingString:[NSString stringWithFormat:@"%d", (int)[n location].y]];
		conceptString = [conceptString stringByAppendingString:@"\" width=\""];
		conceptString = [conceptString stringByAppendingString:[NSString stringWithFormat:@"%d", (int)[n size].width]];
		conceptString = [conceptString stringByAppendingString:@"\" height=\""];
		conceptString = [conceptString stringByAppendingString:[NSString stringWithFormat:@"%d", (int)[n size].height]];
		conceptString = [conceptString stringByAppendingString:@"\" background-color=\""];
		//conceptString = [conceptString stringByAppendingString:[NSString stringWithFormat:@"%d,%d,%d,%d", (int)([[n color] redComponent] * 255.0), (int)([[n color] greenComponent] * 255.0),(int)([[n color] blueComponent] * 255.0),(int)([[n color] alphaComponent] * 255.0)]];
        
        CGColorRef colorRef = [ [n color] CGColor];
        int _countComponents = CGColorGetNumberOfComponents(colorRef);
        if (_countComponents == 4) {
            const CGFloat *_components = CGColorGetComponents(colorRef);
            CGFloat red     = _components[0];
            CGFloat green = _components[1];
            CGFloat blue   = _components[2];
            CGFloat alpha = _components[3];
            conceptString = [conceptString stringByAppendingString:[NSString stringWithFormat:@"%d,%d,%d,%d", (int)(red * 255.0), (int)(green * 255.0),(int)(blue * 255.0),(int)(alpha * 255.0)]];
        }
        
        
        
        
		conceptString = [conceptString stringByAppendingString:@"\"/>\n\t\t"];
		output = [output stringByAppendingString:conceptString];
	}
	
	output = [output stringByAppendingString:@"</concept-appearance-list>\n\t\t"];
	output = [output stringByAppendingString:@"<linking-phrase-appearance-list>\n\t\t"];

	//add relation appearances to file. 
	for(Connection *r in relations)
	{
		NSString *relationId = [r connectionId];
		NSString *relationString = @"\t<linking-phrase-appearance id=\"";
		CGPoint location = [r location];
		
		if([relationId compare:@""] == NSOrderedSame)
			relationId = [NSString stringWithFormat:@"%d", [relations indexOfObject:r] + 1 + [nodes count]];
		
		relationString = [relationString stringByAppendingString:relationId];
		relationString = [relationString stringByAppendingString:@"\" x=\""];
		relationString = [relationString stringByAppendingString:[NSString stringWithFormat:@"%d", (int)location.x]];
		relationString = [relationString stringByAppendingString:@"\" y=\""];
		relationString = [relationString stringByAppendingString:[NSString stringWithFormat:@"%d", (int)location.y]];
		relationString = [relationString stringByAppendingString:@"\"/>\n\t\t"];
		output = [output stringByAppendingString:relationString];
	}
	
	output = [output stringByAppendingString:@"</linking-phrase-appearance-list>\n\t"];
	
	//end tags
	output = [output stringByAppendingString:@"</map>\n"];
	output = [output stringByAppendingString:@"</cmap>\n"];
	
	//write string contents to file. 
	//need to figure out if there's a good way to do this.
	//output = [output stringByEncodingXMLEntities]; //doesn't work. cmap tools doesn't read the file if i export this way.  
	[output writeToFile:fileName atomically:YES encoding:4 error:NULL];
}

/**
 * Check to see if the most recently imported cmap is larger than the cmapView rect.
 @returns a boolean indicating whether or not the most recently imported cmap was larger than the cmapView rect.
 */
-(bool) isCmapLargerThanView
{
	return cmapLargerThanView;
}

/**
 * Get the size of the most recently imported cmap.
 @returns the size of the most recently imported cmap.
 */
-(CGRect) getCmapSize
{
	return cmapSize;
}

/**
 * Calculate the midpoint between multiple points.
 @param points The array of points for which to calculate the midpoint.
 @returns an NSPoint of the midpoint between all the points.
 */
-(CGPoint)calculateMidPoint:(NSMutableArray*)points {
	float midX, midY;
	Node* startNode = [points objectAtIndex:0];
	Node* endNode = [points objectAtIndex:1];
	
	CGPoint point1 = [startNode location];
	CGPoint point2 = [endNode location];
	
	if(point1.x < point2.x)
		midX = point1.x + ((point2.x - point1.x) / 2);
	else
		midX = point2.x + ((point1.x - point2.x) / 2);
	if(point1.y < point2.y)
		midY = point1.y + ((point2.y - point1.y) / 2);
	else
		midY = point2.y + ((point1.y - point2.y) / 2);
	
	return CGPointMake(midX, midY);
}

/**
 * Find the Node with the given id in the list of nodes.
 @param id The id of the Node to be found.
 @param nodes Array of Node objects. 
 @returns a reference to the Node object with the given id 
 * or null if it doesn't exist.
 */
-(Node*) findNodeWithId:(NSString*)id :(NSMutableArray*)nodes {
	for(Node *n in nodes)
	{
		NSString *nodeId = [n nodeId];
		if([nodeId compare:id] == NSOrderedSame)
		{
			return n;
		}
	}
	
	return NULL;
}

@end
