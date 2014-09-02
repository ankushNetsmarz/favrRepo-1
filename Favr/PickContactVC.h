//
//  PickContactVC.h
//  Favr
//
//  Created by Ankush on 01/07/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "Parse/Parse.h"
#import "PendingFavrVC.h"

@interface PickContactVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
{
    NSArray *contactListArray;
    int rowNumber;
    NSArray *selectedRows;
    NSString *contact_Group;
    NSMutableArray *addedFavrListArray;
    NSString *dateString;
    UIAlertView *statusAlert;
    NSString *userId;
    NSMutableArray *groupIDArray;
    NSMutableArray *temproryGroupDetailsArray;
    NSMutableArray *groupDetailsArray;
    int selectedIndex;
    NSString *singleUser, *multiUser, *groupUser;
    
    NSString *helpeeImage, *helpeeName;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *contactDataArray;
@property (strong, nonatomic) NSMutableArray *groupDataArray;
@property (strong, nonatomic) NSString *favrTitleString;
@property (strong, nonatomic) NSString *favrDescriptionString;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;

- (IBAction)backBtnAct:(UIBarButtonItem *)sender;
- (IBAction)backBtnAction:(UIBarButtonItem *)sender;
- (IBAction)doneBtnAct:(UIBarButtonItem *)sender;
- (IBAction)contactGroupSegmentControl:(UISegmentedControl *)sender;

@property (strong, nonatomic) NSString *whenString;
@property (strong, nonatomic) NSString *privicyString;
@property (strong, nonatomic) NSString *quidProString;

@end
