//
//  CBApplicationController_iPhone.m
//  Cloudboard-iPad
//
//  Created by Mirko on 4/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CBApplicationController_iPhone.h"
#import "CBClipboardController_iPhone.h"

@implementation CBApplicationController_iPhone
- (void)initClipboards {
  clipboardController = [[CBClipboardController_iPhone alloc] initWithDelegate:self];
  [window addSubview:clipboardController.view];
}
@end
