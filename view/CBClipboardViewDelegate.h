#import "Cocoa.h"

@class CBClipboardViewDelegate;

@protocol CBClipboardViewDelegate <NSObject>

@optional
- (void)didReceiveClickForVisibleItemAtIndex:(NSUInteger)anIndex;

- (void)didReceiveDismissClickForVisibleItemAtIndex:(NSUInteger)anIndex;

- (void)didReceiveDraggingForVisibleItemAtIndex:(NSUInteger)anIndex
                                      withEvent:(NSEvent *)anEvent;

- (void)didReceiveDropWithObject:(id <NSPasteboardReading>)anObject
           forVisibleItemAtIndex:(NSUInteger)anIndex;

@end