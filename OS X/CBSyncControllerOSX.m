//
//  CBSyncController.m
//  Cloudboard-iPad
//
//  Created by Mirko on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Cloudboard.h"

@implementation CBSyncController (CBSyncController)
- (NSString*)deviceName {
  return NSFullUserName();
}
@end
