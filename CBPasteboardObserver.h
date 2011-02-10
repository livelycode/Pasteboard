#import "Cocoa.h"
#import "CBPasteboardOberserverDelegate.h"

@interface CBPasteboardObserver : NSObject
{
    @private
    
    id delegate;
    NSPasteboard *systemPasteboard;
    NSTimer *timer;
    NSInteger changeCount;
}

- (id)init;

- (void)setDelegate:(id <CBPasteboardOberserverDelegate>)anObject;

- (void)observeWithTimeInterval:(NSTimeInterval)interval;

@end