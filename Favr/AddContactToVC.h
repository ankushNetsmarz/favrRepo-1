//
//  AddContactToVC.h
//  Favr
//
//  Created by Ankush on 25/07/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "UIImageView+WebCache.h"

@interface AddContactToVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    int selectedIndex;
    NSMutableArray *contactListArray;
    NSString *helperId;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *contactDataArray;

- (IBAction)doneBtnAct:(UIBarButtonItem *)sender;
- (IBAction)backBtnAct:(UIBarButtonItem *)sender;
@end
