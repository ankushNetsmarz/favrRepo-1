//
//  SettingVC.h
//  Favr
//
//  Created by Ankush on 24/06/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AboutVC.h"
#import "InviteAFriendVC.h"
#import "SocialMediaVC.h"
#import "GroupNameAndDetailVC.h"
#import "SettingVCCell.h"
#import "DownloadingVC.h"
#import "Quickblox/Quickblox.h"
#import "SocialSyncVC.h"
#import "VideoTesting.h"


@interface SettingVC : UIViewController <UITableViewDataSource, UITableViewDelegate, QBActionStatusDelegate>
{
    NSArray *settingArray;
    NSArray *settingImageArray;
    int uploadedImageId;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;

@end
