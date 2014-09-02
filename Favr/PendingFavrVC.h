//
//  PendingFavrVC.h
//  Favr
//
//  Created by Taranjit Singh on 17/06/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "CreateFavrVC.h"
#import "Parse/Parse.h"
#import "MBProgressHUD.h"
#import "FavrInfoVC.h"
#import "ChatUserListVC.h"
#import "MyChattingVC.h"
#import "CreateFavrGroupVC.h"
#import "EGORefreshTableHeaderView.h"


@interface PendingFavrVC : UIViewController < UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate,  UIActionSheetDelegate,EGORefreshTableHeaderDelegate,QBActionStatusDelegate >
{
    MBProgressHUD *hud;
    UILabel *favourNumberLabel;
    UILabel *profileNameLabel;
    UIButton *profileInfoBtn;
    BOOL editingModeOn;
    NSMutableArray *indexArray;
    int   rowNumber;
     int userIdCount;
    NSMutableArray *outgoingFavrListArray;
    NSMutableArray *outgoingFavrUserInfo;
    NSMutableArray *tempOutgoingFavrListArray;
    
    NSMutableArray *incomingFavrListArray;
    NSMutableArray *incomingFavrUserArray;
    NSMutableArray *tempIncomingFavrListArray;
    
    NSMutableArray *tempIncomingOutgoingFavrListArray;
    NSMutableArray *tempIncomingOutgoingFavrUserArray;
    
    UITableViewController *tableViewController;
    UIRefreshControl *refresh;
    BOOL pullToRefreshBool;
    
    UIAlertView *incomingOutgoingAlert;
    
    UILabel *_lblWhenNoData;
    
    ///*********Refresh TableViewHeader Implementation******************
    
    EGORefreshTableHeaderView *_refreshHeaderView;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes
	BOOL _reloading;
    
    NSMutableArray *userIdArray;
    NSMutableArray *userGroupIdArray;
    NSMutableArray *userSelectedArray;
    int favrInteger;
    NSString *inCommingHelperID;
    NSString *outGoingHelperID;
    //int userIdCount;
    BOOL isCreateGroup;
    int k;
    NSMutableArray *getselectedUsersIDs;
    BOOL isRefreshData;
}


//@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;


@property(nonatomic,weak)IBOutlet UITableView* tableView;
@property(nonatomic,weak)IBOutlet UINavigationBar* navigationBar;
@property(nonatomic,weak)IBOutlet UISegmentedControl* segmentControl;

-(IBAction)listIncomingOutgoing:(UISegmentedControl*)sender;
- (IBAction)deleteButtonAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteBarBtnObj;
- (IBAction)newFavrAct:(UIBarButtonItem *)sender  forEvent:(UIEvent*)event;
//@property (strong, nonatomic) IBOutlet UIBarButtonItem *newFavrBtnObj;

@end
