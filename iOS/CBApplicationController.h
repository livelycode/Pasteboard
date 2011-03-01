#import "Cocoa.h"

@class CBClipboard;
@class CBClipboardController;
@class CBHotKeyObserver;
@class CBPasteboardObserver;
@class CBMainWindowController;
@class HTTPConnectionDelegate;
@class CBSyncController;

@interface CBApplicationController : NSObject <UIApplicationDelegate>
{
    @private
    CBClipboardController *syncingClipboardController;
    UIWindow *window;
    CBSyncController *syncController;
    HTTPConnectionDelegate *connectionDelegate;
    NSArray *pasteboardClasses;
    BOOL windowHidden;
}
- (void)initClipboards;
- (void)initPasteboardObserver;
- (void)addSubview: (UIView*) view;
- (void)startSyncing;
@end