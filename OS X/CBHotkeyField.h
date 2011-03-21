#import <AppKit/AppKit.h>


@interface CBHotkeyField : NSTextField <NSTextFieldDelegate> {
  @private
  BOOL isActive;
  NSEvent *modifierEvent;
}

@end