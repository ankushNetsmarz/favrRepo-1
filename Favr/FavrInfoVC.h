//
//  FavrInfoVC.h
//  Favr
//
//  Created by Ankush on 03/07/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
 #import <Quickblox/Quickblox.h>
@interface FavrInfoVC : UIViewController
{
    NSArray *favrInfoArray;
    NSMutableArray *userIdArray;
    NSMutableArray *userGroupIdArray;
    NSMutableArray *userSelectedArray;
    int userIdCount;
    
    BOOL isCreateGroup;
    int k;
    NSMutableArray *getselectedUsersIDs;

}
@property (nonatomic, assign) int pendingFavrStatus;
@property (nonatomic, retain) NSString *incoming_outgoingString;
@property (nonatomic, retain) NSString *favrId;
@property (strong, nonatomic) IBOutlet UILabel *favrTitleLbl;
@property (strong, nonatomic) NSString *navigationTitle;
@property (strong, nonatomic) NSString *strGetTabText;

@property (strong, nonatomic) IBOutlet UILabel *favrDescLabel;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barBtnCompleted;

- (IBAction)backBtnAct:(UIBarButtonItem *)sender;
- (IBAction)FavrRejectedBtnAct:(UIButton *)sender;
- (IBAction)favrAcceptedBtnAct:(UIButton *)sender;
- (IBAction)favrChatBtnAct:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *favrAcceptBtnObj;
@property (strong, nonatomic) IBOutlet UIButton *favrRejectButtonObj;

@property (strong, nonatomic) IBOutlet UILabel *whenLabel;
@property (strong, nonatomic) IBOutlet UILabel *quidProLabel;

@end
