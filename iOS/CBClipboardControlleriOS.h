//
//  CBClipboardControlleriOS.h
//  Cloudboard-iPad
//
//  Created by Mirko on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBClipboardController.h"

@interface CBClipboardController(iOS)
- (id)initWithDelegate:(id)appController;
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
- (void)addItemView:(CBItemView *)itemView;
@end