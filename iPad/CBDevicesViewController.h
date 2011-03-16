//
//  CBDevicesViewController.h
//  Cloudboard-iOS
//
//  Created by Mirko on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBSyncControllerProtocol.h"

@class CBClipboardController, CBSyncController;

@interface CBDevicesViewController : UIViewController {
  CBClipboardController* delegate;
  CBSyncController* syncController;
  UITableView* tableView;
  NSMutableArray* foundCloudboards;
  NSMutableArray* selectedCloudboards;
  NSMutableArray* connectedCloudboards;
}
- (id)initWithClipboard:(CBClipboardController*)delegate;
@end