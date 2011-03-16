//
//  CBDevicesViewController.m
//  Cloudboard-iOS
//
//  Created by Mirko on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CBDevicesViewController.h"
#import "Cloudboard.h"

@implementation CBDevicesViewController

- (id)initWithClipboard:(CBClipboardController*)delegate {
    self = [super init];
    if (self) {
      foundCloudboards = [[NSMutableArray alloc] init];
      selectedCloudboards = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
  [delegate release];
  [syncController release];
  [tableView release];
  [foundCloudboards release];
  [selectedCloudboards release];
  [super dealloc];
}

- (void)loadView {
  CGRect viewFrame = CGRectMake(0, 0, 300, 300);
  self.view = [[CBDevicesView alloc] initWithFrame:viewFrame delegate:self];
  tableView = [[UITableView alloc] initWithFrame:viewFrame style:UITableViewStylePlain];
  tableView.delegate = self;
  tableView.dataSource = self;
  [self.view addSubview:tableView];
}

@end