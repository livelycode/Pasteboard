#import "Cocoa.h"
#import "CBHotKeyObserverDelegate.h"

@class CBWindowView;
@class CBSyncController;
@class CBSettingsController;

@interface CBMainWindowController : NSObject
{
    @private
    NSArray *types;
    NSWindow *mainWindow;
    CBWindowView *rootView;
    CBClipboardController *clipboardController;
    CBSettingsController *settingsController;
    CBSyncController *syncController;
}

- (id)init;
- (void)flipViews;
- (CBClipboardController *)clipboardController;

@end

@interface CBMainWindowController(Delegation) <CBHotKeyObserverDelegate>

- (void)hotKeyPressed:(CBHotKeyObserver *)hotKey;

@end