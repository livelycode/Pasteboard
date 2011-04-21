#import "Cocoa.h"

@class CBClipboard;
@class CBClipboardController;
@class CBHotKeyObserver;
@class CBPasteboardObserver;
@class CBMainWindowController;
@class HTTPConnectionDelegate;
@class CBSyncController, CBItem;

#import "CBSyncControllerProtocol.h"

@interface CBApplicationController : NSObject <UIApplicationDelegate>
{
  @protected
  CBClipboardController *clipboardController;
  UIWindow *window;
}
- (void)initClipboards;
- (CBSyncController*) syncController;
- (CBClipboardController*) clipboardController;
- (CBItem*)currentPasteboardItem;
@end

@interface CBApplicationController(Delegation)<CBSyncControllerProtocol>
//CBSyncControllerDelegate
- (void)clientAsksForRegistration:(NSString *)clientName;
@end