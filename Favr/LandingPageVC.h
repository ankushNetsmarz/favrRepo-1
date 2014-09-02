//
//  LandingPageVC.h
//  Favr
//
//  Created by Ankush on 10/06/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CreateFavrGroupVC.h"
#import "CreateFavrVC.h"
#import "TSPopoverController.h"
#import "GroupTableCell.h"
#import "GroupUserDetailsVC.h"
#import "ContactTableCell.h"
#import "EGORefreshTableHeaderView.h"

@interface LandingPageVC : UIViewController <UITableViewDataSource,UITableViewDelegate, UIAlertViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate,EGORefreshTableHeaderDelegate>
{
    NSArray *pickerDataArray;
    NSMutableArray *phoneNumbers;
    NSMutableArray *findFriendArray;
    NSMutableArray *tempArray;
    NSString *contact_group;
    CGRect tableRect;
    UITableViewController *tableViewController;
    UIRefreshControl *refresh;
    BOOL pullToRefreshBool;
    
    UIView *popupView;
    
    TSPopoverController *popoverController;
    NSString *userId;
    NSMutableArray *groupIDArray;
    NSMutableArray *groupDetailsArray;
    NSMutableArray *temproryGroupDetailsArray;
    UILabel *_lblWhenNoData;
    
    ///*********Refresh TableViewHeader Implementation******************
    
    EGORefreshTableHeaderView *_refreshHeaderView;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes
	BOOL _reloading;
    
    
}
@property(nonatomic,weak)IBOutlet UITableView* tableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property(nonatomic,weak)IBOutlet UINavigationBar* navigationBar;
@property (strong, nonatomic) IBOutlet UIButton *fetchFriendListFirstTimeObj;
@property (strong, nonatomic) IBOutlet UIButton *countryCodeObj;
@property (strong, nonatomic) IBOutlet UITextField *mobileNumberTxtFld;
@property (strong, nonatomic) IBOutlet UIButton *goObj;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuBarBtn;
@property (strong, nonatomic) IBOutlet UIPickerView *countryCodePickerView;
@property (strong, nonatomic) IBOutlet UIButton *createAGroupObj;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtnObj;

- (IBAction)fetchFriendListFirstTimeAct:(UIButton *)sender;
- (IBAction)countryCodeAct:(UIButton *)sender;
- (IBAction)goAct:(UIButton *)sender;
- (IBAction)createAGroupAction:(UIButton *)sender;
- (IBAction)contactGroupSegmentAct:(UISegmentedControl *)sender;
-(IBAction)reloadContactsTableView:(id)sender forEvent:(UIEvent*)event;
- (IBAction)cancelAct:(UIButton *)sender;



@end
