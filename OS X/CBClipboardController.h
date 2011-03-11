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
  CBPasteView* pasteView;
  NSDate* lastChanged;
}
- (id)initWithFrame:(CGRect)aFrame;
- (void)setWindowController:(CBMainWindowController *)aController;
- (void)setSyncController:(CBSyncController *)controller;
- (void)addItem:(CBItem *)item syncing:(BOOL)sync;
- (BOOL)clipboardContainsItem:(CBItem *)item;
- (CBSyncController*)syncController;
- (NSDate*)lastChanged;
- (NSArray*)allItems;
- (void)persistClipboard;
- (void)clearClipboard;
@end

@interface CBClipboardController(Delegation) <CBItemViewDelegate>
- (void)itemViewClicked;
- (void)pasteViewClicked:(CBPasteView*)view index:(NSInteger)index;
@end

@interface CBClipboardController(Actions)
- (IBAction)clearClipboard:(id)sender;
- (IBAction)showSettings:(id)sender;
@end