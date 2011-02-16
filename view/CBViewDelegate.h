#import "Cocoa.h"

@class CBView;

@protocol CBViewDelegate <NSObject>

@optional
- (void)view:(CBView *)aView
didReceiveMouseDown:(NSEvent *)theEvent;

- (void)view:(CBView *)aView
didReceiveMouseUp:(NSEvent *)theEvent;

- (void)view:(CBView *)aView
didReceiveMouseDragged:(NSEvent *)theEvent;

@end