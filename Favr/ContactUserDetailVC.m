//
//  ContactUserDetailVC.m
//  Favr
//
//  Created by Ankush on 27/06/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "ContactUserDetailVC.h"
#import "Parse/Parse.h"
#import "UIImageView+WebCache.h"

@interface ContactUserDetailVC ()

@end

@implementation ContactUserDetailVC
@synthesize userId;

#pragma mark ViewLifeCycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.acceptedImageView.backgroundColor = [UIColor redColor];
    self.acceptedFavrImageView.backgroundColor = [UIColor redColor];
    self.rejectedFavrImageView.backgroundColor = [UIColor colorWithRed:90.0/255.0 green:190.0/255 blue:202.0/255 alpha:1];
    self.askedFavrImageView.backgroundColor = [UIColor colorWithRed:90.0/255.0 green:190.0/255 blue:202.0/255 alpha:1];
    self.acceptedImageView.layer.cornerRadius = 20.0f;
    self.acceptedFavrImageView.layer.cornerRadius = 8.0f;
    self.askedFavrImageView.layer.cornerRadius = 8.0f;
    self.profileImageView.layer.cornerRadius = 55.0f;
    self.rejectedFavrImageView.layer.cornerRadius = 20.0f;
    
    self.acceptedImageView.layer.masksToBounds=YES;
    self.acceptedFavrImageView.layer.masksToBounds = YES;
    self.askedFavrImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.masksToBounds = YES;
    
    [appDelegate() CheckInternetConnection];
    if([appDelegate() internetWorking] ==0){
        
    }
    else
    {
        UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please connect to internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_alertView show];
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
             userDetails = [[NSArray alloc] initWithArray:results];
             [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:[[results objectAtIndex:0] valueForKey:@"profilePicPath"]] placeholderImage:[UIImage imageNamed:@"profileImage.png"]];
             self.userFullName.text = [[results objectAtIndex:0] valueForKey:@"fullName"];
             [self.acceptedBtnObj setTitle:[NSString stringWithFormat:@"%@", [[results objectAtIndex:0] valueForKey:@"noOfFavrAccepted"]] forState:UIControlStateNormal];
             [self.acceptedFavrBtnObj setTitle:[NSString stringWithFormat:@"%@", [[results objectAtIndex:0] valueForKey:@"noOfFavrAccepted"]] forState:UIControlStateNormal];
             
             [self.rejectedFavrBtnObj setTitle:[NSString stringWithFormat:@"%@", [[results objectAtIndex:0] valueForKey:@"noOfFavrRejected"]] forState:UIControlStateNormal] ;
             [self.askedFavrBtnObj setTitle:[NSString stringWithFormat:@"%@", [[results objectAtIndex:0] valueForKey:@"asHelpeeCount"]] forState:UIControlStateNormal];
             self.userFullNameHis.text = [[results objectAtIndex:0] valueForKey:@"fullName"];
             
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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    NSLog(@"userId %@", userId);
    
//    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.labelText = @"Loading";
//
//    [PFCloud callFunctionInBackground:@"getDetailUser"
//                       withParameters:@{
//                                        @"userId": userId
//                                        }
//                                block:^(NSArray *results, NSError *error)
//                    {
//                                    if (!error)
//                                    {
//                                        
//                                        [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:[[results objectAtIndex:0] valueForKey:@"profilePicPath"]] placeholderImage:[UIImage imageNamed:@"profileImage.png"]];
//                                        self.userFullName.text = [[results objectAtIndex:0] valueForKey:@"fullName"];
//                                        [self.acceptedBtnObj setTitle:[NSString stringWithFormat:@"%@", [[results objectAtIndex:0] valueForKey:@"noOfFavrAccepted"]] forState:UIControlStateNormal];
//                                        [self.acceptedFavrBtnObj setTitle:[NSString stringWithFormat:@"%@", [[results objectAtIndex:0] valueForKey:@"noOfFavrAccepted"]] forState:UIControlStateNormal];
//                                        [self.askedFavrBtnObj setTitle:[NSString stringWithFormat:@"%@", [[results objectAtIndex:0] valueForKey:@"asHelpeeCount"]] forState:UIControlStateNormal];
//                                        self.userFullNameHis.text = [[results objectAtIndex:0] valueForKey:@"fullName"];
//                                        [hud hide:YES];
//                                        
//                                    }
//                                    else
//                                    {
//                                        NSLog(@"Error Occured");
//                                    }
//                    }
//     ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Show Alertview

