#import "Cocoa.h"

@class CBClipboardViewDelegate;

@protocol CBClipboardViewDelegate <NSObject>

@optional
- (void)didReceiveClickForItemAtIndex:(NSUInteger)anIndex;

- (void)didReceiveDismissClickFirItemAtIndex:(NSUInteger)anIndex;

@end