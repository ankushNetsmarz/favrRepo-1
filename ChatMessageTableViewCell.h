//
//  ChatMessageTableViewCell.h
//  sample-chat
//
//  Created by Igor Khomenko on 10/19/13.
//  Copyright (c) 2013 Igor Khomenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
@interface ChatMessageTableViewCell : UITableViewCell

@property (nonatomic, strong) UITextView  *messageTextView;
@property (nonatomic, strong) UILabel     *dateLabel;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *userSentImageView;
@property (nonatomic, strong) UIButton    *backgroundImageBtnObj;
@property (nonatomic, strong) QBChatDialog *dialog;
@property (nonatomic,strong) NSMutableArray *users;
+ (CGFloat)heightForCellWithMessage:(QBChatAbstractMessage *)message;
- (void)configureCellWithMessage:(QBChatAbstractMessage *)message;

@end
