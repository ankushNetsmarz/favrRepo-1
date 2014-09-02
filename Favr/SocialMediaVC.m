//
//  SocialMediaVC.m
//  Favr
//
//  Created by Ankush on 03/07/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "SocialMediaVC.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import "ShareConfiguration.h"
#import "AccessContactVC.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface SocialMediaVC ()<GPPSignInDelegate,GPPShareDelegate>{

    GPPSignIn             *_signIn;
}
@property (strong, nonatomic) IBOutlet UISwitch *fbSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *twitterSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *gpSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *linkedinSwitch;

@property (nonatomic, strong) OAuthLoginView *oAuthLoginView;
@property (nonatomic)NSMutableArray *connections;
@property (nonatomic)NSDictionary *connectionDictionary;
@property (nonatomic)NSString *twitterUsername;

@end

@implementation SocialMediaVC
//APP IDS
#define  GoogleAppId                      @"833933554327-hqpdf3nvhlm4qlq5qq3fifckhnko0ibl.apps.googleusercontent.com"
static int const kFBSwitch = 1;
static int const kGPPBSwitch = 2;
static int const kTwitterSwitch = 3;
static int const kLinkedInSwitch = 4;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.connections = [[NSMutableArray alloc]init];
    [ShareConfiguration sharedInstance].useNativeSharebox=YES;
    [ShareConfiguration sharedInstance].sharePrefillText=@"Hi Bro, Just Testing.. :)";
    [ShareConfiguration sharedInstance].shareURL=@"www.WeExcel.com";
    
   
    [self initiateScrollView];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.socialSharingView.bounds];
    self.socialSharingView.layer.masksToBounds = NO;
    self.socialSharingView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.socialSharingView.layer.shadowOffset = CGSizeMake(0.0f, -5.0f);
    self.socialSharingView.layer.shadowOpacity = 0.15f;
    self.socialSharingView.layer.shadowPath = shadowPath.CGPath;
    userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
    
    
    [appDelegate() CheckInternetConnection];
    if([appDelegate() internetWorking] ==0){
        
    }
    else
    {
        UIAlertView *_alertView1 = [[UIAlertView alloc]initWithTitle:nil message:@"Please connect to internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_alertView1 show];
        return;
    }
    
    [appDelegate() showMBHUD:@"Please Wait.."];
    
    [PFCloud callFunctionInBackground:@"getDetailUser"
                       withParameters:@{
                                        @"userId": userId
                                        }
                                block:^(NSArray *results, NSError *error)
     {
         if (!error)
         {
             
             NSLog(@"_________________________________________________%@",[results objectAtIndex:0]);
             
             
             NSMutableArray *_fbArray = [[NSMutableArray alloc]init];
             NSMutableArray *_twitterArray = [[NSMutableArray alloc]init];
             NSMutableArray *_GPArray = [[NSMutableArray alloc]init];
             NSMutableArray *_linkedInArray = [[NSMutableArray alloc]init];
             
             
             if ([[results objectAtIndex:0] valueForKey:@"facebookDetail"]==nil) {
                 
             }else{
             [_fbArray addObject:[[results objectAtIndex:0] valueForKey:@"facebookDetail"]];
             }
             
             
             if ([[results objectAtIndex:0] valueForKey:@"twitterDetail"]==nil) {
                 
             }else{
                 [_twitterArray addObject:[[results objectAtIndex:0] valueForKey:@"twitterDetail"]];
             }
             
             
             if ([[results objectAtIndex:0] valueForKey:@"gPlusDetail"]==nil) {
                 
             }else{
                  [_GPArray addObject:[[results objectAtIndex:0] valueForKey:@"gPlusDetail"]];
             }
             
             if ([[results objectAtIndex:0] valueForKey:@"linkedInDetail"]==nil) {
                 
             }else{
                 [_linkedInArray addObject:[[results objectAtIndex:0] valueForKey:@"linkedInDetail"]];
             }
            
            
             
             if (_fbArray.count>0)
                 _fbSwitch.on = YES;
             else
                 _fbSwitch.on = NO;
                 
                 if (_twitterArray.count>0)
                     _twitterSwitch.on = YES;
                     else
                         _twitterSwitch.on = NO;
                         
                         if (_GPArray.count>0)
                             _gpSwitch.on = YES;
                             else
                                 _gpSwitch.on = NO;
                                 
                                 if (_linkedInArray.count>0)
                                     _linkedinSwitch.on = YES;
                                     else
                                         _linkedinSwitch.on = NO;
             
             
             
            // userDetails = [[NSArray alloc] initWithArray:results];
//             [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:[[results objectAtIndex:0] valueForKey:@"profilePicPath"]] placeholderImage:[UIImage imageNamed:@"profileImage.png"]];
//             self.userFullName.text = [[results objectAtIndex:0] valueForKey:@"fullName"];
//             [self.acceptedBtnObj setTitle:[NSString stringWithFormat:@"%@", [[results objectAtIndex:0] valueForKey:@"noOfFavrAccepted"]] forState:UIControlStateNormal];
//             [self.acceptedFavrBtnObj setTitle:[NSString stringWithFormat:@"%@", [[results objectAtIndex:0] valueForKey:@"noOfFavrAccepted"]] forState:UIControlStateNormal];
//             
//             [self.rejectedFavrBtnObj setTitle:[NSString stringWithFormat:@"%@", [[results objectAtIndex:0] valueForKey:@"noOfFavrRejected"]] forState:UIControlStateNormal] ;
//             [self.askedFavrBtnObj setTitle:[NSString stringWithFormat:@"%@", [[results objectAtIndex:0] valueForKey:@"asHelpeeCount"]] forState:UIControlStateNormal];
//             self.userFullNameHis.text = [[results objectAtIndex:0] valueForKey:@"fullName"];
             
             [appDelegate() dismissMBHUD];
             
         }
         else
         {
             [appDelegate() dismissMBHUD];
             NSLog(@"Error Occured");
             //[self.navigationController popViewControllerAnimated:YES];
         }
     }
     ];

    
    
    
}


