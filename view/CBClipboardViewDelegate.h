#import "Cocoa.h"

@class CBClipboardViewDelegate;

@protocol CBClipboardViewDelegate <NSObject>

@optional
- (void)itemViewAtIndex:(NSUInteger)anIndex
       clickedWithEvent:(NSEvent *)anEvent;

- (void)didReceiveDismissClickForVisibleItemAtIndex:(NSUInteger)anIndex;

- (void)didReceiveDraggingForVisibleItemAtIndex:(NSUInteger)anIndex
                                      withEvent:(NSEvent *)anEvent;

- (void)didReceiveDropWithObject:(id <NSPasteboardReading>)anObject
                 fromItemAtIndex:(NSUInteger)anIndex;

@end