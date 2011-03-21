#import "CBHotkeyField.h"

@implementation CBHotkeyField

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self != nil) {
    [self setDelegate:self];
  }
  return self;
}

- (void)mouseDown:(NSEvent *)theEvent {
  isActive = YES;
  [self selectText:self];
}

- (void)flagsChanged:(NSEvent *)event {
  if (isActive) {
    modifierEvent = event;
  }
}

- (void)keyDown:(NSEvent *)theEvent {
  NSLog(@"down");
  if (isActive) {
    if (([modifierEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask) == NSShiftKeyMask) {
      NSLog(@"1");
    }
    if (([modifierEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask) == NSControlKeyMask) {
      NSLog(@"2");
    }
    if (([modifierEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask) == NSAlternateKeyMask) {
      NSLog(@"3");
    }
    if (([modifierEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask) == NSCommandKeyMask) {
      NSLog(@"4");
    }
  }
}

- (BOOL)textShouldBeginEditing:(NSText *)textObject {
  return NO;
}

- (void)controlTextDidEndEditing:(NSNotification *)aNotification {
  isActive = NO;
}

@end