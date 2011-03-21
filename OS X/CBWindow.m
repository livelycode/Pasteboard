//
//  CBWindow.m
//  cloudboard-mac
//
//  Created by Mirko on 3/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CBWindow.h"

@implementation CBWindow

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (BOOL)canBecomeKeyWindow {
  return YES;
}

- (void)dealloc {
    [super dealloc];
}

@end
