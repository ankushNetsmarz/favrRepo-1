//
//  ChatHistory.h
//  Favr
//
//  Created by Ankush on 14/07/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData/CoreData.h"

@interface ChatHistory : NSManagedObject

@property (nonatomic, strong) NSString *ids;
@property (nonatomic, strong) NSString *senderID;
@property (nonatomic, strong) NSString *senderNick;
@property (nonatomic, retain) NSString *recipientID;
@property (nonatomic, retain) NSString *datetime;
@property (nonatomic, retain) NSString *delayed;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, retain) NSMutableDictionary *customParameters;

@end