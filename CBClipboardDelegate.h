#import "Cocoa.h"

@class CBClipboardLayer;

@protocol CBClipboardDelegate <NSObject>

@optional
- (void)clipboardDidHide:(CBClipboardLayer *)aClipboard;

- (void)clipboardDidShow:(CBClipboardLayer *)aClipboard;

@end