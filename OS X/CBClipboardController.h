#import "Cocoa.h"
#import "CBItemViewDelegate.h"

@class CBClipboard, CBClipboardView, CBSyncController, CBMainWindowController, CBPasteView;

@interface CBClipboardController : NSViewController {
  @private
  NSInteger rows;
  NSInteger columns;
  CBMainWindowController *windowController;
  CBSyncController* syncController;
  CBClipboard *clipboard;
  NSView* clipboardView;
  NSMutableArray *frames;
  NSMutableArray *itemViewSlots;
}
- (id)initWithFrame:(CGRect)aFrame;
- (void)setWindowController:(CBMainWindowController *)aController;
- (void)setSyncController:(CBSyncController *)controller;
@end

@interface CBClipboardController(Delegation) <CBItemViewDelegate>
- (void)itemViewClicked:(CBItemView*)view;
- (void)pasteViewClicked;
@end

@interface CBClipboardController(Actions)
- (IBAction)clearClipboardClicked:(id)sender;
- (IBAction)showSettingsClicked:(id)sender;
@end

@interface CBClipboardController(Private)
- (CGRect)rectForNSValue:(NSValue*)value;
- (void)moveAllItemViewsAnimated;
- (void)initializeItemSlots;
- (void)addItemView:(CBItemView*)view;
@end