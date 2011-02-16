#import "Cocoa.h"

@class CBHotKeyObserver;

@protocol CBHotKeyObserverDelegate <NSObject>

@required
- (void)hotKeyPressed:(CBHotKeyObserver *)hotKey;

@optional
- (void)hotKeyReleased:(CBHotKeyObserver *)hotKey;

@end