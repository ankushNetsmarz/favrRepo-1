//
//  ChatMessageTableViewCell.m
//  sample-chat
//
//  Created by Igor Khomenko on 10/19/13.
//  Copyright (c) 2013 Igor Khomenko. All rights reserved.
//

#import "ChatMessageTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ChatSharedManager.h"
#import "MediaPlayer/MediaPlayer.h"
#define padding 20

@implementation ChatMessageTableViewCell

static NSDateFormatter *messageDateFormatter;
static UIImage *orangeBubble;
static UIImage *aquaBubble;

@synthesize users = _users;

+ (void)initialize{
    [super initialize];
    
    // init message datetime formatter
    messageDateFormatter = [[NSDateFormatter alloc] init];
    [messageDateFormatter setDateFormat: @"yyyy-mm-dd HH:mm"];
    [messageDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    
    
    
    // init bubbles
    orangeBubble = [[UIImage imageNamed:@"orangeBubble"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
    aquaBubble = [[UIImage imageNamed:@"aquaBubble"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
}

+ (CGFloat)heightForCellWithMessage:(QBChatAbstractMessage *)message
{
    NSString *text = message.text;
    CGSize  textSize = {260.0, 10000.0};
    CGSize size = [text sizeWithFont:[UIFont boldSystemFontOfSize:13]
                   constrainedToSize:textSize
                       lineBreakMode:NSLineBreakByWordWrapping];
    
    float height;
    
    if ([message.text hasSuffix:@".mp4"])
    {
        height = 142;
        NSLog(@"height____________________%f", size.height);
    
    }
    
   else if ([text hasPrefix:@"http://"]||[text hasPrefix:@"https://"])
    {
        
        height = 142;
        NSLog(@"height____________________%f", size.height);

        
        
        
    }else{
    
       height= size.height += 45.0;
    }

    
	
	return height;

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.dateLabel = [[UILabel alloc] init];
        [self.dateLabel setFrame:CGRectMake(10, 5, 300, 20)];
        [self.dateLabel setFont:[UIFont systemFontOfSize:11.0]];
        [self.dateLabel setTextColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:self.dateLabel];
        
        self.backgroundImageView = [[UIImageView alloc] init];
        [self.backgroundImageView setFrame:CGRectZero];
		[self.contentView addSubview:self.backgroundImageView];
        
		self.messageTextView = [[UITextView alloc] init];
        [self.messageTextView setBackgroundColor:[UIColor clearColor]];
        [self.messageTextView setEditable:NO];
        [self.messageTextView setScrollEnabled:NO];
		[self.messageTextView sizeToFit];
		[self.contentView addSubview:self.messageTextView];
        
        self.backgroundImageBtnObj = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backgroundImageBtnObj setFrame:CGRectZero];
        [self.contentView addSubview:self.backgroundImageBtnObj];
        
        self.users = [[ChatSharedManager sharedManager] chatUsers];
        
    }
    return self;
}

- (void)configureCellWithMessage:(QBChatAbstractMessage *)message
{
    
    
    if (([message.text hasPrefix:@"http://"]||[message.text hasPrefix:@"https://"]) && [message.text hasSuffix:@".mp4"])
    {
        //////**********if Image************
        self.messageTextView.text = message.text;
        
        
        CGSize textSize = { 260.0, 10000.0 };
        
        CGSize size = [self.messageTextView.text sizeWithFont:[UIFont boldSystemFontOfSize:13]
                                            constrainedToSize:textSize
                                                lineBreakMode:NSLineBreakByWordWrapping];
        
        // CGSize size = CGSizeMake(150, 150);
        
        NSLog(@"message: %@", message);
        
        size.width += 10;
        
        NSString *time = [messageDateFormatter stringFromDate:message.datetime];
        
        // Left/Right bubble
        if ([LocalStorageService shared].currentUser.ID == message.senderID) {
            
            [self.messageTextView setFrame:CGRectMake(320-size.width-padding/2, padding+5, size.width, size.height+padding)];
            [self.messageTextView sizeToFit];
            
            self.messageTextView.hidden = YES;
            
            
            //  NSLog(@"width____________________%f",(self.messageTextView.frame.size.width+padding/2)-50);
            //   NSLog(@"height____________________%f",self.messageTextView.frame.size.height+20);
            //  NSLog(@"height____________________%f",size.width-padding/2+50);
            
            [self.backgroundImageView setFrame:CGRectMake(320-200, padding+5,
                                                          192, 120)];
            [self.backgroundImageBtnObj setFrame:CGRectMake(320-200, padding+5,
                                                            192, 120)];
            
            self.backgroundImageView.layer.borderColor = [UIColor grayColor].CGColor;
            self.backgroundImageView.layer.borderWidth = 1.0;
            self.backgroundImageView.layer.shadowColor = [UIColor whiteColor].CGColor;
            self.backgroundImageView.layer.shadowOffset = CGSizeMake(1, 1);
            self.backgroundImageView.layer.shadowOpacity = 1;
            self.backgroundImageView.layer.shadowRadius = 1.0;
            self.backgroundImageView.clipsToBounds = NO;
            
            
           
//            MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:message.text]];
//            UIImage  *videoThumbnail = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
//            player = nil;
           // self.backgroundImageView.image =videoThumbnail;
            self.backgroundImageView.image = [UIImage imageNamed:@"video_icon.png"];
            self.dateLabel.textAlignment = NSTextAlignmentRight;
            //self.dateLabel.text = [NSString stringWithFormat:@"%@, %@", [[LocalStorageService shared].currentUser login], time];
            self.dateLabel.text = [NSString stringWithFormat:@"Me"];
            
        } else {
            
            [self.messageTextView setFrame:CGRectMake(padding, padding+5, size.width, size.height+padding)];
            [self.messageTextView sizeToFit];
            self.messageTextView.hidden = YES;
            
            [self.backgroundImageView setFrame:CGRectMake(320-310, padding+5,
                                                          192, 120)];
            [self.backgroundImageBtnObj setFrame:CGRectMake(320-310, padding+5,
                                                            192, 120)];
            self.backgroundImageView.layer.borderColor = [UIColor grayColor].CGColor;
            self.backgroundImageView.layer.borderWidth = 1.0;
            self.backgroundImageView.layer.shadowColor = [UIColor whiteColor].CGColor;
            self.backgroundImageView.layer.shadowOffset = CGSizeMake(1, 1);
            self.backgroundImageView.layer.shadowOpacity = 1;
            self.backgroundImageView.layer.shadowRadius = 1.0;
            self.backgroundImageView.clipsToBounds = NO;
            
            //[self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:message.text] placeholderImage:[UIImage imageNamed:@"loading.png"]];
            
            self.backgroundImageView.image = [UIImage imageNamed:@"video_icon.png"];
            
            self.dateLabel.textAlignment = NSTextAlignmentLeft;
            
            
             NSLog(@"self.user.count %@", self.users );
            
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ID == %d", [NSString stringWithFormat:@"%lu", (unsigned long)message.senderID].intValue];
            NSMutableArray *newArray = [NSMutableArray array];
            [newArray addObject:[self.users filteredArrayUsingPredicate:predicate]];// = [self.users filteredArrayUsingPredicate:predicate];
            NSLog(@"%d", [newArray count]);
            NSLog(@"______________%@",[NSString stringWithFormat:@"%@",[[newArray objectAtIndex:0] valueForKey:@"login"]]);
            NSString *username =[[[newArray objectAtIndex:0] valueForKey:@"login"] objectAtIndex:0];

           // self.dateLabel.text = [NSString stringWithFormat:@"%lu, %@", (unsigned long)message.senderID, time];
            self.dateLabel.text = [NSString stringWithFormat:@"%@",username];
            
            
            
            
            
        }
        
        
    }
   else if (([message.text hasPrefix:@"http://"]||[message.text hasPrefix:@"https://"])&& [message.text hasSuffix:@".png"])
    {
        //////**********if Image************
        self.messageTextView.text = message.text;
        
        
        CGSize textSize = { 260.0, 10000.0 };
        
        CGSize size = [self.messageTextView.text sizeWithFont:[UIFont boldSystemFontOfSize:13]
                                            constrainedToSize:textSize
                                                lineBreakMode:NSLineBreakByWordWrapping];
        
       // CGSize size = CGSizeMake(150, 150);
        
        NSLog(@"message: %@", message);
        
        size.width += 10;
        
        NSString *time = [messageDateFormatter stringFromDate:message.datetime];
        
        // Left/Right bubble
        if ([LocalStorageService shared].currentUser.ID == message.senderID) {
            
            [self.messageTextView setFrame:CGRectMake(320-size.width-padding/2, padding+5, size.width, size.height+padding)];
            [self.messageTextView sizeToFit];
            
            self.messageTextView.hidden = YES;
            
            
          //  NSLog(@"width____________________%f",(self.messageTextView.frame.size.width+padding/2)-50);
          //   NSLog(@"height____________________%f",self.messageTextView.frame.size.height+20);
          //  NSLog(@"height____________________%f",size.width-padding/2+50);
            
            [self.backgroundImageView setFrame:CGRectMake(320-200, padding+5,
                                                          192, 120)];
            [self.backgroundImageBtnObj setFrame:CGRectMake(320-200, padding+5,
                                                          192, 120)];
            
            self.backgroundImageView.layer.borderColor = [UIColor grayColor].CGColor;
            self.backgroundImageView.layer.borderWidth = 1.0;
            self.backgroundImageView.layer.shadowColor = [UIColor whiteColor].CGColor;
            self.backgroundImageView.layer.shadowOffset = CGSizeMake(1, 1);
            self.backgroundImageView.layer.shadowOpacity = 1;
            self.backgroundImageView.layer.shadowRadius = 1.0;
            self.backgroundImageView.clipsToBounds = NO;
            
            
            
            
            
           [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:message.text] placeholderImage:[UIImage imageNamed:@"loading.png"]];
            
            self.dateLabel.textAlignment = NSTextAlignmentRight;
            //self.dateLabel.text = [NSString stringWithFormat:@"%@, %@", [[LocalStorageService shared].currentUser login], time];
             self.dateLabel.text = [NSString stringWithFormat:@"Me"];
            
        } else {
            
            [self.messageTextView setFrame:CGRectMake(padding, padding+5, size.width, size.height+padding)];
            [self.messageTextView sizeToFit];
             self.messageTextView.hidden = YES;
            
            [self.backgroundImageView setFrame:CGRectMake(320-310, padding+5,
                                                          192, 120)];
            [self.backgroundImageBtnObj setFrame:CGRectMake(320-310, padding+5,
                                                          192, 120)];
            self.backgroundImageView.layer.borderColor = [UIColor grayColor].CGColor;
            self.backgroundImageView.layer.borderWidth = 1.0;
            self.backgroundImageView.layer.shadowColor = [UIColor whiteColor].CGColor;
            self.backgroundImageView.layer.shadowOffset = CGSizeMake(1, 1);
            self.backgroundImageView.layer.shadowOpacity = 1;
            self.backgroundImageView.layer.shadowRadius = 1.0;
            self.backgroundImageView.clipsToBounds = NO;
            
            [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:message.text] placeholderImage:[UIImage imageNamed:@"loading.png"]];
            
            self.dateLabel.textAlignment = NSTextAlignmentLeft;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ID == %d", [NSString stringWithFormat:@"%lu", (unsigned long)message.senderID].intValue];
            NSMutableArray *newArray = [NSMutableArray array];
            [newArray addObject:[self.users filteredArrayUsingPredicate:predicate]];// = [self.users filteredArrayUsingPredicate:predicate];
            NSLog(@"%d", [newArray count]);
            NSLog(@"______________%@",[NSString stringWithFormat:@"%@",[[newArray objectAtIndex:0] valueForKey:@"login"]]);
            NSString *username =[[[newArray objectAtIndex:0] valueForKey:@"login"] objectAtIndex:0];
            
            // self.dateLabel.text = [NSString stringWithFormat:@"%lu, %@", (unsigned long)message.senderID, time];
            self.dateLabel.text = [NSString stringWithFormat:@"%@",username];

        }

        
    }
    else{
         //////**********if Text************
        
        self.messageTextView.text = message.text;
        
        
        CGSize textSize = { 260.0, 10000.0 };
        
        CGSize size = [self.messageTextView.text sizeWithFont:[UIFont boldSystemFontOfSize:13]
                                            constrainedToSize:textSize
                                                lineBreakMode:NSLineBreakByWordWrapping];
        
        NSLog(@"message: %@", message);
        
        size.width += 10;
        
        NSString *time = [messageDateFormatter stringFromDate:message.datetime];
        
        // Left/Right bubble
        if ([LocalStorageService shared].currentUser.ID == message.senderID) {
            
            [self.messageTextView setFrame:CGRectMake(320-size.width-padding/2, padding+5, size.width, size.height+padding)];
            [self.messageTextView sizeToFit];
            
            [self.backgroundImageView setFrame:CGRectMake(320-size.width-padding/2, padding+5,
                                                          self.messageTextView.frame.size.width+padding/2, self.messageTextView.frame.size.height+5)];
            self.backgroundImageView.image =aquaBubble ;
            
            self.dateLabel.textAlignment = NSTextAlignmentRight;
            //self.dateLabel.text = [NSString stringWithFormat:@"%@, %@", [[LocalStorageService shared].currentUser login], time];
            self.dateLabel.text = [NSString stringWithFormat:@"Me"];
            
        } else {
            
            
            [self.messageTextView setFrame:CGRectMake(padding, padding+5, size.width, size.height+padding)];
            [self.messageTextView sizeToFit];
            
            [self.backgroundImageView setFrame:CGRectMake(padding/2, padding+5,
                                                          self.messageTextView.frame.size.width+padding/2, self.messageTextView.frame.size.height+5)];
            self.backgroundImageView.image =orangeBubble ;
            
            self.dateLabel.textAlignment = NSTextAlignmentLeft;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ID == %d", [NSString stringWithFormat:@"%lu", (unsigned long)message.senderID].intValue];
            NSMutableArray *newArray = [NSMutableArray array];
            [newArray addObject:[self.users filteredArrayUsingPredicate:predicate]];// = [self.users filteredArrayUsingPredicate:predicate];
            NSLog(@"%d", [newArray count]);
            NSLog(@"______________%@",[NSString stringWithFormat:@"%@",[[newArray objectAtIndex:0] valueForKey:@"login"]]);
            NSString *username =[[[newArray objectAtIndex:0] valueForKey:@"login"] objectAtIndex:0];
            
            // self.dateLabel.text = [NSString stringWithFormat:@"%lu, %@", (unsigned long)message.senderID, time];
            self.dateLabel.text = [NSString stringWithFormat:@"%@",username];

            
        }

    }
    
    
}

@end
