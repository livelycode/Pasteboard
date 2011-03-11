#import "Cocoa.h"
#import "CBItemViewDelegate.h"

@class CBClipboard, CBClipboardView, CBSyncController, CBMainWindowController, CBPasteView;

@interface CBClipboardController : NSViewController {
  @private
  CBMainWindowController *windowController;
  CBSyncController* syncController;
  CBClipboard *clipboard;
  NSMutableArray *frames;
  NSMutableArray *viewSlots;
  NSDate* lastChanged;
}
- (id)initWithFrame:(CGRect)aFrame;
- (void)setWindowController:(CBMainWindowController *)aController;
- (void)setSyncController:(CBSyncController *)controller;
- (void)setItem:(id)item atIndex:(NSInteger)index syncing:(BOOL)sync;
- (void)addItem:(CBItem *)item syncing:(BOOL)sync;
- (BOOL)clipboardContainsItem:(CBItem *)item;
- (CBSyncController*)syncController;
- (NSDate*)lastChanged;
- (NSArray*)allItems;
- (void)persistClipboard;
@end

@interface CBClipboardController(Delegation) <CBItemViewDelegate>
- (void)itemViewClicked:(CBItemView*)view index:(NSInteger)index;
- (void)pasteViewClicked:(CBPasteView*)view index:(NSInteger)index;
@end

@interface CBClipboardController(Actions)
- (IBAction)clearClipboard:(id)sender;
- (IBAction)showSettings:(id)sender;
@end