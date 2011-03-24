//
//  CBSyncController.m
//  Cloudboard-iPad
//
//  Created by Mirko on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Cloudboard.h"
#import <SystemConfiguration/SystemConfiguration.h>

@implementation CBSyncController (CBSyncController)
- (NSString*)deviceName {
  NSString* computerName = (NSString*)SCDynamicStoreCopyComputerName(NULL, NULL);
  [computerName autorelease];
  return computerName;
}
@end
