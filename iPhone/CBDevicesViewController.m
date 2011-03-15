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

- (id)initWithClipboard:(CBClipboardController*)delegate syncController:(CBSyncController*)aSyncController {
    self = [super initWithNibName:@"Devices" bundle:nil];
    if (self) {
      syncController = [aSyncController retain];
      foundCloudboards = [[NSMutableArray alloc] init];
      [syncController addDelegate:self];
      foundCloudboards = [[NSMutableArray alloc] initWithArray:[syncController clientsVisible]];
      selectedCloudboards = [[NSMutableArray alloc] initWithArray:[syncController clientsToSearch]];
    }
    return self;
}

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

/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return NO;
}*/

@end

@implementation CBDevicesViewController(Delegation)


//UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSUInteger index = [indexPath row];
  NSString* clientName = [foundCloudboards objectAtIndex:index];
  UITableViewCell* viewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
  NSString* substring = [clientName substringFromIndex:10];
  viewCell.textLabel.text = substring;
  if ([selectedCloudboards containsObject:clientName]) {
    viewCell.accessoryType = UITableViewCellAccessoryCheckmark;
  } else {
    viewCell.accessoryType = UITableViewCellAccessoryNone;
  }
  return viewCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [foundCloudboards count];
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath {
  NSUInteger index = [newIndexPath row];
  [theTableView deselectRowAtIndexPath:[theTableView indexPathForSelectedRow] animated:YES];
  NSString* clientName = [foundCloudboards objectAtIndex:index];
  if ([selectedCloudboards containsObject:clientName]) {
    [syncController removeClientToSearch:[foundCloudboards objectAtIndex:index]];
    [selectedCloudboards removeObject:clientName];
  } else {
    [syncController addClientToSearch:[foundCloudboards objectAtIndex:index]];
    [selectedCloudboards addObject:clientName];
  }
  [tableView reloadData];
}

//CBSyncControllerDelegate
- (void)clientBecameVisible:(NSString*)clientName {
  NSLog(@"client visible %@", clientName);
  if([foundCloudboards containsObject:clientName] == NO) {
    [foundCloudboards addObject:clientName];
    [tableView reloadData];
  }
}
- (void)clientBecameInvisible:(NSString*)clientName {
  NSLog(@"client invisible %@", clientName);
  if([foundCloudboards containsObject:clientName]) {
    [foundCloudboards removeObject:clientName];
    [tableView reloadData];
  }
}
- (void)clientConnected:(NSString*)clientName {
  NSLog(@"client connected %@", clientName);
}

- (void)clientDisconnected:(NSString*)clientName {
  NSLog(@"client disconnected %@", clientName);
}

- (void)clientConfirmed:(NSString*)clientName {
  NSLog(@"client confirmed %@", clientName);
}
@end

@implementation CBDevicesViewController(Actions)

- (IBAction)dismiss:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

@end