//
//  KnowledgeModel.m
//  Study
//
//  Created by Shang Wang on 3/20/19.
//  Copyright © 2019 Shang Wang. All rights reserved.
//

#import "KnowledgeModel.h"

@interface KnowledgeModel ()

@end

@implementation KnowledgeModel
@synthesize keyConceptsAry;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(NSMutableArray*) getKeyConceptLists{
    NSMutableArray* list= [[NSMutableArray alloc]init];
    
    KeyConcept* Endangered= [[KeyConcept alloc]initWithVariable:@"endangered spacies" Page:5 Subpage:1 Position: CGPointMake(415, 153)];
    KeyConcept* threatened= [[KeyConcept alloc]initWithVariable:@"threatened species" Page:5 Subpage:1 Position: CGPointMake(416, 212)];
    KeyConcept* HIPPO= [[KeyConcept alloc]initWithVariable:@"hippo" Page:16 Subpage:1 Position: CGPointMake(32, 366)];
    KeyConcept* instrumentalValue= [[KeyConcept alloc]initWithVariable:@"instrumental value" Page:12 Subpage:1 Position: CGPointMake(380, 290)];
    KeyConcept* habitatDestruction= [[KeyConcept alloc]initWithVariable:@"habitat destruction" Page:19 Subpage:1 Position: CGPointMake(306, 464)];
    KeyConcept* ecologicalService= [[KeyConcept alloc]initWithVariable:@"ecological service" Page:11 Subpage:1 Position: CGPointMake(178, 702)];
    KeyConcept* economicValue= [[KeyConcept alloc]initWithVariable:@"economic value" Page:12 Subpage:1 Position: CGPointMake(305, 333)];
    KeyConcept* biopholia= [[KeyConcept alloc]initWithVariable:@"biopholia" Page:13 Subpage:1 Position: CGPointMake(130, 675)];
    KeyConcept* intrinsicValue= [[KeyConcept alloc]initWithVariable:@"intrinsic value" Page:15 Subpage:1 Position: CGPointMake(252, 412)];
    KeyConcept* localExtinction= [[KeyConcept alloc]initWithVariable:@"local extinction" Page:4 Subpage:1 Position: CGPointMake(407, 393)];
    KeyConcept* ecologicaExtinction= [[KeyConcept alloc]initWithVariable:@"ecologica extinction" Page:4 Subpage:1 Position: CGPointMake(252, 451)];
    KeyConcept* invasiveSpecies= [[KeyConcept alloc]initWithVariable:@"invasive" Page:16 Subpage:1 Position: CGPointMake(133, 484)];
    KeyConcept* pollution= [[KeyConcept alloc]initWithVariable:@"pollution" Page:16 Subpage:1 Position: CGPointMake(299, 503)];
    KeyConcept* overHarvesting= [[KeyConcept alloc]initWithVariable:@"harvest" Page:16 Subpage:1 Position: CGPointMake(399, 502)];
    KeyConcept* population= [[KeyConcept alloc]initWithVariable:@"population" Page:16 Subpage:1 Position: CGPointMake(350, 484)];
    
    [list addObject:Endangered];
    [list addObject: threatened];
    [list addObject: HIPPO];
    [list addObject: instrumentalValue];
    [list addObject: habitatDestruction];
    [list addObject: ecologicalService];
    [list addObject: economicValue];
    [list addObject: biopholia];
    [list addObject: intrinsicValue];
    [list addObject: localExtinction];
    [list addObject: ecologicaExtinction];
    [list addObject: invasiveSpecies];
    [list addObject: pollution];
    [list addObject: overHarvesting];
    [list addObject: population];
    return list;
}

@end