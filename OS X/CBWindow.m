#import "CBWindow.h"

@implementation CBWindow

- (id)initWithFrame:(CGRect)aRect {
    self = [super initWithContentRect:aRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
    if (self != nil) {
      [self setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];
    //  [self setLevel:NSStatusWindowLevel];
      [self setOpaque:NO];
      [self setBackgroundColor:[NSColor clearColor]];
    }
    return self;
}

- (BOOL)canBecomeKeyWindow {
  return YES;
}

@end