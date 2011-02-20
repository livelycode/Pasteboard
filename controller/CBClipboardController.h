#import "Cocoa.h"

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