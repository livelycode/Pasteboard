#import "Cocoa.h"
#import "CBClipboardViewDelegate.h"

@class CBClipboard;
@class CBClipboardView;

@interface CBClipboardController : NSObject
{
    @private
    CBClipboard *clipboard;
    CBClipboardView *clipboardView;
}
							
- (id)initWithFrame:(CGRect)frame delegate: (id)delegate;
- (void)insertItems: (NSArray*)items atIndex: (NSInteger)index;

@end

@interface CBClipboardController(Delegation) <CBClipboardViewDelegate>

- (void)didReceiveClickForItemAtIndex:(NSUInteger)anIndex;

- (void)didReceiveDismissClickFirItemAtIndex:(NSUInteger)anIndex;

@end