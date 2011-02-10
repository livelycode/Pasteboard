#import "Cocoa.h"

@class CBHotKey;

@interface CBHotKey : NSObject
{
    @private
	EventHotKeyRef hotKeyRef;
    EventHotKeyID hotKeyID;
    EventTypeSpec eventType;
}

- (id)init;

- (id)initHotKey:(NSUInteger)key withModifier:(NSUInteger)modifier;

- (void)setDelegate:(id <CBHotKeyDelegate>)anObject;

@end

