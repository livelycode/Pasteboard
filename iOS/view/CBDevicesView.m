//
//  CBDevicesView.m
//  Cloudboard-iOS
//
//  Created by Mirko on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CBDevicesView.h"


@implementation CBDevicesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self setBackgroundColor:[UIColor blueColor]];
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

- (void)dealloc
{
    [super dealloc];
}

@end
