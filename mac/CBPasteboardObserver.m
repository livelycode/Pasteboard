#import "Cloudboard.h"

@implementation CBPasteboardObserver

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        systemPasteboard = [NSPasteboard generalPasteboard];
        timer = nil;
        changeCount = [systemPasteboard changeCount];
    }
    return self;
}

- (void)observeWithTimeInterval:(NSTimeInterval)interval
{
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                             target:self
                                           selector:@selector(checkPasteboard:)
                                           userInfo:nil
                                            repeats:YES];
}

- (void)setDelegate:(id <CBPasteboardOberserverDelegate>)anObject
{
    delegate = anObject;
}

- (void)checkPasteboard:(NSTimer *)timer
{
	NSInteger currentChangeCount = [systemPasteboard changeCount];
	if (currentChangeCount != changeCount)
    {
        [delegate systemPasteboardDidChange:systemPasteboard];
        changeCount = currentChangeCount;
    }
}

@end