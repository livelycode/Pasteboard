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