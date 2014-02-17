//
//  FFTextFieldWithStyleWhite.m
//  FFiPhoneApp
//
//  Created by lee on 8/13/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "FFTextFieldWithStyleWhite.h"
#import "UITextField+FFStyles.h"

@implementation FFTextFieldWithStyleWhite

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // Initialization code
        
        [self ff_styleWithBorderColor:[UIColor lightGrayColor]];
        [self ff_styleWithBorderWidth:1.0f];
        [self ff_styleWithRoundCorners];
        [self ff_styleWithPadding];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