-(void)initiateScrollView{
    NSInteger numberOfViews = 3;
    for (int i = 0; i < numberOfViews; i++) {
        CGFloat xOrigin = i * self.view.frame.size.width+40;
        UIImageView *demoImage = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, 0, 240, 240)];
        demoImage.image = [UIImage imageNamed:@"1024x1024_blue_logo_with_text.png"];
        [self.mainScrollView addSubview:demoImage];
        
    }
    self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.size.width * numberOfViews, 200);
    self.mainScrollView.delegate=self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.mainScrollView.isDragging || self.mainScrollView.isDecelerating){
        self.pageControl.currentPage = lround(self.mainScrollView.contentOffset.x / (self.mainScrollView.contentSize.width / self.pageControl.numberOfPages));
    }
}

- (void)presentSignInViewController:(UIViewController *)viewController {
    // This is an example of how you can implement it if your app is navigation-based.
    [[self navigationController] pushViewController:viewController animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)socialSwitchesActivation:(UISwitch*)sender{
    
    
    [appDelegate() CheckInternetConnection];
    if([appDelegate() internetWorking] ==0){
        
    }
    else
    {
        UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please connect to internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_alertView show];
        return;
    }
    
    if (sender.on) {
        switch (sender.tag) {
            case kFBSwitch:
            {
                NSLog(@"facebook profile info %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"facebookProfileInfo"]);
                fbProfileDetailsDict = [[NSDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:@"facebookProfileInfo"]];
                NSLog(@"date of birth %@", [fbProfileDetailsDict objectForKey:@"birthday"]);
                NSString *nameString = [NSString stringWithFormat:@"%@ %@", [fbProfileDetailsDict objectForKey:@"first_name"], [fbProfileDetailsDict objectForKey:@"last_name"]];
                NSLog(@"Name %@ %@", [fbProfileDetailsDict objectForKey:@"first_name"], [fbProfileDetailsDict objectForKey:@"last_name"]);
                NSLog(@"email %@", [fbProfileDetailsDict objectForKey:@"email"]);
                NSLog(@"work at %@", [[[[fbProfileDetailsDict objectForKey:@"work"] objectAtIndex:1] objectForKey:@"employer"] objectForKey:@"name"]);
                NSLog(@"Home town %@", [[fbProfileDetailsDict objectForKey:@"hometown"] objectForKey:@"name"]);
                fbInfoDict = [[NSDictionary alloc] initWithObjectsAndKeys:nameString, @"name",[fbProfileDetailsDict objectForKey:@"birthday"], @"Date_Of_Birth", [[fbProfileDetailsDict objectForKey:@"hometown"] objectForKey:@"name"], @"Home_Town", [fbProfileDetailsDict objectForKey:@"email"], @"Email_Id", [[[[fbProfileDetailsDict objectForKey:@"work"] objectAtIndex:1] objectForKey:@"employer"] objectForKey:@"name"], @"Work_At",  nil];
                userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
                
                //                [self fetchFBFriends:nil];
                
                [appDelegate() showMBHUD:@"Please Wait..."];
                
                [PFCloud callFunctionInBackground:@"addSocialDetailFacebook"
                                   withParameters:@{@"userId": userId,
                                                    @"facebookDetail": fbInfoDict,
                                                    @"gPlusDetail": @"",
                                                    @"twitterDetail": @"",
                                                    @"linkedInDetail": @""
                                                    }
                                            block:^(NSString *results, NSError *error) {
                                                if (!error) {
                                                    NSLog(@"result: %@",results);
                                                    [appDelegate() dismissMBHUD];
                                                    [self showStatus:@"Facebook information saved successfully." timeout:1];
                                                    
                                                }else{
                                                    [appDelegate() dismissMBHUD];
                                                }
                                            }];
            }
                
                break;
            case kGPPBSwitch:
                _signIn = [GPPSignIn sharedInstance];
                if ([_signIn authentication]) {
                    [_signIn  signOut];
                    [self callGooglePlus];
                    
                }
                else{
                    [self callGooglePlus];
                }

                
                break;
            case kTwitterSwitch:
                [self initializeTwitter];
                break;
            case kLinkedInSwitch:
                [self activateLinkedInProfile];
                break;
            default:
                break;
        }
    }
}


- (void)showStatus:(NSString *)message timeout:(double)timeout
{
    _alertView = [[UIAlertView alloc] initWithTitle:nil
                                                       message:message
                                                      delegate:nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:nil];
    [_alertView show];
    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(timerExpired:)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)timerExpired:(NSTimer *)timer
{
    [_alertView dismissWithClickedButtonIndex:0 animated:YES];
}


#pragma mark FACEBOOK API

-(IBAction)fetchFBFriends:(id)sender{
    [[AccessContactVC sharedManager] inviteNonFriends];
}


/*
 -(void)get
 {
 
 NSURL *requestURL = [NSURL URLWithString:@"https://graph.facebook.com/me"];
 
 SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:requestURL parameters:nil];
 request.account = self.facebookAccount;
 
 [request performRequestWithHandler:^(NSData *data, NSHTTPURLResponse *response, NSError *error) {
 
 if(!error)
 {
 
 NSDictionary *list =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
 
 NSLog(@"Dictionary contains: %@", list );
 
 fbID = [NSString stringWithFormat:@"%@", [list objectForKey:@"id"]];
 globalFBID = fbID;
 
 gender = [NSString stringWithFormat:@"%@", [list objectForKey:@"gender"]];
 playerGender = [NSString stringWithFormat:@"%@", gender];
 NSLog(@"Gender : %@", playerGender);
 
 
 self.globalmailID   = [NSString stringWithFormat:@"%@",[list objectForKey:@"email"]];
 NSLog(@"global mail ID : %@",globalmailID);
 
 fbname = [NSString stringWithFormat:@"%@",[list objectForKey:@"name"]];
 NSLog(@"faceboooookkkk name %@",fbname);
 
 if([list objectForKey:@"error"]!=nil)
 {
 [self attemptRenewCredentials];
 }
 dispatch_async(dispatch_get_main_queue(),^{
 
 });
 }
 else
 {
 //handle error gracefully
 NSLog(@"error from get%@",error);
 //attempt to revalidate credentials
 }
 
 }];
 
 self.accountStore = [[ACAccountStore alloc]init];
 ACAccountType *FBaccountType= [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
 
 NSString *key = @"451805654875339";
 NSDictionary *dictFB = [NSDictionary dictionaryWithObjectsAndKeys:key,ACFacebookAppIdKey,@[@"friends_videos"],ACFacebookPermissionsKey, nil];
 
 
 [self.accountStore requestAccessToAccountsWithType:FBaccountType options:dictFB completion:
 ^(BOOL granted, NSError *e) {}];
 
 }
 
 
 
 -(void)getFBFriends
 {
 
 NSURL *requestURL = [NSURL URLWithString:@"https://graph.facebook.com/me/friends"];
 
 SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:requestURL parameters:nil];
 request.account = self.facebookAccount;
 
 [request performRequestWithHandler:^(NSData *data, NSHTTPURLResponse *response, NSError *error) {
 
 if(!error)
 {
 
 NSDictionary *friendslist =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
 
 for (id facebookFriendList in [friendslist objectForKey:@"data"])
 {
 NSDictionary *friendList = (NSDictionary *)facebookFriendList;
 [facebookFriendIDArray addObject:[friendList objectForKey:@"id"]];
 }
 
 
 if([friendslist objectForKey:@"error"]!=nil)
 {
 [self attemptRenewCredentials];
 }
 dispatch_async(dispatch_get_main_queue(),^{
 
 });
 }
 else
 {
 //handle error gracefully
 NSLog(@"error from get%@",error);
 //attempt to revalidate credentials
 }
 
 }];
 
 self.accountStore = [[ACAccountStore alloc]init];
 ACAccountType *FBaccountType= [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
 
 NSString *key = @"451805654875339";
 NSDictionary *dictFB = [NSDictionary dictionaryWithObjectsAndKeys:key,ACFacebookAppIdKey,@[@"friends_videos"],ACFacebookPermissionsKey, nil];
 
 
 [self.accountStore requestAccessToAccountsWithType:FBaccountType options:dictFB completion:
 ^(BOOL granted, NSError *e) {}];
 
 }
 */


#pragma mark - LINKEDIN API CALLS

- (void)activateLinkedInProfile
{
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"TokenKey"];
    self.oAuthLoginView = [[OAuthLoginView alloc] initWithNibName:nil bundle:nil];
    
    // register to be told when the login is finished
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginViewDidFinish:)
                                                 name:@"loginViewDidFinish"
                                               object:self.oAuthLoginView];
    
    [self presentViewController:self.oAuthLoginView animated:YES completion:nil];
}
-(void) loginViewDidFinish:(NSNotification*)notification
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // We're going to do these calls serially just for easy code reading.
    // They can be done asynchronously
    // Get the profile, then the network updates
    [self profileApiCall];
	
}


