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
}
- (void)initClipboards;
- (void)addSubview: (UIView*) view;
- (CBSyncController*) syncController;
- (CBItem*)currentPasteboardItem;
@end

@interface CBApplicationController(Delegation)<CBSyncControllerProtocol>
//CBSyncControllerDelegate
- (void)clientAsksForRegistration:(NSString *)clientName;
- (void)startSyncingWith:(CBClipboardController*)controller;
@end