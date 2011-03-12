//
//  CBClipboardControllerCommon.m
//  Cloudboard-iOS
//
//  Created by Mirko on 3/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Cloudboard.h"

#define ROWS 4
#define COLUMNS 2
#define PADDING 0

@implementation CBClipboardController(CBClipboardControllerCommon)
- (void)addItem:(CBItem *)item syncing:(BOOL)sync {
  [clipboard addItem:item];
  [clipboard persist];
  [self drawItem:item];
  if(sync) {
    if(syncController) {
      [syncController didAddItem:item];
    } 
  }
}

- (BOOL)clipboardContainsItem:(CBItem *)anItem {
  return [[clipboard items] containsObject:anItem];
}

- (NSDate*)lastChanged {
  return lastChanged;
}

- (NSArray*)allItems {
  return [clipboard items];
}

- (CBSyncController*)syncController {
  return syncController;
}

- (void)clearClipboardSyncing:(BOOL)sync {
  for (CBItemView* view in itemViewSlots) {
    [view removeFromSuperview];
  }
  [clipboard clear];
  if(sync) {
    [syncController didResetItems];
  }
  [clipboard persist];
}

- (void)persistClipboard {
  [clipboard persist];
}
@end

@implementation CBClipboardController(CommonPrivate)

- (void)drawItem:(CBItem*)item {
  CGRect frame = [self rectForNSValue:[frames objectAtIndex:0]];
  CBItemView *newItemView = [[CBItemView alloc] initWithFrame:frame content:[item string] delegate:self];
  [itemViewSlots insertObject:newItemView atIndex:0];
  [[self view] addSubview:newItemView];
  //remove last itemView if necessary
  while([itemViewSlots count] > (ROWS*COLUMNS-1)) {
    CBItemView* lastView = [itemViewSlots lastObject];
    [itemViewSlots removeLastObject];
    [lastView removeFromSuperview];
  }
  //move all existing itemViews
  [itemViewSlots enumerateObjectsUsingBlock:^(id itemView, NSUInteger index, BOOL *stop) {
    CGRect newFrame = [self rectForNSValue:[frames objectAtIndex:index+1]];
    [itemView setFrame:newFrame];
  }];
}

@end