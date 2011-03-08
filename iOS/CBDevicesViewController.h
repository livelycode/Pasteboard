//
//  CBDevicesViewController.h
//  Cloudboard-iOS
//
//  Created by Mirko on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBClipboardController;

@interface CBDevicesViewController : UIViewController {
  CBClipboardController* delegate;
}
- (id)initWithDelegate:(CBClipboardController*)delegate;
@end
