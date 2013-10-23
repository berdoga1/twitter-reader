//
//  ProfileCell.m
//  twitter-reader
//
//  Created by Batuhan Erdogan on 23.10.2013.
//  Copyright (c) 2013 Batuhan Erdogan. All rights reserved.
//

#import "ProfileCell.h"

@implementation ProfileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self.profileImageView.layer setBorderWidth:4.0f];
//        [self.profileImageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
//        [self.profileImageView.layer setShadowRadius:3.0];
//        [self.profileImageView.layer setShadowOpacity:0.5];
//        [self.profileImageView.layer setShadowOffset:CGSizeMake(1.0, 0.0)];
//        [self.profileImageView.layer setShadowColor:[[UIColor blackColor] CGColor]];
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
