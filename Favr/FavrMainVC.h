//
//  FavrMainVC.h
//  Favr
//
//  Created by Taranjit Singh on 14/06/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "CreateFavrVC.h"
#import "EGORefreshTableHeaderView.h"

@interface FavrMainVC : UIViewController<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate,EGORefreshTableHeaderDelegate,QBActionStatusDelegate>
{
    
    UIImageView *profileImageView;
    UILabel *favourNumberLabel;
    UILabel *profileNameLabel;
    UIButton *profileInfoBtn;
    BOOL  editingModeOn;
    int   rowNumber;
    
    
    NSMutableArray *incomingFavrListArray;
    NSMutableArray *incomingFavrUserArray;
    NSMutableArray *tempIncomingFavrListArray;
    
    NSMutableArray *outgoingFavrListArray;
    NSMutableArray *outgoingFavrUserInfo;
    NSMutableArray *tempOutgoingFavrListArray;
    
    
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
    int userIdCount;
    
    BOOL isCreateGroup;
    int k;
    NSMutableArray *getselectedUsersIDs;
    
}
@property (nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic,weak)IBOutlet UITableView* tableView;
@property(nonatomic,weak)IBOutlet UINavigationBar* navigationBar;
@property(nonatomic,weak)IBOutlet UISegmentedControl* segmentControl;
-(IBAction)listIncomingOutgoing:(UISegmentedControl*)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteButtonObj;
- (IBAction)deleteButtonAction:(UIBarButtonItem *)sender;
- (IBAction)newFavrAct:(UIBarButtonItem *)sender  forEvent:(UIEvent*)event;
@end
