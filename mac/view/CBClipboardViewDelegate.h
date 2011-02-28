#import "Cocoa.h"

@class CBClipboardView;

@protocol CBClipboardViewDelegate <NSObject>

@optional
- (void)clipboardView:(CBClipboardView *)aClipboardView
      didReceiveClick:(NSEvent *)theEvent
       forItemAtIndex:(NSUInteger)anIndex;

- (void)clipboardView:(CBClipboardView *)aClipboardView
      didReceiveClick:(NSEvent *)theEvent
    forButtonWithName:(NSString *)aName
              atIndex:(NSUInteger)anIndex;

- (void)clipboardView:(CBClipboardView *)aClipboardView
   didReceiveDragging:(NSEvent *)theEvent
       forItemAtIndex:(NSUInteger)anIndex;

- (void)clipboardView:(CBClipboardView *)aClipboardView
       didReceiveDrop:(id <NSPasteboardReading>)anObject
      fromItemAtIndex:(NSUInteger)anIndex;

@end