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
    self = [super initWithNibName:@"Devices" bundle:nil];
    if (self) {
      foundCloudboards = [[NSMutableArray alloc] init];
      selectedCloudboards = [[NSMutableArray alloc] init];
    }
    return self;
}

@end

@implementation CBDevicesViewController(Overriden)

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

@implementation CBDevicesViewController(Actions)

- (IBAction)dismiss:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

@end