-(void)showAlertWithText:(NSString*)title :(NSString*)message
{
    UIAlertView* validationAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [validationAlert show]
    ;
}

#pragma mark OtherMethod
// navigate to previous view
- (IBAction)backButtonAct:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

// display FB, Twitter, LinkedIn, Google + data and display in label
- (IBAction)socialSharingBtnAct:(UIButton *)sender {
    
    if (sender.tag == 1)
    {
        
        
        
        if ( ( [[[[userDetails objectAtIndex:0] valueForKey:@"facebookDetail"] valueForKey:@"name"] length] <=0 ))
        {
            self.aboutMeLabel.text = @"No Facebook Data Found";
        }
        else
        {
            
            NSString *strDOB;
            NSString *strEmail;
            NSString *strHMT;
            NSString *strWrkAt;
            
            
            
            if ((NSNull*)[[[userDetails objectAtIndex:0] valueForKey:@"facebookDetail"] valueForKey:@"Date_Of_Birth"]==NULL)
                strDOB = @"NA";
            else
                strDOB = [[[userDetails objectAtIndex:0] valueForKey:@"facebookDetail"] valueForKey:@"Date_Of_Birth"];
            
            if ((NSNull*)[[[userDetails objectAtIndex:0] valueForKey:@"facebookDetail"] valueForKey:@"Home_Town"]==NULL)
                strHMT = @"NA";
            else
                strHMT = [[[userDetails objectAtIndex:0] valueForKey:@"facebookDetail"] valueForKey:@"Home_Town"];
            
            if ((NSNull*)[[[userDetails objectAtIndex:0] valueForKey:@"facebookDetail"] valueForKey:@"Email_Id"]==NULL)
                strEmail = @"NA";
            else
                strEmail = [[[userDetails objectAtIndex:0] valueForKey:@"facebookDetail"] valueForKey:@"Email_Id"];
            
            if ((NSNull*)[[[userDetails objectAtIndex:0] valueForKey:@"facebookDetail"] valueForKey:@"Work_At"] ==NULL)
                strWrkAt = @"NA";
            else
                strWrkAt = [[[userDetails objectAtIndex:0] valueForKey:@"facebookDetail"] valueForKey:@"Work_At"];

            
            
            self.aboutMeLabel.text = [[NSString alloc] initWithFormat:@"About Me:- \nDate Of Birth:- %@ \nHome Town:- %@ \nEmail id:- %@ \nWork At:- %@", strDOB, strHMT, strEmail, strWrkAt];
        }
        
        [self.fbBtnObj setImage:[UIImage imageNamed:@"face_book_icon"] forState:UIControlStateNormal];
        [self.twitterBtnObj setImage:[UIImage imageNamed:@"twitter_white"] forState:UIControlStateNormal];
        [self.gPlusBtnObj setImage:[UIImage imageNamed:@"g_plus_white"] forState:UIControlStateNormal];
        [self.linkedInBtnObj setImage:[UIImage imageNamed:@"LinkedIn_white"] forState:UIControlStateNormal];
        
    }
    else if (sender.tag == 2)
    {
        if ( ( [[[[userDetails objectAtIndex:0] valueForKey:@"twitterDetail"] valueForKey:@"name"] length] <=0 ))
        {
            self.aboutMeLabel.text = @"No Twitter Data Found";
        }
        else
        {
            
            NSString *strDOB;
            NSString *strEmail;
            NSString *strHMT;
            NSString *strWrkAt;
            
            
            
            if ((NSNull*)[[[userDetails objectAtIndex:0] valueForKey:@"twitterDetail"] valueForKey:@"Date_Of_Birth"]==NULL ||[[[[userDetails objectAtIndex:0] valueForKey:@"twitterDetail"] valueForKey:@"Date_Of_Birth"] isEqualToString:@""])
                strDOB = @"NA";
            else
                strDOB = [[[userDetails objectAtIndex:0] valueForKey:@"twitterDetail"] valueForKey:@"Date_Of_Birth"];
            
            if ((NSNull*)[[[userDetails objectAtIndex:0] valueForKey:@"twitterDetail"] valueForKey:@"Home_Town"]==NULL||[[[[userDetails objectAtIndex:0] valueForKey:@"twitterDetail"] valueForKey:@"Home_Town"] isEqualToString:@""])
                strHMT = @"NA";
            else
                strHMT = [[[userDetails objectAtIndex:0] valueForKey:@"twitterDetail"] valueForKey:@"Home_Town"];
            
            if ((NSNull*)[[[userDetails objectAtIndex:0] valueForKey:@"twitterDetail"] valueForKey:@"Email_Id"]==NULL||[[[[userDetails objectAtIndex:0] valueForKey:@"twitterDetail"] valueForKey:@"Email_Id"] isEqualToString:@""])
                strEmail = @"NA";
            else
                strEmail = [[[userDetails objectAtIndex:0] valueForKey:@"twitterDetail"] valueForKey:@"Email_Id"];
            
            if ((NSNull*)[[[userDetails objectAtIndex:0] valueForKey:@"twitterDetail"] valueForKey:@"Work_At"] ==NULL||[[[[userDetails objectAtIndex:0] valueForKey:@"twitterDetail"] valueForKey:@"Work_At"] isEqualToString:@""])
                strWrkAt = @"NA";
            else
                strWrkAt = [[[userDetails objectAtIndex:0] valueForKey:@"twitterDetail"] valueForKey:@"Work_At"];
            
            
            
            self.aboutMeLabel.text = [[NSString alloc] initWithFormat:@"About Me:- \nDate Of Birth:- %@ \nHome Town:- %@ \nEmail id:- %@ \nWork At:- %@", strDOB, strHMT, strEmail, strWrkAt];
        }

        
        [self.fbBtnObj setImage:[UIImage imageNamed:@"face_book_icon_white"] forState:UIControlStateNormal];
        [self.twitterBtnObj setImage:[UIImage imageNamed:@"twitter"] forState:UIControlStateNormal];
        [self.gPlusBtnObj setImage:[UIImage imageNamed:@"g_plus_white"] forState:UIControlStateNormal];
        [self.linkedInBtnObj setImage:[UIImage imageNamed:@"LinkedIn_white"] forState:UIControlStateNormal];
    }
    else if (sender.tag == 3)
    {
       
        
        
        
        if ( ( [[[[userDetails objectAtIndex:0] valueForKey:@"gPlusDetail"] valueForKey:@"name"] length] <=0 ))
        {
             self.aboutMeLabel.text = @"No Google plus Data Found";
        }
        else
        {
            
            NSString *strDOB;
            NSString *strEmail;
            NSString *strHMT;
            NSString *strWrkAt;
            
            
            
            if ((NSNull*)[[[userDetails objectAtIndex:0] valueForKey:@"gPlusDetail"] valueForKey:@"Date_Of_Birth"]==NULL||[[[[userDetails objectAtIndex:0] valueForKey:@"twitterDetail"] valueForKey:@"Date_Of_Birth"] isEqualToString:@""])
                strDOB = @"NA";
            else
                strDOB = [[[userDetails objectAtIndex:0] valueForKey:@"gPlusDetail"] valueForKey:@"Date_Of_Birth"];
            
            if ((NSNull*)[[[userDetails objectAtIndex:0] valueForKey:@"gPlusDetail"] valueForKey:@"Home_Town"]==NULL||[[[[userDetails objectAtIndex:0] valueForKey:@"twitterDetail"] valueForKey:@"Home_Town"] isEqualToString:@""])
                strHMT = @"NA";
            else
                strHMT = [[[userDetails objectAtIndex:0] valueForKey:@"gPlusDetail"] valueForKey:@"Home_Town"];
            
            if ((NSNull*)[[[userDetails objectAtIndex:0] valueForKey:@"gPlusDetail"] valueForKey:@"Email_Id"]==NULL||[[[[userDetails objectAtIndex:0] valueForKey:@"twitterDetail"] valueForKey:@"Email_Id"] isEqualToString:@""])
                strEmail = @"NA";
            else
                strEmail = [[[userDetails objectAtIndex:0] valueForKey:@"gPlusDetail"] valueForKey:@"Email_Id"];
            
            if ((NSNull*)[[[userDetails objectAtIndex:0] valueForKey:@"gPlusDetail"] valueForKey:@"Work_At"] ==NULL||[[[[userDetails objectAtIndex:0] valueForKey:@"twitterDetail"] valueForKey:@"Work_At"] isEqualToString:@""])
                strWrkAt = @"NA";
            else
                strWrkAt = [[[userDetails objectAtIndex:0] valueForKey:@"gPlusDetail"] valueForKey:@"Work_At"];
            
            
            
            self.aboutMeLabel.text = [[NSString alloc] initWithFormat:@"About Me:- \nDate Of Birth:- %@ \nHome Town:- %@ \nEmail id:- %@ \nWork At:- %@", strDOB, strHMT, strEmail, strWrkAt];
        }

        
        [self.fbBtnObj setImage:[UIImage imageNamed:@"face_book_icon_white"] forState:UIControlStateNormal];
        [self.twitterBtnObj setImage:[UIImage imageNamed:@"twitter_white"] forState:UIControlStateNormal];
        [self.gPlusBtnObj setImage:[UIImage imageNamed:@"g_plus_icon"] forState:UIControlStateNormal];
        [self.linkedInBtnObj setImage:[UIImage imageNamed:@"LinkedIn_white"] forState:UIControlStateNormal];
    }
    else
    {
        
        
        if ( ( [[[[userDetails objectAtIndex:0] valueForKey:@"linkedInDetail"] valueForKey:@"name"] length] <=0 ))
        {
            self.aboutMeLabel.text = @"No LinkedIn Data Found";
        }
        else
        {
            
            NSString *strDOB;
            NSString *strEmail;
            NSString *strHMT;
            NSString *strWrkAt;
            
            
            
            if ((NSNull*)[[[userDetails objectAtIndex:0] valueForKey:@"linkedInDetail"] valueForKey:@"Date_Of_Birth"]==NULL||[[[[userDetails objectAtIndex:0] valueForKey:@"twitterDetail"] valueForKey:@"Date_Of_Birth"] isEqualToString:@""])
                strDOB = @"NA";
            else
                strDOB = [[[userDetails objectAtIndex:0] valueForKey:@"linkedInDetail"] valueForKey:@"Date_Of_Birth"];
            
            if ((NSNull*)[[[userDetails objectAtIndex:0] valueForKey:@"linkedInDetail"] valueForKey:@"Home_Town"]==NULL||[[[[userDetails objectAtIndex:0] valueForKey:@"twitterDetail"] valueForKey:@"Home_Town"] isEqualToString:@""])
                strHMT = @"NA";
            else
                strHMT = [[[userDetails objectAtIndex:0] valueForKey:@"linkedInDetail"] valueForKey:@"Home_Town"];
            
            if ((NSNull*)[[[userDetails objectAtIndex:0] valueForKey:@"linkedInDetail"] valueForKey:@"Email_Id"]==NULL||[[[[userDetails objectAtIndex:0] valueForKey:@"twitterDetail"] valueForKey:@"Email_Id"] isEqualToString:@""])
                strEmail = @"NA";
            else
                strEmail = [[[userDetails objectAtIndex:0] valueForKey:@"linkedInDetail"] valueForKey:@"Email_Id"];
            
            if ((NSNull*)[[[userDetails objectAtIndex:0] valueForKey:@"linkedInDetail"] valueForKey:@"Work_At"] ==NULL||[[[[userDetails objectAtIndex:0] valueForKey:@"twitterDetail"] valueForKey:@"Work_At"] isEqualToString:@""])
                strWrkAt = @"NA";
            else
                strWrkAt = [[[userDetails objectAtIndex:0] valueForKey:@"linkedInDetail"] valueForKey:@"Work_At"];
            
            
            
            self.aboutMeLabel.text = [[NSString alloc] initWithFormat:@"About Me:- \nDate Of Birth:- %@ \nHome Town:- %@ \nEmail id:- %@ \nWork At:- %@", strDOB, strHMT, strEmail, strWrkAt];
        }
        
        [self.fbBtnObj setImage:[UIImage imageNamed:@"face_book_icon_white"] forState:UIControlStateNormal];
        [self.twitterBtnObj setImage:[UIImage imageNamed:@"twitter_white"] forState:UIControlStateNormal];
        [self.gPlusBtnObj setImage:[UIImage imageNamed:@"g_plus_white"] forState:UIControlStateNormal];
        [self.linkedInBtnObj setImage:[UIImage imageNamed:@"LinkedIn_icon"] forState:UIControlStateNormal];
    }
}

@end
