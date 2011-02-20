#import "Cocoa.h"
#import "CBClipboardViewDelegate.h"

@class CBClipboard;
@class CBClipboardView;

@interface CBClipboardController : NSObject
{
    @private
    CBClipboard *clipboard;
    CBClipboardView *clipboardView;
    id changeListener;
}
							
- (id)initWithFrame:(CGRect)frame viewController: (id)delegate;
- (void)insertItem: (CBItem*) atIndex: (NSInteger)index;
- (void)addChangeListener: (id)listener;

@end

@interface CBClipboardController(Delegation) <CBClipboardViewDelegate>

- (void)didReceiveClickForItemAtIndex:(NSUInteger)anIndex;

- (void)didReceiveDismissClickFirItemAtIndex:(NSUInteger)anIndex;

@end