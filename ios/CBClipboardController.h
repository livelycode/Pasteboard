//
//  CBClipboardControlleriOS.h
//  Cloudboard-iPad
//
//  Created by Mirko on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CBPasteView, CBItemView, CBSyncController, CBApplicationController, CBDevicesViewController, CBClipboard;

@interface CBClipboardController : UIViewController {
  @protected
  NSInteger rows;
  NSInteger columns;
  CGFloat paddingTop;
  CGFloat paddingSides;
  CBClipboard* clipboard;
  CBApplicationController* delegate;
  CBDevicesViewController* devicesViewController;
  NSMutableArray* frames;
  CBSyncController* syncController;
  NSMutableArray* itemViewSlots;
  IBOutlet UIView* clipboardView;
}
@end

@interface CBClipboardController(iOS)
- (id)initWithNibName:(NSString*)nibName delegate:(id)appController;
- (void)stopSyncing;
- (void)startSyncing;
@end

@interface CBClipboardController(iOSDelegation)
- (void)handleTapFromPasteView:(CBPasteView*)view;
- (void)handleTapFromItemView:(CBItemView*)itemView;
- (IBAction)clearAllButtonTapped:(id)event;
@end

@interface CBClipboardController(iOSPrivate)
- (CGRect)rectForNSValue:(NSValue*)value;
- (void)setRowsForPortrait;
- (void)setRowsForLandscape;
- (void)moveAllItemViewsAnimated;
- (void)initializeItemViewFrames;
- (void)addItemView:(UIView *)itemView;
- (void) drawBackgroundLayers;
@end