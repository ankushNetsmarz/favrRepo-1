//
//  LoginScreenVC.m
//  Favr
//
//  Created by Taranjit Singh on 27/05/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//
@import QuartzCore;
#import "LoginScreenVC.h"
#import "AccessContactVC.h"
#import "SocialSyncVC.h"
#import <Parse/Parse.h>
#import "signUp.h"
#import "ChatSharedManager.h"

@interface LoginScreenVC ()

@end


@implementation LoginScreenVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    [appDelegate()dismissMBHUD];
    [super viewDidAppear:animated];
}


- (void)viewDidLoad
{

    [super viewDidLoad];
	// Do any additional setup after loading the view.
   
    self.mySwitch.transform = CGAffineTransformMakeScale(0.80, 0.60);
    
    self.btnLogin.layer.cornerRadius = 15.0f;
    self.btnLogin.layer.masksToBounds=YES;
    
    self.btnSignUp.layer.cornerRadius = 15.0f;
    self.btnSignUp.layer.masksToBounds=YES;
    
    self.passwordView.layer.cornerRadius = 15.0f;
    self.passwordView.layer.masksToBounds=YES;
    self.userNameView.layer.cornerRadius = 15.0f;
    self.userNameView.layer.masksToBounds=YES;
    NSString* usrProfImagePath = @"~/Documents/userFBImage.png";
    UIImage* tempImage = [UIImage imageWithContentsOfFile:[usrProfImagePath stringByExpandingTildeInPath]];
    //[[AccessContactVC sharedManager] userFBImage];
    self.userFBPic.image = tempImage;
    self.userFBPic.layer.cornerRadius = 50.0f;
    self.userFBPic.layer.masksToBounds=YES;
    self.userFBPic.contentMode = UIViewContentModeScaleAspectFill;
    
    
  NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:@"loggedInUserEmail"];
  NSString *name=  [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    self.txtEmailId.text = [NSString stringWithFormat:@"%@",email];
    self.txtUserName = [NSString stringWithFormat:@"%@",name];
    
   
    
    if (email.length==0)
    {
        self.txtEmailId.text = @"";
        [self showAlertWithText:@"Error" :@"Unable to found default Email Address."];
    }
    
    
   UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    _tap.enabled = YES;
    [self.view addGestureRecognizer:_tap];

    
}

#pragma mark- call method to resign keyboard when user touch the uiview
-(void)hideKeyboard{
    CGPoint point = CGPointMake(0,0);
    [self.mailViewScroll setContentOffset:point animated:YES];
    [_txtEmailId resignFirstResponder];
    [_txtPassword resignFirstResponder];
}


