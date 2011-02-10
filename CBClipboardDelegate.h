#import "Cocoa.h"

@class CBClipboard;

@protocol CBClipboardDelegate <NSObject>

@optional
- (void)clipboardDidHide:(CBClipboard *)aClipboard;

- (void)clipboardDidShow:(CBClipboard *)aClipboard;

@end