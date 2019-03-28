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
@synthesize pageTimeMap;
@synthesize startTimeSecond;
@synthesize prePageNum;
@synthesize pageStayTimeMap;
@synthesize preTimeSecond;
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
    pageTimeMap=[[NSMutableDictionary alloc]init];
    pageStayTimeMap=[[NSMutableDictionary alloc]init];
    prePageNum=1;
    preTimeSecond=0;
    startTimeSecond=0;
    //initialize page stay time dictionary
    for(int i=0; i<100;i++){
        NSString* keyString= [NSString stringWithFormat:@"%d",i];
        pageStayTimeMap[keyString]=@"0.0";
    }
    
}

-(void)evaluate{
    LogData *lastdata= [logArray lastObject];

    LogData *secondLastData= [logArray objectAtIndex: ([logArray count]-2)];
    NSString* lastAction=lastdata.action;
    NSString* secondLastAction=secondLastData.action;
    if (  [secondLastAction rangeOfString:@"Application Loaded"].location != NSNotFound) {
        stateArray=[[NSMutableArray alloc]init];
        startPosition= (int)[logArray count]-2;
        startTimeSecond= [secondLastData.timeInSecond doubleValue];
        preTimeSecond=startTimeSecond;
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
    
    if( [lastAction rangeOfString:@"urned to page"].location != NSNotFound || [lastAction rangeOfString:@"Linking concepts"].location != NSNotFound) {
        double curentTimeSecond= [lastdata.timeInSecond doubleValue];
        //curentTimeSecond=curentTimeSecond-preTimeSecond;
        int page=lastdata.page;
        if( prePageNum>0){
            double readTime= curentTimeSecond-preTimeSecond;
            //NSLog(@"\n\n\n\n\n\n\n\n\n\n\n Page %d  Stay Time: %f\n\n\n",prePageNum,readTime);
            NSString* prePageString= [NSString stringWithFormat:@"%d", prePageNum];
            NSString* preTimeStayString= pageStayTimeMap[prePageString];
            double prePageStayTime= [preTimeStayString doubleValue];
            double newStayTime=readTime+prePageStayTime;
            NSString* newStayTimeString= [NSString stringWithFormat:@"%.2f", newStayTime];
            pageStayTimeMap[prePageString]=newStayTimeString;
        }
        preTimeSecond=curentTimeSecond;
        prePageNum=page;
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
            //upDatePage time
        
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
                    int leftNodeInt=[leftNodePageString intValue];
                    int rightNodeInt= [rightNodePageString intValue];
     
                    
                    NSString* leftNodePageStringNew= [NSString stringWithFormat:@"%d", leftNodeInt+1];
                    NSString* rightNodePageStringNew= [NSString stringWithFormat:@"%d", rightNodeInt+1];
                    
                    NSString* leftStayTimeString= pageStayTimeMap[leftNodePageStringNew];
                    NSString* rightStayTmeString=pageStayTimeMap[rightNodePageStringNew];
                    double leftStayTime=[leftStayTimeString doubleValue];
                    double rightStayTime= [rightStayTmeString doubleValue];
                    if( leftStayTime>5&& rightStayTime>5){
                        currentState=@"G";
                    }else{
                        
                    }
                    
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
    
    // if user creates a cross link, check if reading or comparing has been done.
    

    if([lastAction isEqualToString:@"Update Link name from list"] ){
        if(  [stateArray count]<4){
            return;
        }
        NSString*  preState=[stateArray objectAtIndex: [stateArray count]-1];
        if([preState isEqualToString:@"G"]){
            
            int stateCount=(int)[stateArray count];
            if( stateCount<3 ){
                return;
            }
            NSString* pre1= [stateArray objectAtIndex: stateCount-2];
            NSString* pre2= [stateArray objectAtIndex: stateCount-3];
            if( [pre1 isEqualToString:@"P"] ||[pre1 isEqualToString:@"B"] ||[pre2 isEqualToString:@"P"] ){
                [parentCmapController showPositiveFeedbackmessage];
            }
        }
        if([preState isEqualToString:@"C"]){
             [parentCmapController showCompareFeedbackmessage];
        }
    
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
    if ([action rangeOfString:@"Update Link name from list"].location != NSNotFound) {
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
