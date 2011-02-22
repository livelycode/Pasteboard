#import "Cocoa.h"

@class CBClipboardViewDelegate;

@protocol CBClipboardViewDelegate <NSObject>

@optional
- (void)didReceiveClickForVisibleItemAtIndex:(NSUInteger)anIndex;

- (void)didReceiveDismissClickForVisibleItemAtIndex:(NSUInteger)anIndex;

- (void)didReceiveDragForVisibleItemAtIndex:(NSUInteger)anIndex
                             withPasteboard:(NSPasteboard *)aPasteboard;

@end