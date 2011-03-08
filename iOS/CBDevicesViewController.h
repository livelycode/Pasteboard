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
  UITableView* tableView;
}
- (id)initWithDelegate:(CBClipboardController*)delegate;
@end

@interface CBDevicesViewController(Delegation)<UITableViewDelegate, UITableViewDataSource>
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
@end