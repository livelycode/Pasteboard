//
//  CBApplicationController_iPad.m
//  pasteboard-ios
//
//  Created by Mirko on 4/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CBApplicationController_iPad.h"
#import "CBClipboardController_iPad.h"


@implementation CBApplicationController_iPad
- (void)initClipboards {
  CGRect mainFrame = [[UIScreen mainScreen] bounds];
  window = [[UIWindow alloc] initWithFrame:mainFrame];
  [window makeKeyAndVisible];
  clipboardController = [[CBClipboardController_iPad alloc] initWithDelegate:self];
  [window addSubview:clipboardController.view];
}
@end
