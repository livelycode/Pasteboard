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
							
- (id)initWithFrame:(CGRect)aFrame
     viewController:(id)viewController;

- (void)insertItem:(CBItem *)newItem
           atIndex:(NSInteger)anIndex;

- (void)addChangeListener:(id)anObject;

@end

@interface CBClipboardController(Delegation) <CBClipboardViewDelegate>

- (void)didReceiveClickForItemAtIndex:(NSUInteger)anIndex;

- (void)didReceiveDismissClickFirItemAtIndex:(NSUInteger)anIndex;

@end