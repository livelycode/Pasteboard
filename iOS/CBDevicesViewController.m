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

- (id)initWithDelegate:(CBClipboardController*)delegate {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}


- (void)loadView {
  self.view = [[CBDevicesView alloc] initWithFrame:CGRectMake(0, 0, 300, 500) delegate:self];
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return NO;
}

@end
