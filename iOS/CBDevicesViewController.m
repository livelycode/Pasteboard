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
  CGRect viewFrame = CGRectMake(0, 0, 300, 500);
  self.view = [[CBDevicesView alloc] initWithFrame:viewFrame delegate:self];
  tableView = [[UITableView alloc] initWithFrame:viewFrame style:UITableViewStylePlain];
  tableView.delegate = self;
  tableView.dataSource = self;
  [self.view addSubview:tableView];
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

@implementation CBDevicesViewController(Delegation)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSUInteger index = [indexPath row];
  UITableViewCell* viewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
  if(index==3) {
    viewCell.textLabel.text = @"Yeah Yeah";
  } {
    viewCell.textLabel.text = @"Sample Text";
  }
  return viewCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 5;
}

@end