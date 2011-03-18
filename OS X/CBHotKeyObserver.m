#import "Cloudboard.h"

@implementation CBHotKeyObserver

static id globalDelegate;
static id globalSelf;

OSStatus hotKeyHandler(EventHandlerCallRef nextHandler,EventRef theEvent, void *userData) {
    if ([globalDelegate respondsToSelector:@selector(hotKeyPressed:)]) {
        [globalDelegate hotKeyPressed:globalSelf];
    }
    return noErr;
}

- (id)init {
	return [self initHotKey:48 withModifier:optionKey];
}

- (id)initHotKey:(NSUInteger)key withModifier:(NSUInteger)modifier {
    self = [super init];
    if (self != nil) {
        globalSelf = self;
        globalDelegate = nil;
        eventType.eventClass = kEventClassKeyboard;
        eventType.eventKind = kEventHotKeyPressed;
        hotKeyID.signature = 'htk1';
        hotKeyID.id = 1;
        InstallApplicationEventHandler(&hotKeyHandler, 1, &eventType, NULL, NULL);
        RegisterEventHotKey((int)key, (int)modifier, hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef);
    }
    return self;
}

- (void)setDelegate:(id)anObject {
    globalDelegate = anObject;
}

@end