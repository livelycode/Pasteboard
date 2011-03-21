#import "CBHotkeyField.h"

@implementation CBHotkeyField

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self != nil) {
    [self setDelegate:self];
  }
  return self;
}

- (BOOL)performKeyEquivalent:(NSEvent *)event {
  if (isActive) {
    if (([event modifierFlags] & NSDeviceIndependentModifierFlagsMask) == NSShiftKeyMask) {
      
    }
    if (([event modifierFlags] & NSDeviceIndependentModifierFlagsMask) == NSControlKeyMask) {
      
    }
    if (([event modifierFlags] & NSDeviceIndependentModifierFlagsMask) == NSCommandKeyMask) {
      
    }
    if (([event modifierFlags] & NSDeviceIndependentModifierFlagsMask) == NSCommandKeyMask) {
      
    }
    NSLog(@"event");
  }
  return [super performKeyEquivalent:event];
}

- (void)controlTextDidBeginEditing:(NSNotification *)aNotification {
  NSLog(@"begin");
}

@end