#import "Cocoa.h"
#import "CBItemViewDelegate.h"

@interface CBClipboardController : NSObject {
@private
  CBClipboard* clipboard;
  UIView* clipboardView;
  NSMutableArray* itemViews;
  NSMutableArray* frames;
  id changeListener;
}

- (id)initWithFrame:(CGRect)aFrame
     viewController:(id)viewController;

- (void)setItem:(CBItem*)newItem
           atIndex:(NSInteger)anIndex;

- (BOOL)clipboardContainsItem:(CBItem*)anItem;

- (void)addChangeListener:(id)anObject;

@end

@interface CBClipboardController(Delegation) <CBItemViewDelegate>

@end