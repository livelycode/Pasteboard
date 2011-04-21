//
//  CBDevicesViewController.h
//  Cloudboard-iOS
//
//  Created by Mirko on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBSyncControllerProtocol.h"
#import "CBDevicesViewController.h"

@class CBClipboardController, CBSyncController;

@interface CBDevicesViewController_iPhone : CBDevicesViewController {

}
- (id)initWithClipboard:(CBClipboardController*)delegate;
@end

@interface CBDevicesViewController_iPhone(Actions)
- (IBAction)dismiss:(id)sender;
@end