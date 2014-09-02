//
//  VideoTesting.h
//  Favr
//
//  Created by Ankush on 01/08/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Quickblox/Quickblox.h"
#import "Parse/Parse.h"

@interface VideoTesting : UIViewController

@property (nonatomic, retain) NSString *moviePath;
@property (nonatomic, retain) NSString *videoFile;

@property (strong, nonatomic) IBOutlet UIImageView *uploadImageView;
@property (strong, nonatomic) IBOutlet UIImageView *downloadImageView;

@end
