//
//  DownloadingVC.h
//  Favr
//
//  Created by Ankush on 14/07/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quickblox/Quickblox.h>

@interface DownloadingVC : UIViewController <QBActionStatusDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *downloadedImage;
@property (nonatomic, assign) int downloadedId;
- (IBAction)bactBtnAction:(UIButton *)sender;

@end