- (IBAction)signMeUp:(id)sender {
    CGPoint point = CGPointMake(0,0);
    [self.mailViewScroll setContentOffset:point animated:YES];
    [_txtEmailId resignFirstResponder];
    [_txtPassword resignFirstResponder];
    
}
- (IBAction)logMeUp:(id)sender {
    
    
    [appDelegate() CheckInternetConnection];
    if([appDelegate() internetWorking] ==0){
    
    }
        else
        {
            UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please connect to internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [_alertView show];
            return;
        }
    
    
    
    
    if(![self validateFields])
        return;
    NSLog(@"email: %@", _txtEmailId.text);
    
    CGPoint point = CGPointMake(0,0);
    [self.mailViewScroll setContentOffset:point animated:YES];
    [_txtEmailId resignFirstResponder];
    [_txtPassword resignFirstResponder];
    
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
    NSString *resultString = [[self.txtEmailId.text componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@"."];
    NSLog (@"Result: %@", resultString);

    NSString* chatUserName = resultString;
    [[NSUserDefaults standardUserDefaults]setObject:chatUserName forKey:@"chatUserName"];
    [[NSUserDefaults standardUserDefaults]setObject:self.txtPassword.text forKey:@"password"];

    
    [appDelegate() showMBHUD:@"Please Wait..."];
    
    
    [PFCloud callFunctionInBackground:@"logIn"
                       withParameters:@{@"emailId": self.txtEmailId.text,
                                        @"pwd":self.txtPassword.text
                                        }
                                block:^(NSString *results, NSError *error)
    {
                                    if (!error)
                                {
                                        NSLog(@"result: %@",results);
                                    [appDelegate() dismissMBHUD];
                                    appDelegate().isFromSignUpPage = NO;
                                    appDelegate().getrootType  = fromloginVC;
                                    NSData *jsonData = [results dataUsingEncoding:NSUTF8StringEncoding];
                                    NSError *error = nil;
                                    NSDictionary *myDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
                                    if(!myDictionary)
                                    {
                                        NSLog(@"%@",error);
                                        [appDelegate() dismissMBHUD];
                                        UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"Server not responding. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                        [_alertView show];
                                        
                                    }
                                    else
                                    {
                                        NSLog(@"%@", myDictionary);
                                    }
                                    
                                    if ([[myDictionary objectForKey:@"success"] integerValue] == 0)
                                    {
                                        [self showAlertWithText:@"Favr" :[myDictionary objectForKey:@"message"]];
                                    }
                                    else if ([[myDictionary objectForKey:@"success"] integerValue] == 1)
                                    {
                                        
                                        appDelegate().userLogout = Login;
                                        [[NSUserDefaults standardUserDefaults] setObject:self.txtPassword.text forKey:@"loggedInUserPassword"];
                                        [[NSUserDefaults standardUserDefaults] setObject:self.txtEmailId.text forKey:@"loggedInUserEmail"];
                                        
                                        [[NSUserDefaults standardUserDefaults] setObject:[[[myDictionary objectForKey:@"data"] objectAtIndex:0] objectForKey:@"objectId"] forKey:@"userId"];
                                        
//                                        [[NSUserDefaults standardUserDefaults] setObject:[[myDictionary objectAtIndex:0] valueForKey:@"objectId"] forKey:@"userId"];
                                        NSLog(@"userid %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"]);
                                        
                                        [[NSUserDefaults standardUserDefaults] setObject:[[[myDictionary objectForKey:@"data"] objectAtIndex:0] objectForKey:@"userMobileNo"] forKey:@"mobileNumbers"];
                                        
                                        if ([[[[myDictionary objectForKey:@"data"] objectAtIndex:0] objectForKey:@"isNumberVerified"] integerValue]==0) {
                                            appDelegate().isNumberVerified = NO;
                                        }else{
                                            appDelegate().isNumberVerified = YES;
                                        }
                                        
                                   //     NSLog(@"______________________________%@",[[[myDictionary objectForKey:@"data"] objectAtIndex:0] objectForKey:@"userMobileNo"]);
                                        
//                                        [[NSUserDefaults standardUserDefaults] setObject:[results valueForKey:@"userMobileNo"] forKey:@"mobileNumbers"];
                                        
                                        [[NSUserDefaults standardUserDefaults]synchronize];
                                        [self performSegueWithIdentifier:@"loginToLandingSague"  sender:nil];
                                        [[ChatSharedManager sharedManager] setTxtUserName:chatUserName];
                                        [[ChatSharedManager sharedManager] setTxtUserPassword:self.txtPassword.text];
                                        [[ChatSharedManager sharedManager] loginChatFunction:@"LOGIN"];
                                        
                                        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                        appDelegate.loginSignupFlag = 2;
                                        

                                    }
                                    
                                  
                                }else{
                                
                                    [appDelegate() dismissMBHUD];
                                    UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"Server not responding. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                    [_alertView show];
                                
                                }
        
    }
    ];
}

-(BOOL)validateFields{
     
    if(self.txtEmailId.text.length == 0 ){
        [self showAlertWithText:@"Error" :@"Please enter a valid Email Address"];
        return NO;
    }
    if(self.txtPassword.text.length==0){
        [self showAlertWithText:@"Error" :@"Please enter valid password!"];
        return NO;
    }
    
    return YES;
}

-(void)showAlertWithText:(NSString*)title :(NSString*)message{
    UIAlertView* validationAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [validationAlert show]
    ;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    CGPoint point = CGPointMake(0,0);
    [self.mailViewScroll setContentOffset:point animated:YES];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGPoint point = CGPointMake(0,152);
    [self.mailViewScroll setContentOffset:point animated:YES];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
//    CGPoint point = CGPointMake(0,0);
//    [self.mailViewScroll setContentOffset:point animated:YES];
//    [_txtEmailId resignFirstResponder];
//    [_txtPassword resignFirstResponder];
    
    
    NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:@"loggedInUserEmail"];
    if (email.length==0)
    {
        self.txtEmailId.text = @"";
    }
    
    NSString *username;
    if ([NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"name"]].length>0) {
         username=   [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    }
    else{
    username = @"";
    
    }
 
    if([segue.identifier isEqualToString:@"gotoSignUpScreen"]){
        signUp* destVC = (signUp*)[segue destinationViewController];
        destVC.txtEmail.text= self.txtEmailId.text;
        destVC.txtPassword.text = self.txtPassword.text;
        destVC.usrEmail= self.txtEmailId.text;
        destVC.usrName = username;
        destVC.usrPasswd= self.txtPassword.text;
        destVC.profileImage = self.userFBPic.image;
    }
}
@end
