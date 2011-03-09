#import "Cocoa.h"
#import "CBItemViewDelegate.h"

@class CBClipboard, CBClipboardView, CBSyncController;

@interface CBClipboardController : NSViewController {
  @private
  CBSyncController* syncController;
  CBClipboard *clipboard;
  NSMutableArray *frames;
  NSMutableArray *viewSlots;
  NSDate* lastChanged;
}
- (id)initWithFrame:(CGRect)aFrame viewController:(id)viewController;
- (void)setItem:(CBItem *)item atIndex:(NSInteger)index syncing:(BOOL)sync;
- (void)addItem:(CBItem *)item syncing:(BOOL)sync;
- (BOOL)clipboardContainsItem:(CBItem *)item;
- (CBSyncController*)syncController;
- (NSDate*)lastChanged;
- (NSArray*)allItems;
@end

@interface CBClipboardController(Delegation) <CBItemViewDelegate>
- (void)itemViewClicked:(CBItemView *)view index:(NSInteger)index;
- (void)pasteViewClicked:(CBItemView *)view index:(NSInteger)index;
@end

@interface CBClipboardController(Actions)
- (IBAction)clearClipboard:(id)sender;
- (IBAction)showSettings:(id)sender;
@end