- (void)profileApiCall
{
  //  NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~"];
    NSString *kAPIBaseURL = @"http://api.linkedin.com";
    NSURL* url = [NSURL URLWithString:[kAPIBaseURL stringByAppendingString:@"/v1/people/~:(id,first-name,last-name,maiden-name,formatted-name,phonetic-last-name,location:(country:(code)),industry,distance,current-status,current-share,network,skills,phone-numbers,date-of-birth,main-address,positions:(title),educations:(school-name,field-of-study,start-date,end-date,degree,activities))"]];

    OAMutableURLRequest *request =
    [[OAMutableURLRequest alloc] initWithURL:url
                                    consumer:self.oAuthLoginView.consumer
                                       token:self.oAuthLoginView.accessToken
                                    callback:nil
                           signatureProvider:nil];
    
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
     [appDelegate() showMBHUD:@"Please Wait..."];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(profileApiCallResult:didFinish:)
                  didFailSelector:@selector(profileApiCallResult:didFail:)];
}
- (void)profileApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    
    NSDictionary *profile = [responseBody objectFromJSONString];
    NSString * userName;
    NSString * strWorkAt;
    NSString * DOB;
    if ( profile )
    {
         userName= [[NSString alloc] initWithFormat:@"%@ %@",
                              [profile objectForKey:@"firstName"], [profile objectForKey:@"lastName"]];
        NSLog(@"User Name %@",userName);
        
        strWorkAt= [[NSString alloc] initWithFormat:@"%@",
                   [profile objectForKey:@"headline"]];
        DOB  =[[NSString alloc] initWithFormat:@"%@-%@-%@",[[profile objectForKey:@"dateOfBirth"] objectForKey:@"day"],[[profile objectForKey:@"dateOfBirth"] objectForKey:@"month"],[[profile objectForKey:@"dateOfBirth"] objectForKey:@"year"]];
    }
   
    
    fbInfoDict = [[NSDictionary alloc] initWithObjectsAndKeys:userName, @"name",@"", @"Date_Of_Birth", DOB, @"Home_Town", @"", @"Email_Id", strWorkAt, @"Work_At",  nil];
    userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
    
    
    
    [PFCloud callFunctionInBackground:@"addSocialDetailLinkedIn"
                       withParameters:@{@"userId": userId,
                                        @"facebookDetail": @"",
                                        @"gPlusDetail": @"",
                                        @"twitterDetail":@"",
                                        @"linkedInDetail": fbInfoDict
                                        }
                                block:^(NSString *results, NSError *error) {
                                    if (!error) {
                                        NSLog(@"result: %@",results);
                                        
                                        [appDelegate() dismissMBHUD];
                                        [self showStatus:@"LinkedIn information saved successfully." timeout:1];
                                        
                                        
                                    }else{
                                     [appDelegate() dismissMBHUD];
                                    }
                                }];

    
    
    
    
    // The next thing we want to do is call the network updates
    [self GetConnectionsCall];
    [self networkApiCall];
    
}

