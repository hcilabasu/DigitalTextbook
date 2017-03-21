//
//  LogInViewController.m
//  eBookReader
//
//  Created by Shang Wang on 7/25/15.
//  Copyright (c) 2015 Andreea Danielescu. All rights reserved.
//

#import "LogInViewController.h"
#import "StudentData.h"
@interface LogInViewController ()

@end

@implementation LogInViewController

@synthesize LoginButton;
@synthesize UserNameTextView;
@synthesize PasswordTextView;
@synthesize BG;
@synthesize viewHasMoved;
@synthesize stuDataWrapper;
- (void)viewDidLoad {
    [super viewDidLoad];
    stuDataWrapper= [[StudentDataWrapper alloc]init];
    // Do any additional setup after loading the view.
     self.navigationController.navigationBarHidden=YES;
     BG.layer.zPosition=-1;
    UserNameTextView.userInteractionEnabled=YES;
    PasswordTextView.userInteractionEnabled=YES;
    PasswordTextView.secureTextEntry = YES;
    viewHasMoved=NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
    
    
    [stuDataWrapper clearAllData];
    StudentData* stu1= [[StudentData alloc]initWithName:@"Rachana" Password:@"imrachana123"];
    StudentData* stu2= [[StudentData alloc]initWithName:@"Tyler" Password:@"imtyler321"];
    [stuDataWrapper addLogs:stu1];
    [stuDataWrapper addLogs:stu2];
    [ StudentDataParser saveLogData:stuDataWrapper];
    

}



- (void)keyboardWasShown:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
   // self.UserNameTextView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - keyboardSize.height);
    // self.PasswordTextView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - keyboardSize.height);
    int viewsize=PasswordTextView.frame.origin.y+PasswordTextView.frame.size.width;
    int keysize=keyboardSize.height;
    if(  (PasswordTextView.frame.origin.y+PasswordTextView.frame.size.width)> (self.view.frame.size.height-keyboardSize.height)  ){
        self.view.frame=CGRectMake(0, - keyboardSize.height, self.view.frame.size.width, self.view.frame.size.height);
        viewHasMoved=YES;
    }
}


- (void)keyboardWillBeHidden:(NSNotification*)notification {
    if(viewHasMoved){
        self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
}


- (BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)viewWillAppear:(BOOL)animated{
      self.navigationController.navigationBarHidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)checkUserNamePswd: (NSString*)m_name Password: (NSString*) m_password{
    stuDataWrapper=[StudentDataParser loadLogData];
    
    for(StudentData* stu in stuDataWrapper.studentDataArray){
        if([stu.name isEqualToString:m_name] && [stu.password isEqualToString:m_password]){
            return YES;
        }
    }
    return NO;
}

- (IBAction)onClickLogin:(id)sender {
     NSString *userNameString = UserNameTextView.text;
     NSString *passwordString = PasswordTextView.text;
    
    NSString* istest=[[NSUserDefaults standardUserDefaults] stringForKey:@"isLogin"];
    if([istest isEqualToString:@"NO"]){
        NSString *trimmedString = [userNameString stringByReplacingOccurrencesOfString:@" " withString:@""];
        [[NSUserDefaults standardUserDefaults] setObject:trimmedString forKey:@"UserName"];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"NumOfConcepts"];
        LibraryViewController *library =(LibraryViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"LibraryViewController"];
        library.userName=UserNameTextView.text;
        [self.navigationController pushViewController:library animated:YES];
        NSString* logString=[[NSString alloc]initWithFormat:@"UserName: %@\n",trimmedString];
        NSLog(logString);
    }else{
    
    
    
    if([UserNameTextView.text length]==0){
        [[[UIAlertView alloc]
          initWithTitle:@"Error" message:@"User name is empty!" delegate:self
          cancelButtonTitle:@"Retry" otherButtonTitles: nil, nil] show];
    }
    
    /*
    else if(![self checkUserNamePswd:userNameString Password:passwordString]   ){
         [[[UIAlertView alloc]
           initWithTitle:@"Error" message:@"User name and password combination not found!" delegate:self
           cancelButtonTitle:@"Retry" otherButtonTitles: nil, nil] show];

     }*/
  

     else{

         NSString *trimmedString = [userNameString stringByReplacingOccurrencesOfString:@" " withString:@""];
        [[NSUserDefaults standardUserDefaults] setObject:trimmedString forKey:@"UserName"];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"NumOfConcepts"];
        LibraryViewController *library =(LibraryViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"LibraryViewController"];
        library.userName=UserNameTextView.text;
        [self.navigationController pushViewController:library animated:YES];
         NSString* logString=[[NSString alloc]initWithFormat:@"UserName: %@\n",trimmedString];
         NSLog(logString);
    }
        
    }
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"OpenLibrary"])
    {
        // Get reference to the destination view controller
        LibraryViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.userName=UserNameTextView.text;
    }
}


-(void)upLoadLogFiletoDropBox{
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{
                                                   @"Authorization" : [NSString stringWithFormat:@"Bearer %@", @"BFPZY5kp2NAAAAAAAAAAJHzSODkGgGqThiZaKH2pCafGwX1kKVs2UVSVnwMiRj9c"],
                                                   @"Content-Type"  : @"application/zip"
                                                   };
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/LogData.xml",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    
    NSString *filename = @"/Logfile/LogData_";
    filename=[filename stringByAppendingString:UserNameTextView.text];
    filename= [filename stringByAppendingString:@".xml"];
    
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath = [localDir stringByAppendingPathComponent:filename];
    [content writeToFile:localPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    // Upload file to Dropbox
    NSString *destDir = @"/";
    // [self.restClient uploadFile:filename toPath:destDir withParentRev:nil fromPath:localPath];
    
    
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: sessionConfiguration delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api-content.dropbox.com/1/files_put/auto/%@?overwrite=false",filename]]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:localPath];
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:data];
    [request setTimeoutInterval:1000];
    
    NSURLSessionDataTask *doDataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error){
            NSLog(@"WORKED!!!!");
        } else {
            NSLog(@"ERROR: %@", error);
        }
    }];
    
    [doDataTask resume];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
