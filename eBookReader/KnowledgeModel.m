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
    KeyConcept* species= [[KeyConcept alloc]initWithVariable:@"species" Page:4 Subpage:1 Position: CGPointMake(38.5, 86)];
    KeyConcept* extinction= [[KeyConcept alloc]initWithVariable:@"extinction" Page:4 Subpage:1 Position: CGPointMake(229, 48.5)];
    KeyConcept* Endangered= [[KeyConcept alloc]initWithVariable:@"endanger" Page:4 Subpage:1 Position: CGPointMake(180, 422)];
    KeyConcept* threatened= [[KeyConcept alloc]initWithVariable:@"threaten" Page:4 Subpage:1 Position: CGPointMake(280.5, 505.5)];
    KeyConcept* HIPPO= [[KeyConcept alloc]initWithVariable:@"hippo" Page:15 Subpage:1 Position: CGPointMake(319.5, 453)];
    KeyConcept* instrumentalValue= [[KeyConcept alloc]initWithVariable:@"instrumental" Page:11 Subpage:1 Position: CGPointMake(112.5, 303.5)];
    KeyConcept* habitatDestruction= [[KeyConcept alloc]initWithVariable:@"habitat" Page:18 Subpage:1 Position: CGPointMake(367, 21)];
    KeyConcept* ecologicalService= [[KeyConcept alloc]initWithVariable:@"ecological service" Page:11 Subpage:1 Position: CGPointMake(185.5, 326.5)];
    KeyConcept* economicValue= [[KeyConcept alloc]initWithVariable:@"economic" Page:11 Subpage:1 Position: CGPointMake(189.5, 346.5)];
    KeyConcept* biopholia= [[KeyConcept alloc]initWithVariable:@"biopholia" Page:12 Subpage:1 Position: CGPointMake(44, 589.5)];
    KeyConcept* intrinsicValue= [[KeyConcept alloc]initWithVariable:@"intrinsic" Page:14 Subpage:1 Position: CGPointMake(363, 431.5)];
    KeyConcept* localExtinction= [[KeyConcept alloc]initWithVariable:@"local" Page:4 Subpage:1 Position: CGPointMake(497.5, 107)];
    KeyConcept* ecologicaExtinction= [[KeyConcept alloc]initWithVariable:@"ecological" Page:4 Subpage:1 Position: CGPointMake(138, 190)];
    KeyConcept* biologicalExtinction= [[KeyConcept alloc]initWithVariable:@"biological" Page:4 Subpage:1 Position: CGPointMake(381.5, 231)];
    KeyConcept* invasiveSpecies= [[KeyConcept alloc]initWithVariable:@"invasive" Page:15 Subpage:1 Position: CGPointMake(304, 476.5)];
    KeyConcept* pollution= [[KeyConcept alloc]initWithVariable:@"pollution" Page:15 Subpage:1 Position: CGPointMake(121, 518.5)];
    KeyConcept* overHarvesting= [[KeyConcept alloc]initWithVariable:@"harvest" Page:15 Subpage:1 Position: CGPointMake(247.5, 515.5)];
    KeyConcept* population= [[KeyConcept alloc]initWithVariable:@"population" Page:15 Subpage:1 Position: CGPointMake(132, 496.5)];
    KeyConcept* humanActivities= [[KeyConcept alloc]initWithVariable:@"human" Page:5 Subpage:1 Position: CGPointMake(199.5, 506)];
    KeyConcept* geneticInfo= [[KeyConcept alloc]initWithVariable:@"genetic" Page:11 Subpage:1 Position: CGPointMake(303.5, 531.5)];
    KeyConcept* extinctionRate= [[KeyConcept alloc]initWithVariable:@"0.01" Page:9 Subpage:1 Position: CGPointMake(228.5, 249)];
    KeyConcept* diversity= [[KeyConcept alloc]initWithVariable:@"diversity" Page:11 Subpage:1 Position: CGPointMake(301.5, 211.5)];
    KeyConcept* medicine= [[KeyConcept alloc]initWithVariable:@"medicine" Page:11 Subpage:1 Position: CGPointMake(210.5, 369)];
    KeyConcept* fivemass= [[KeyConcept alloc]initWithVariable:@"mass" Page:2 Subpage:1 Position: CGPointMake(317, 258)];
    KeyConcept* greatest= [[KeyConcept alloc]initWithVariable:@"greatest" Page:15 Subpage:1 Position: CGPointMake(89, 382)];
    
    species.conceptName=@"Species";
    Endangered.conceptName=@"Endangered Species";
    threatened.conceptName=@"Threatened Species";
    ecologicalService.subName=@"ecological Value";
    economicValue.conceptName=@"Economic Value";
    biologicalExtinction.conceptName=@"Biological Extinction";
    localExtinction.conceptName=@"Local Extinction";
    ecologicaExtinction.conceptName=@"Ecological Extinction";
    Endangered.conceptName=@"Endangered Species";
    threatened.conceptName=@"Threatened Species";
    instrumentalValue.conceptName=@"Instrumental Value";
    habitatDestruction.conceptName=@"Habitate Destruction";
    intrinsicValue.conceptName=@"Intrinsic Value";
    invasiveSpecies.conceptName=@"Invasive Species";
    pollution.conceptName=@"Human Population";
    overHarvesting.conceptName=@"Over Harvest";
    HIPPO.conceptName=@"HIPPO";
    humanActivities.conceptName=@"Human Activities";
    geneticInfo.conceptName=@"Genetic Information";
    extinctionRate.conceptName=@"0.01% to 1%";
    diversity.conceptName=@"Bio Diversity";
    medicine.conceptName=@"Medicine";
    fivemass.conceptName=@"Five Massive Extinctions";
    greatest.conceptName=@"Greatest Threat";
    
    [list addObject: species];
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
    [list addObject:humanActivities];
    [list addObject:geneticInfo];
    [list addObject:extinctionRate];
    [list addObject:diversity];
    [list addObject:medicine];
    [list addObject:fivemass];
    [list addObject:greatest];

    return list;
}


-(NSMutableArray*) getKeyLinkLists{
    NSMutableArray* list= [[NSMutableArray alloc]init];
    KeyLink* link1= [[KeyLink alloc] initWithNames:@"species" RightName:@"endanger"];
    KeyLink* link2= [[KeyLink alloc] initWithNames:@"species" RightName:@"threaten"];
    KeyLink* link3= [[KeyLink alloc] initWithNames:@"species" RightName:@"instrument"];
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
    KeyLink* link14= [[KeyLink alloc] initWithNames:@"biological" RightName:@"mass"];
    KeyLink* link15= [[KeyLink alloc] initWithNames:@"instrument" RightName:@"medicine"];
    KeyLink* link16= [[KeyLink alloc] initWithNames:@"species" RightName:@"diversity"];
    KeyLink* link17= [[KeyLink alloc] initWithNames:@"species" RightName:@"0.01"];
    KeyLink* link18= [[KeyLink alloc] initWithNames:@"human" RightName:@"greatest"];
    

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
    [list addObject: link14];
    [list addObject: link15];
    [list addObject: link16];
    [list addObject: link17];
    [list addObject: link18];
    return list;
    
}

@end