- (void)profileApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)error
{
    [appDelegate() dismissMBHUD];
    NSLog(@"%@",[error description]);
}

-(void)GetConnectionsCall
{
    NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~/connections:(id,first-name,last-name,email-address)"];
    
    OAMutableURLRequest *request =
    [[OAMutableURLRequest alloc] initWithURL:url
                                    consumer:self.oAuthLoginView.consumer
                                       token:self.oAuthLoginView.accessToken
                                    callback:nil
                           signatureProvider:nil];
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(connectionsApiCallResult:didFinish:)
                  didFailSelector:@selector(connectionsApiCallResult:didFail:)];
    
}
- (void)connectionsApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    NSLog(@"connectionsApiCallResult====%@",responseBody);
    
    self.connectionDictionary = [responseBody objectFromJSONString];
    
    //    for(int i=0;i<[[self.connectionDictionary objectForKey:@"_total"]intValue];i++)
    //    {
    //
    //        NSDictionary *person=  [[[self.connectionDictionary objectForKey:@"values"]objectAtIndex:i]objectForKey:@"firstName"];
    //        [self.connections addObject:person];
    //        NSLog(@"Connection %d : %@",i,person);
    //
    //    }
    for(NSDictionary* person in [self.connectionDictionary objectForKey:@"values"]){
        [self.connections addObject:person];
    }
    NSLog(@"%@",self.connections);
    
}

