#import "Cocoa.h"
#import "CBViewDelegate.h"

@interface CBView : NSView 
{
    @private
    id delegate;
}

- (void)setDelegate:(id <CBViewDelegate>)anObject;

@end