#import "Cocoa.h"

@class CBClipboard;
@class CBClipboardController;
@class CBHotKeyObserver;
@class CBPasteboardObserver;
@class CBMainWindowController;
@class HTTPConnectionDelegate;
@class CBSyncController;

@interface AppDelegate : NSObject <UIApplicationDelegate>
{
    @private
    CBClipboardController *syncingClipboardController;
    UIWindow *window;
    CBSyncController *syncController;
}
- (void)initClipboards;
- (void)addSubview: (UIView*) view;
- (void)startSyncing;
@end