- (void)connectionsApiCallResult:(OAServiceTicket *)ticket didFail:(NSError *)error
{
    NSLog(@"%@",[error description]);
}


- (void)networkApiCall
{
    NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~/network/updates?scope=self&count=1&type=STAT"];
    OAMutableURLRequest *request =
    [[OAMutableURLRequest alloc] initWithURL:url
                                    consumer:self.oAuthLoginView.consumer
                                       token:self.oAuthLoginView.accessToken
                                    callback:nil
                           signatureProvider:nil];
    
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(networkApiCallResult:didFinish:)
                  didFailSelector:@selector(networkApiCallResult:didFail:)];
    
}

- (void)networkApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    
    NSDictionary *person = [[[[[responseBody objectFromJSONString]
                               objectForKey:@"values"]
                              objectAtIndex:0]
                             objectForKey:@"updateContent"]
                            objectForKey:@"person"];
    
    
    if ( [person objectForKey:@"currentStatus"] )
    {
        
        NSLog(@"Person Status %@",[person objectForKey:@"currentStatus"]);
    }
    else
    {
        
        NSString* tempStr = [[[[person objectForKey:@"personActivities"]
                               objectForKey:@"values"]
                              objectAtIndex:0]
                             objectForKey:@"body"];
        NSLog(@"LinkedIn personActivities = %@",tempStr);
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)networkApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)error
{
    NSLog(@"%@",[error description]);
}


