#import "Cocoa.h"
#import "CBItemViewDelegate.h"

@class CBClipboard, CBClipboardView, CBSyncController, CBMainWindowController, CBPasteView;

@interface CBClipboardController : NSViewController {
  @private
  CBMainWindowController *windowController;
  CBSyncController* syncController;
  CBClipboard *clipboard;
  NSMutableArray *frames;
  NSMutableArray *itemViewSlots;
  NSDate* lastChanged;
}
- (id)initWithFrame:(CGRect)aFrame;
- (void)setWindowController:(CBMainWindowController *)aController;
- (void)setSyncController:(CBSyncController *)controller;
- (CALayer *)snapShot;
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
@end