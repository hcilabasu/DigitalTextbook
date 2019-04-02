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
    KeyConcept* Endangered= [[KeyConcept alloc]initWithVariable:@"endangered" Page:5 Subpage:1 Position: CGPointMake(415, 153)];
    KeyConcept* threatened= [[KeyConcept alloc]initWithVariable:@"threatened" Page:5 Subpage:1 Position: CGPointMake(416, 212)];
    KeyConcept* HIPPO= [[KeyConcept alloc]initWithVariable:@"hippo" Page:16 Subpage:1 Position: CGPointMake(32, 366)];
    KeyConcept* instrumentalValue= [[KeyConcept alloc]initWithVariable:@"instrumental" Page:12 Subpage:1 Position: CGPointMake(380, 290)];
    KeyConcept* habitatDestruction= [[KeyConcept alloc]initWithVariable:@"habitat" Page:19 Subpage:1 Position: CGPointMake(79, 270)];
    KeyConcept* ecologicalService= [[KeyConcept alloc]initWithVariable:@"ecological service" Page:11 Subpage:1 Position: CGPointMake(178, 702)];
    KeyConcept* economicValue= [[KeyConcept alloc]initWithVariable:@"economic value" Page:12 Subpage:1 Position: CGPointMake(305, 333)];
    KeyConcept* biopholia= [[KeyConcept alloc]initWithVariable:@"biopholia" Page:13 Subpage:1 Position: CGPointMake(130, 675)];
    KeyConcept* intrinsicValue= [[KeyConcept alloc]initWithVariable:@"intrinsic" Page:15 Subpage:1 Position: CGPointMake(252, 412)];
    KeyConcept* localExtinction= [[KeyConcept alloc]initWithVariable:@"local" Page:4 Subpage:1 Position: CGPointMake(407, 393)];
    KeyConcept* ecologicaExtinction= [[KeyConcept alloc]initWithVariable:@"ecological" Page:4 Subpage:1 Position: CGPointMake(252, 451)];
    KeyConcept* biologicalExtinction= [[KeyConcept alloc]initWithVariable:@"biological" Page:4 Subpage:1 Position: CGPointMake(382, 494)];
    KeyConcept* invasiveSpecies= [[KeyConcept alloc]initWithVariable:@"invasive" Page:16 Subpage:1 Position: CGPointMake(133, 484)];
    KeyConcept* pollution= [[KeyConcept alloc]initWithVariable:@"pollution" Page:16 Subpage:1 Position: CGPointMake(299, 503)];
    KeyConcept* overHarvesting= [[KeyConcept alloc]initWithVariable:@"harvest" Page:16 Subpage:1 Position: CGPointMake(399, 502)];
    KeyConcept* population= [[KeyConcept alloc]initWithVariable:@"population" Page:16 Subpage:1 Position: CGPointMake(350, 484)];
    
    ecologicalService.subName=@"ecological value";
    Endangered.conceptName=@"Endangered Species";
    threatened.conceptName=@"Threatened Species";
    instrumentalValue.conceptName=@"Instrumental Value";
    habitatDestruction.conceptName=@"Habitate Destruction";
    intrinsicValue.conceptName=@"Intrinsic Value";
    invasiveSpecies.conceptName=@"Invasive Species";
    overHarvesting.conceptName=@"Over Harvest";
    
    [list addObject: Endangered];
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
    [list addObject: biologicalExtinction];
    [list addObject: invasiveSpecies];
    [list addObject: pollution];
    [list addObject: overHarvesting];
    [list addObject: population];
    return list;
}



-(NSMutableArray*) getKeyLinkLists{
    NSMutableArray* list= [[NSMutableArray alloc]init];
    KeyLink* link1= [[KeyLink alloc] initWithNames:@"species" RightName:@"endangered"];
    KeyLink* link2= [[KeyLink alloc] initWithNames:@"species" RightName:@"threatened"];
    KeyLink* link3= [[KeyLink alloc] initWithNames:@"species" RightName:@"instrumental"];
    KeyLink* link4= [[KeyLink alloc] initWithNames:@"species" RightName:@"economic"];
    KeyLink* link5= [[KeyLink alloc] initWithNames:@"species" RightName:@"intrinsic"];
    KeyLink* link6= [[KeyLink alloc] initWithNames:@"extinction" RightName:@"local"];
    KeyLink* link7= [[KeyLink alloc] initWithNames:@"extinction" RightName:@"ecological"];
    KeyLink* link8= [[KeyLink alloc] initWithNames:@"extinction" RightName:@"biological"];
    KeyLink* link9= [[KeyLink alloc] initWithNames:@"HIPPO" RightName:@"harvest"];
    KeyLink* link10= [[KeyLink alloc] initWithNames:@"HIPPO" RightName:@"pollution"];
    KeyLink* link11= [[KeyLink alloc] initWithNames:@"HIPPO" RightName:@"population"];
    KeyLink* link12= [[KeyLink alloc] initWithNames:@"HIPPO" RightName:@"invasive"];
    KeyLink* link13= [[KeyLink alloc] initWithNames:@"HIPPO" RightName:@"habitat"];

    [list addObject: link1];
    [list addObject: link2];
    [list addObject: link3];
    [list addObject: link4];
    [list addObject: link5];
    [list addObject: link6];
    [list addObject: link7];
    [list addObject: link8];
    [list addObject: link9];
    [list addObject: link10];
    [list addObject: link11];
    [list addObject: link12];
    [list addObject: link13];
    return list;
    
}

@end
