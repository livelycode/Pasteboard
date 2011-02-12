#import "Cocoa.h"

@class CBHotKey;

@protocol CBHotKeyDelegate <NSObject>

@required
- (void)hotKeyPressed:(CBHotKey *)hotKey;

@optional
- (void)hotKeyReleased:(CBHotKey *)hotKey;

@end