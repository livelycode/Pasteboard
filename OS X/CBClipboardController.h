#import "Cocoa.h"
#import "CBItemViewDelegate.h"

@class CBClipboard, CBClipboardView, CBSyncController, CBMainWindowController, CBPasteView;

@interface CBClipboardController : NSViewController {
  @private
  NSInteger rows;
  NSInteger columns;
  CGRect frame;
  CBMainWindowController *windowController;
  CBSyncController* syncController;
  CBClipboard *clipboard;
  IBOutlet NSView* itemsView;
  NSView* clipboardView;
  NSMutableArray *frames;
  NSMutableArray *itemViewSlots;
}
- (id)initWithFrame:(CGRect)aFrame windowController:(CBMainWindowController*)controller;
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
- (void)addItemView:(NSView*)view;
@end