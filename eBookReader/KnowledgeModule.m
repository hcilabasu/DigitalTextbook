//
//  KnowledgeModule.m
//  eBookReader
//
//  Created by Shang Wang on 4/24/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//

#import "KnowledgeModule.h"

@implementation KnowledgeModule
@synthesize conceptList;

-(id)init {
    NSLog(@"Knowledge Module init! \n");
    conceptList=[[NSMutableArray alloc] init];
    [self initConcept_Test];
    return self;
}


-(void)initConcept_Test
{
    Concept *cell=[[ Concept alloc] init];
    cell.conceptName=@"cell";
    cell.textBookDefinition=@"The cell is the basic structural and functional unit of all known living organisms. It is the smallest unit of life that is classified as a living thing and is often called the building block of life.";
    [conceptList addObject:cell];
    
    Concept *membrane=[[ Concept alloc] init];
    membrane.conceptName=@"membrane";
    membrane.textBookDefinition=@"A membrane is a thin, film-like structure that separates two fluids. It acts as a selective barrier, allowing some particles or chemicals to pass through, but not others. In some cases, especially in anatomy, membrane may refer to a thin film that is primarily a separating structure rather than a selective barrier.";
    [conceptList addObject:membrane];
    
    Concept *bacteria=[[ Concept alloc] init];
    bacteria.conceptName=@"bacteria";
    bacteria.textBookDefinition=@"Bacteria constitute a large domain of prokaryotic microorganisms. Typically a few micrometres in length, bacteria have a wide range of shapes, ranging from spheres to rods and spirals. ";
    [conceptList addObject:bacteria];
    
    Concept *environment=[[ Concept alloc] init];
    environment.conceptName=@"environmentr";
    environment.textBookDefinition=@"The biophysical environment is the biotic and abiotic surrounding of an organism, or population, and includes particularly the factors that have an influence in their survival, development and evolution.";
    [conceptList addObject:environment];

}

-(NSString *)getTextBookDefinition: (NSString *) m_conceptName
{
    NSString *textBookDefinition=@"Not able to find definition in textbook, try searching wikipedia and google.";
    for(Concept *c in conceptList){
        if( [c.conceptName isEqualToString:m_conceptName]){
            textBookDefinition=c.textBookDefinition;
        }
    }
    return textBookDefinition;
}

@end
