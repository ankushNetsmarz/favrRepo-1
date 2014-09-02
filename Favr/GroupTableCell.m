//
//  GroupTableCell.m
//  Favr
//
//  Created by Ankush on 15/07/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "GroupTableCell.h"

@implementation GroupTableCell
@synthesize imageView, textLabel, detailTextLabel;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
