//
//  SocialMediaVC.h
//  Favr
//
//  Created by Ankush on 03/07/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListPeopleViewController.h"
#import <GooglePlus/GooglePlus.h>
#import "OAuthLoginView.h"
#import "JSONKit.h"
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
#import "OATokenManager.h"
#import "Parse/Parse.h"

@class GPPSignInButton;
@interface SocialMediaVC : UIViewController<GPPSignInDelegate,ListPeopleViewControllerDelegate,UIScrollViewDelegate>
{
    NSDictionary *fbProfileDetailsDict, *fbInfoDict;
    NSString *userId;
    UIAlertView *_alertView;
}
@property (retain, nonatomic) IBOutlet UIButton *googleButton;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property(weak,nonatomic)IBOutlet UIView* socialSharingView;
@property(weak,nonatomic)IBOutlet UISwitch* switchGoogleP;

-(IBAction)socialSwitchesActivation:(UISwitch*)sender;


- (IBAction)BackBtnAct:(UIBarButtonItem *)sender;
- (IBAction)doneBtnAct:(UIBarButtonItem *)sender;

@end
