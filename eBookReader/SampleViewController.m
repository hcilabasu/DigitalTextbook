//
//  SampleViewController.m
//  SphereViewSample
//
//

#import "SampleViewController.h"
#import "ZYQSphereView.h"
#import "KnowledgeModule.h"

@interface SampleViewController (){
    ZYQSphereView *sphereView;
    NSTimer *timer;
}

@end

@implementation SampleViewController

-(void)dealloc{
	//[sphereView release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden: NO animated:YES];
	sphereView = [[ZYQSphereView alloc] initWithFrame:CGRectMake(10, 60, 500, 500)];
    sphereView.center=CGPointMake(self.view.center.x, self.view.center.y-30);
	NSMutableArray *views = [[NSMutableArray alloc] init];
    
    KnowledgeModule* knowledge_module=[ [KnowledgeModule alloc] init ];
    

    for (Concept *concept in knowledge_module.conceptList) {
        CGFloat defaultWidth=80;
        CGFloat defaultHeight=50;
        defaultWidth*=powf(1.1, concept.count);
        defaultHeight*=powf(1.1, concept.count);
		UIButton *subV = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, defaultWidth, defaultHeight)];
        
		subV.backgroundColor = [UIColor colorWithRed:arc4random_uniform(100)/100. green:arc4random_uniform(100)/100. blue:arc4random_uniform(100)/100. alpha:0.8];
        [subV setTitle:concept.conceptName forState:UIControlStateNormal];
        subV.layer.masksToBounds=YES;
        subV.layer.cornerRadius=5;
        [subV addTarget:self action:@selector(subVClick:) forControlEvents:UIControlEventTouchUpInside];
        [views addObject:subV];
	}

    for (Concept *concept in knowledge_module.conceptList) {
        CGFloat defaultWidth=70;
        CGFloat defaultHeight=40;
        defaultWidth*=powf(1.1, concept.count);
        defaultHeight*=powf(1.1, concept.count);
		UIButton *subV = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, defaultWidth, defaultHeight)];
        
		subV.backgroundColor = [UIColor colorWithRed:arc4random_uniform(100)/100. green:arc4random_uniform(100)/100. blue:arc4random_uniform(100)/100. alpha:0.8];
        [subV setTitle:concept.conceptName forState:UIControlStateNormal];
        subV.layer.masksToBounds=YES;
        subV.layer.cornerRadius=5;
        [subV addTarget:self action:@selector(subVClick:) forControlEvents:UIControlEventTouchUpInside];
        [views addObject:subV];
	}
    
	[sphereView setItems:views];
    sphereView.isPanTimerStart=YES;
	//[views release];
	[self.view addSubview:sphereView];
    [sphereView timerStart];
   
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake((self.view.frame.size.width-120)/2, self.view.frame.size.height-60, 120, 30);
    [self.view addSubview:btn];
    btn.backgroundColor=[UIColor whiteColor];
    btn.layer.borderWidth=1;
    btn.layer.borderColor=[[UIColor orangeColor] CGColor];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btn setTitle:@"start/stop" forState:UIControlStateNormal];
    btn.selected=NO;
    [btn addTarget:self action:@selector(changePF:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)subVClick:(UIButton*)sender{
    NSLog(@"%@",sender.titleLabel.text);

    BOOL isStart=[sphereView isTimerStart];
    [sphereView timerStop];

    [UIView animateWithDuration:0.3 animations:^{
        sender.transform=CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            sender.transform=CGAffineTransformMakeScale(1, 1);
            if (isStart) {
                [sphereView timerStart];
            }
        }];
    }];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)changePF:(UIButton*)sender{
    if ([sphereView isTimerStart]) {
        [sphereView timerStop];
    }
    else{
        [sphereView timerStart];
    }
}

@end
