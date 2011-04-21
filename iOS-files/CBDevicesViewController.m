//
//  CBDevicesViewControlleriOS.m
//  Cloudboard-iPhone
//
//  Created by Mirko on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CBDevicesViewController.h"
#import "Cloudboard.h"

@implementation CBDevicesViewController
- (void)setSyncController:(CBSyncController*)aSyncController {
  if(syncController) {
    [syncController release];
  }
  syncController = [aSyncController retain];
  [syncController addDelegate: self];
  [foundCloudboards release];
  [selectedCloudboards release];
  foundCloudboards = [[NSMutableArray alloc] initWithArray:[syncController clientsVisible]];
  selectedCloudboards = [[NSMutableArray alloc] initWithArray:[syncController clientsToSearch]];
}

- (void)releaseSyncController {
  [syncController release];
  syncController = nil;
  [foundCloudboards release];
  [selectedCloudboards release];
  foundCloudboards = [[NSMutableArray alloc] init];
  selectedCloudboards = [[NSMutableArray alloc] init];
  [tableView reloadData];
}
@end

@implementation CBDevicesViewController(iOSDelegation)

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
  if([foundCloudboards containsObject:clientName] == NO) {
    [foundCloudboards addObject:clientName];
    [tableView reloadData];
  }
}
- (void)clientBecameInvisible:(NSString*)clientName {
  if([foundCloudboards containsObject:clientName]) {
    [foundCloudboards removeObject:clientName];
    [tableView reloadData];
  }
}
- (void)clientConnected:(NSString*)clientName {
}

- (void)clientDisconnected:(NSString*)clientName {
}

- (void)clientConfirmed:(NSString*)clientName {
}

@end