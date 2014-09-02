//
//  GroupUserDetailsVC.h
//  Favr
//
//  Created by Ankush on 15/07/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "UIImageView+WebCache.h"

#import "AppDelegate.h"
#import "AddContactToVC.h"

@interface GroupUserDetailsVC : UIViewController <UIScrollViewDelegate>
{
    NSArray *groupDetails;
    NSMutableArray *groupUserArray;
    int numberOfUser;
    UIButton *addRemoveButton;
    
    int addRemoveTag;
    NSMutableArray *userIdArray;
    NSMutableArray *objectIdArray;
    
}

@property (nonatomic, retain) NSString *groupID;

@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView1;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView2;

@property (strong, nonatomic) IBOutlet UILabel *groupFullName;

@property (strong, nonatomic) IBOutlet UIImageView *acceptedImageView;
@property (strong, nonatomic) IBOutlet UIButton *acceptedBtnObj;

@property (strong, nonatomic) IBOutlet UILabel *userFullNameHis;

@property (strong, nonatomic) IBOutlet UIImageView *acceptedFavrImageView;
@property (strong, nonatomic) IBOutlet UIImageView *rejectedFavrImageView;
@property (strong, nonatomic) IBOutlet UIButton *acceptedFavrBtnObj;
@property (strong, nonatomic) IBOutlet UIButton *rejectedFavrBtnObj;

@property (strong, nonatomic) IBOutlet UIImageView *askedFavrImageView;
@property (strong, nonatomic) IBOutlet UIButton *askedFavrBtnObj;

@property (strong, nonatomic) IBOutlet UILabel *aboutMeLabel;
@property (strong, nonatomic) IBOutlet UIButton *fbBtnObj;
@property (strong, nonatomic) IBOutlet UIButton *twitterBtnObj;
@property (strong, nonatomic) IBOutlet UIButton *gPlusBtnObj;
@property (strong, nonatomic) IBOutlet UIButton *linkedInBtnObj;

@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;

- (IBAction)addMemberToGroup:(UIButton *)sender;
- (IBAction)removeMemberToGroup:(UIButton *)sender;

- (IBAction)backButtonAct:(UIBarButtonItem *)sender;

- (IBAction)socialSharingBtnAct:(UIButton *)sender;


- (IBAction)addUserToGroup:(UIButton *)sender;
- (IBAction)removeUserFromGroup:(UIButton *)sender;


- (IBAction)backBtnAct:(UIBarButtonItem *)sender;

@end
