#import "Cocoa.h"
#import "CBItemViewDelegate.h"

@class CBClipboard;
@class CBClipboardView;

@interface CBClipboardController : NSObject {
  @private
  id syncController;
  CBClipboard *clipboard;
  CBClipboardView *clipboardView;
  NSMutableArray *frames;
  NSMutableArray *viewSlots;
  NSDate* lastChanged;
}
- (id)initWithFrame:(CGRect)aFrame viewController:(id)viewController;
- (void)setItem:(CBItem *)item atIndex:(NSInteger)index syncing:(BOOL)sync;
- (void)addItem:(CBItem *)item syncing:(BOOL)sync;
- (void)clearClipboard:(id)sender;
- (void)showSettings:(id)sender;
- (BOOL)clipboardContainsItem:(CBItem *)item;
- (void)addSyncController:(id)object;
- (NSDate*)lastChanged;
- (NSArray*)allItems;
@end

@interface CBClipboardController(Delegation) <CBItemViewDelegate>
- (void)itemViewClicked:(CBItemView *)view index:(NSInteger)index;
- (void)pasteViewClicked:(CBItemView *)view index:(NSInteger)index;
@end