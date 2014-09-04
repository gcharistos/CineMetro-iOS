//
//  CustomTableViewCell.m
//  CineMetro
//
//  Created by George Haristos on 4/9/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "CustomTableViewCell.h"
#import "SWTableViewCell.h"

@implementation CustomTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

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
