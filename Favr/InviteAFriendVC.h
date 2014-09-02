//
//  InviteAFriendVC.h
//  Favr
//
//  Created by Ankush on 03/07/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "Parse/Parse.h"
#import "MBProgressHUD.h"
#import "AccessContactVC.h"
#import <MessageUI/MFMessageComposeViewController.h>
@interface InviteAFriendVC : UIViewController < UITableViewDataSource, UITableViewDelegate,MFMessageComposeViewControllerDelegate>
{
    NSMutableArray *contactArray;
    NSMutableArray *tempArray, *findFriendArray;
    MBProgressHUD *hud;
    
    NSArray *mobileContactListArray;
    
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backBtnAct:(UIBarButtonItem *)sender;

@end
