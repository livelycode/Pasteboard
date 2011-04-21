//
//  CBDevicesViewController.m
//  Cloudboard-iOS
//
//  Created by Mirko on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CBDevicesViewController_iPhone.h"
#import "Cloudboard.h"

@implementation CBDevicesViewController_iPhone

- (id)initWithClipboard:(CBClipboardController*)delegate {
    self = [super initWithNibName:@"Devices_iPhone" bundle:nil];
    if (self) {
      foundCloudboards = [[NSMutableArray alloc] init];
      selectedCloudboards = [[NSMutableArray alloc] init];
    }
    return self;
}

@end

@implementation CBDevicesViewController_iPhone(Overriden)

- (void)dealloc {
  [delegate release];
  [syncController release];
  [foundCloudboards release];
  [selectedCloudboards release];
  [super dealloc];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  [tableView release];
}

@end

@implementation CBDevicesViewController_iPhone(Actions)

- (IBAction)dismiss:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

@end