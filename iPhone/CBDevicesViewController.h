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
  IBOutlet UITableView* tableView;
  NSMutableArray* foundCloudboards;
  NSMutableArray* selectedCloudboards;
}
- (id)initWithClipboard:(CBClipboardController*)delegate;
@end

@interface CBDevicesViewController(Actions)
- (IBAction)dismiss:(id)sender;
@end