//  ExpertModel.m
//  Study
//
//  Created by Shang Wang on 2/19/19.
//  Copyright © 2019 Shang Wang. All rights reserved.
//
#import "ExpertModel.h"
#import "LogDataWrapper.h"
#import "LogDataParser.h"
#import "CmapLinkWrapper.h"
#import "CmapNodeWrapper.h"
#import "NodeCell.h"
#import "CmapController.h"
@interface ExpertModel ()

@end

@implementation ExpertModel
@synthesize logArray;
@synthesize stateArray;
@synthesize parentCmapController;
@synthesize bookLinkWrapper;
@synthesize bookNodeWrapper;
@synthesize unUsedStateArray;
@synthesize readActionCount;
@synthesize readFeedbackCount;
@synthesize startPosition;
@synthesize keyConceptsAry;
@synthesize missingConceptsAry;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    readActionCount=0;
    readFeedbackCount=0;
    startPosition=0;
    KnowledgeModel* KM=[[KnowledgeModel alloc]init];
    keyConceptsAry=[KM getKeyConceptLists];
}

-(void)setupKM{
    readActionCount=0;
    readFeedbackCount=0;
    startPosition=0;
    KnowledgeModel* KM=[[KnowledgeModel alloc]init];
    keyConceptsAry=[KM getKeyConceptLists];
    
    missingConceptsAry= [[NSMutableArray alloc]init];
}

-(void)evaluate{
    
    LogData *lastdata= [logArray lastObject];
    LogData *secondLastData= [logArray objectAtIndex: ([logArray count]-2)];
    NSString* lastAction=lastdata.action;
    NSString* secondLastAction=secondLastData.action;
    if (  [secondLastAction rangeOfString:@"Application Loaded"].location != NSNotFound) {
        stateArray=[[NSMutableArray alloc]init];
        startPosition= (int)[logArray count]-2;
        if(startPosition<0){
            startPosition=0;
        }
    }
    
    
    BOOL ismeaningful= [self isMeaningfulAction: lastdata];
    if (!ismeaningful){
        return;
    }
    
    
    if( [lastAction rangeOfString:@"urned to page"].location == NSNotFound){
        readActionCount=0;
    }
    
    stateArray=[[NSMutableArray alloc]init];
    int prePage=0;
    BOOL isPosNavi=YES;
    NSString* currentState=@"Load";
    NSString* preState=@"";
    BOOL isLinearSequence=NO;
    
    
    if(0== [bookNodeWrapper.cmapNodes count]){
        bookNodeWrapper=[CmapNodeParser loadCmapNode];
    }
    if(0== [bookLinkWrapper.cmapLinks count]){
        bookLinkWrapper=[CmapLinkParser loadCmapLink];
    }
    
    
    NSMutableDictionary *NodenamePage = [[NSMutableDictionary alloc] init];
    for(CmapNode* node in bookNodeWrapper.cmapNodes){
        NSString *pageString = [NSString stringWithFormat:@"%d",node.pageNum];
        NSString* nodeName=node.text;
        NodenamePage[nodeName]=pageString;
    }
    
   // for ( LogData *data in  logArray){
    for(int i=startPosition; i<[logArray count];i++){
        LogData* data= [logArray objectAtIndex:i];
        int page =data.page;
        NSString* action=data.action;
        NSString* input=data.input;
        NSString* selection=data.selection;
      
        if (  [action rangeOfString:@"Application Loaded"].location != NSNotFound) {
            stateArray=[[NSMutableArray alloc]init];
            prePage=0;
        }
        
        
        if (  [action rangeOfString:@"creat"].location != NSNotFound) {
            currentState=@"A";
            [stateArray addObject:currentState];
        }else if( [action rangeOfString:@"urned to page"].location != NSNotFound){
            if(page>prePage){
                currentState=@"R";
                [stateArray addObject:currentState];
                isPosNavi=YES;
            }else if ( page<prePage){
                if(isPosNavi){
                    currentState=@"P";
                    [stateArray addObject:currentState];
                    isPosNavi=NO;
                }else if (!isPosNavi){
                    currentState=@"B";
                    [stateArray addObject:currentState];
                }
            }
            prePage=page;
        }else if([action rangeOfString:@"Linking concepts"].location != NSNotFound ){
                currentState=@"L";
                NSString* leftNodename=input;
                NSString* rightNodeName=selection;
                NSString* leftNodePageString=@"0";
                NSString* rightNodePageString=@"0";
                
                if(  [NodenamePage objectForKey: leftNodename]){
                    leftNodePageString=NodenamePage[leftNodename];
                }
                if (  [NodenamePage objectForKey:rightNodeName ] ){
                    rightNodePageString=NodenamePage[rightNodeName];
                }
                int delta=abs(  [leftNodePageString intValue]-[rightNodePageString intValue]    );
                if (delta>0){
                    currentState=@"C";
                }
            [stateArray addObject:currentState];
            }
    }
    
    for (NSString *st in stateArray){
        NSLog(@"%@",st);
    }
    

    
    if([currentState isEqualToString:@"R"]){
        readActionCount++;
        missingConceptsAry= [self getMissingConcepts:bookNodeWrapper.cmapNodes Page:lastdata.page KeyConceptList:keyConceptsAry];
        
        
        
    }else{
        readActionCount=0;
    }
    
    
    
    
    if(readActionCount>2){
        readFeedbackCount++;
        [parentCmapController showReadFeedbackmessage];
        readActionCount=0;
    }
    
    
    
}//end of evaluate











-(BOOL)isMeaningfulAction:(LogData*)log{
    NSString* action=log.action;
    BOOL ismeaningful=NO;
    if ([action rangeOfString:@"creat"].location != NSNotFound) {
        ismeaningful=YES;
    }
    if ([action rangeOfString:@"urned to page"].location != NSNotFound) {
        ismeaningful=YES;
    }
    if ([action rangeOfString:@"Linking concepts"].location != NSNotFound) {
        ismeaningful=YES;
    }
    return ismeaningful;
}


-(NSMutableArray*)getMissingConcepts:  (NSMutableArray*)nodeAry Page: (int)page  KeyConceptList: (NSMutableArray*) keylist{
    NSMutableArray* missingConcepts=[[NSMutableArray alloc]init];
    for( KeyConcept* kc in keylist){
        NSString* name=kc.name;
        NSString* subName=kc.subName;
        int currentPage=page;
        BOOL isMIssing=YES;
        for (CmapNode* node in nodeAry){
            NSString* lowString=node.text.lowercaseString;
            if (   ([lowString rangeOfString:name].location != NSNotFound) || ([node.text rangeOfString:subName].location != NSNotFound) ||kc.page>(page-1)  ) {
                isMIssing=NO;
            }
        }
        if(isMIssing){
            [missingConcepts addObject:kc];
        }
    }
   
    parentCmapController.feedbackCtr.missingConceptAry=missingConcepts;
    return missingConcepts;
}






@end
