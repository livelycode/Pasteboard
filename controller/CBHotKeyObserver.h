#import "Cocoa.h"

@class CBHotKeyObserver;

@interface CBHotKeyObserver : NSObject
{
    @private
	EventHotKeyRef hotKeyRef;
    EventHotKeyID hotKeyID;
    EventTypeSpec eventType;
}

- (id)init;

- (id)initHotKey:(NSUInteger)key
    withModifier:(NSUInteger)modifier;

- (void)setDelegate:(id <CBHotKeyObserverDelegate>)anObject;

@end