#pragma mark - GOOGLE API

-(void)refreshInterfaceBasedOnSignIn {
    if ([[GPPSignIn sharedInstance] authentication]) {
        // The user is signed in.
        self.googleButton.hidden = YES;
        [self.switchGoogleP setOn:YES animated:YES];
        // Perform other actions here, such as showing a sign-out button
    } else {
        self.googleButton.hidden = NO;
        [self.switchGoogleP setOn:NO animated:YES];
        // Perform other actions here
    }
}
- (IBAction)InviteGooglePlus:(id)sender {
    
    //    ListPeopleViewController *peoplePicker =
    //    [[ListPeopleViewController alloc] initWithNibName:nil bundle:nil];
    //    peoplePicker.allowSelection = YES;
    //    peoplePicker.delegate = self;
    //    peoplePicker.navigationItem.title = @"Pick people";
    //    [self presentViewController:peoplePicker animated:YES completion:nil];
    
    _signIn = [GPPSignIn sharedInstance];
    if ([_signIn authentication]) {
    }
    else{
        [self callGooglePlus];
    }
    
}


-(void)callGooglePlus{
    
    _signIn = [GPPSignIn sharedInstance];
    [_signIn signOut];
    _signIn.delegate = self;
    _signIn.shouldFetchGoogleUserEmail = YES;
    _signIn.clientID = GoogleAppId;
    _signIn.scopes = [NSArray arrayWithObjects:kGTLAuthScopePlusMe,kGTLAuthScopePlusLogin,nil];
    
    NSArray *_array=[NSArray arrayWithObjects:@"DiscoverActivity",@"ListenActivity",@"CheckInActivity",@"ReviewActivity",@"AddActivity",@"CreateActivity",@"CommentActivity",@"WantActivity",@"BuyActivity",@"ReserveActivity",nil];
    NSMutableArray *supportedAppActivities = [[NSMutableArray alloc] init];
    for (NSString *appActivity in _array) {
        NSString *schema =
        [NSString stringWithFormat:@"http://schemas.google.com/%@",
         appActivity];
        [supportedAppActivities addObject:schema];
    }
    
    _signIn.actions=supportedAppActivities;
    [_signIn authenticate];
}

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {
    if (error) {
//        if (_progressHUD) {
//            [_progressHUD show:NO];
//            [_progressHUD hide:YES];
//        }
    }
    else {
        
      //  [self refreshInterfaceBasedOnSignIn];
        [appDelegate() showMBHUD:@"Please Wait..."];
        GTLServicePlus* plusService = [[GTLServicePlus alloc] init];
        plusService.retryEnabled = YES;
        [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
        GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
        
        [plusService executeQuery:query
                completionHandler:^(GTLServiceTicket *ticket,
                                    GTLPlusPerson *person,
                                    NSError *error) {
                    if (error) {
                        GTMLoggerError(@"Error: %@", error);
                    } else {
                        // Retrieve the display name and "about me" text
                        NSString *description = [NSString stringWithFormat:
                                                 @"%@\n%@", person.displayName,
                                                 person.aboutMe];
                        
                        fbInfoDict = [[NSDictionary alloc] initWithObjectsAndKeys:person.displayName, @"name",@"", @"Date_Of_Birth", @"", @"Home_Town", @"", @"Email_Id", @"", @"Work_At",  nil];
                        userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
                        
                        [PFCloud callFunctionInBackground:@"addSocialDetailGplus"
                                           withParameters:@{@"userId": userId,
                                                            @"facebookDetail": @"",
                                                            @"gPlusDetail": fbInfoDict,
                                                            @"twitterDetail": @"",
                                                            @"linkedInDetail": @""
                                                            }
                                                    block:^(NSString *results, NSError *error) {
                                                        if (!error) {
                                                            NSLog(@"result: %@",results);
                                                            
                                                            [appDelegate() dismissMBHUD];
                                                            [self showStatus:@"GooglePlus information saved successfully." timeout:1];

                                                            
                                                            
                                                        }else{
                                                            [appDelegate() dismissMBHUD];
                                                        }
                                                    }];
                        
                        
                        
                        
                        
                    }
                }];
    }
    
}

- (void)didDisconnectWithError:(NSError *)error {
    
    [appDelegate() dismissMBHUD];

//    if (_progressHUD) {
//        [_progressHUD show:NO];
//        [_progressHUD hide:YES];
//    }
}



- (IBAction)shareButton:(id)sender {
    id<GPPShareBuilder> shareBuilder = [self shareBuilder];
    if (![shareBuilder open]) {
        NSLog(@"Status: Error (see console).");
    }
}
- (id<GPPShareBuilder>)shareBuilder {
    // End editing to make sure all changes are saved to [ShareConfiguration sharedInstance].
    [self.view endEditing:YES];
    
    // Create the share builder instance.
    id<GPPShareBuilder> shareBuilder = [ShareConfiguration sharedInstance].useNativeSharebox ?
    [[GPPShare sharedInstance] nativeShareDialog] :
    [[GPPShare sharedInstance] shareDialog];
    
    if ([ShareConfiguration sharedInstance].urlEnabled) {
        NSString *inputURL = [ShareConfiguration sharedInstance].shareURL;
        NSURL *urlToShare = [inputURL length] ? [NSURL URLWithString:inputURL] : nil;
        if (urlToShare) {
            [shareBuilder setURLToShare:urlToShare];
        }
    }
    
    // Add deep link content.
    if ([ShareConfiguration sharedInstance].deepLinkEnabled) {
        [shareBuilder setContentDeepLinkID:[ShareConfiguration sharedInstance].contentDeepLinkID];
        NSString *title = [ShareConfiguration sharedInstance].contentDeepLinkTitle;
        NSString *description = [ShareConfiguration sharedInstance].contentDeepLinkDescription;
        NSString *urlString = [ShareConfiguration sharedInstance].contentDeepLinkThumbnailURL;
        NSURL *thumbnailURL = urlString.length ? [NSURL URLWithString:urlString] : nil;
        [shareBuilder setTitle:title description:description thumbnailURL:thumbnailURL];
    }
    
    NSString *inputText = [ShareConfiguration sharedInstance].sharePrefillText;
    NSString *text = [inputText length] ? inputText : nil;
    if (text) {
        [shareBuilder setPrefillText:text];
    }
    
    
    // Attach media if we are using the native sharebox and have selected a media element.,
    if ([ShareConfiguration sharedInstance].useNativeSharebox) {
        if ([ShareConfiguration sharedInstance].mediaAttachmentEnabled) {
            if ([ShareConfiguration sharedInstance].attachmentImage) {
                [(id<GPPNativeShareBuilder>)shareBuilder attachImage:[ShareConfiguration sharedInstance].attachmentImage];
            } else if ([ShareConfiguration sharedInstance].attachmentVideoURL) {
                [(id<GPPNativeShareBuilder>)shareBuilder attachVideoURL:
                 [ShareConfiguration sharedInstance].attachmentVideoURL];
            }
        }
        if ([ShareConfiguration sharedInstance].sharePrefillPeople.count) {
            [(id<GPPNativeShareBuilder>)shareBuilder
             setPreselectedPeopleIDs:[ShareConfiguration sharedInstance].sharePrefillPeople];
        }
    }
    
    return shareBuilder;
}

#pragma mark - ListPeopleViewControllerDelegate

- (void)viewController:(ListPeopleViewController *)viewController didPickPeople:(NSArray *)people {
    [ShareConfiguration sharedInstance].sharePrefillPeople = people;
    [self performSelector:@selector(shareButton:) withObject:nil afterDelay:1.0];
    
}


#pragma mark - TWITTER API

- (void)initializeTwitter
{
    // Request access to the Twitter accounts
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        if (granted) {
            
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            
            // Check if the users has setup at least one Twitter account
            
            if (accounts.count > 0)
            {
                ACAccount *twitterAccount = [accounts objectAtIndex:0];
                //                NSLog(@"twitter username %@", [twitterAccount ])
                // Creating a request to get the info about a user on Twitter
                
                SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"] parameters:[NSDictionary dictionaryWithObject:twitterAccount.username forKey:@"screen_name"]];
                [twitterInfoRequest setAccount:twitterAccount];
                
                // Making the request
                
                [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        // Check if we reached the reate limit
                        
                        if ([urlResponse statusCode] == 429) {
                            NSLog(@"Rate limit reached");
                            return;
                        }
                        
                        // Check if there was an error
                        
                        if (error) {
                            NSLog(@"Error: %@", error.localizedDescription);
                            return;
                        }
                        
                        // Check if there is some response data
                        
                        if (responseData) {
                            
                            NSError *error = nil;
                            NSArray *TWData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                            
                            
                            // Filter the preferred data
                            
                            NSString *screen_name = [(NSDictionary *)TWData objectForKey:@"name"];
                            
                            NSString *workAt = [(NSDictionary *)TWData objectForKey:@"location"];
                            
                            //                            NSString *name = [(NSDictionary *)TWData objectForKey:@"name"];
                            //
                            //                            int followers = [[(NSDictionary *)TWData objectForKey:@"followers_count"] integerValue];
                            int following = [[(NSDictionary *)TWData objectForKey:@"friends_count"] integerValue];
                            //                            int tweets = [[(NSDictionary *)TWData objectForKey:@"statuses_count"] integerValue];
                            
                            NSString *profileImageStringURL = [(NSDictionary *)TWData objectForKey:@"profile_image_url_https"];
                            NSString *bannerImageStringURL =[(NSDictionary *)TWData objectForKey:@"profile_banner_url"];
                            
                            
                            // Update the interface with the loaded data
                            
                            
                            NSLog(@"Twitter Screen_name = %@",[NSString stringWithFormat:@"@%@",screen_name]);
                            
                            NSLog(@"Twitter Followings = %@",[NSString stringWithFormat:@"%i", following]);
                            
                            NSLog(@"Twitter Followers = %@",[[(NSDictionary *)TWData objectForKey:@"status"] objectForKey:@"text"]);
                            
                            // Get the profile image in the original resolution
                            
                            profileImageStringURL = [profileImageStringURL stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
                            [self getProfileImageForURLString:profileImageStringURL];
                            
                            fbInfoDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"@%@",screen_name], @"name",@"", @"Date_Of_Birth", @"", @"Home_Town", @"", @"Email_Id", workAt, @"Work_At",  nil];
                            userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
                            
                            
                            
                            // Get the banner image, if the user has one
                            
                            if (bannerImageStringURL) {
                                NSString *bannerURLString = [NSString stringWithFormat:@"%@/mobile_retina", bannerImageStringURL];
                                [self getBannerImageForURLString:bannerURLString];
                            }
                            
                            
                            [appDelegate() showMBHUD:@"Please Wait..."];
                            
                            [PFCloud callFunctionInBackground:@"addSocialDetailTwitter"
                                               withParameters:@{@"userId": userId,
                                                                @"facebookDetail": @"",
                                                                @"gPlusDetail": @"",
                                                                @"twitterDetail": fbInfoDict,
                                                                @"linkedInDetail": @""
                                                                }
                                                        block:^(NSString *results, NSError *error) {
                                                            if (!error) {
                                                                NSLog(@"result: %@",results);
                                                                [appDelegate() dismissMBHUD];
                                                                [self showStatus:@"Twitter information saved successfully." timeout:1];
                                                                
                                                                
                                                                
                                                            }else{
                                                                [appDelegate() dismissMBHUD];
                                                            }
                                                        }];
                            
                            
                        }
                    });
                }];
            }
            else
            {
                NSLog(@"Please configure account in setting");
            }
        } else {
            NSLog(@"No access granted");
        }
    }];
}

- (void) getProfileImageForURLString:(NSString *)urlString;
{
    NSURL *url = [NSURL URLWithString:urlString];
    //    NSData *data = [NSData dataWithContentsOfURL:url];
    
}

- (void) getBannerImageForURLString:(NSString *)urlString;
{
    NSURL *url = [NSURL URLWithString:urlString];
    //    NSData *data = [NSData dataWithContentsOfURL:url];
    
}

- (IBAction)BackBtnAct:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneBtnAct:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
