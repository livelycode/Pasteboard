#import "Cloudboard.h"

#define TEXT_PADDING 12

#define BUTTON_PADDING 8
#define BUTTON_LENGTH 16

#define CROSS_PADDING 4
#define CROSS_WIDTH 3
#define CROSS_HIGHLIGHT 0.2

#define NOTE_RED 0.9
#define NOTE_GREEN 0.8
#define NOTE_BLUE 0.3
#define NOTE_HIGHLIGHT 0.2

#define BACKLIGHT_RED 0.5
#define BACKLIGHT_GREEN 0.5
#define BACKLIGHT_BLUE 1
#define BACKLIGHT_ALPHA 0.2

#define SHADOW_ALPHA 0.5
#define SHADOW_BLUR 2
#define SHADOW_OFFSET -4

@implementation CBItemView

- (id <CBItemViewDelegate>)delegate {
  return delegate;
}

- (void)setDelegate:(id <CBItemViewDelegate>)anObject {
  delegate = anObject;
}

- (NSAttributedString *)text {
  return string;
}

- (void)setText:(NSAttributedString *)aString {
  string = aString;
  [self setNeedsDisplay:YES];
}

- (BOOL)isNoteVisible {
  return noteVisible;
}

- (void)setNoteVisible:(BOOL)visible {
  noteVisible = visible;
  [self setNeedsDisplay:YES];
}

- (void)startDragWithEvent:(NSEvent *)anEvent
                    object:(id <NSPasteboardWriting>)anObject {
  NSData *imageData = [self dataWithPDFInsideRect:[self bounds]];
  NSImage *dragImage = [[NSImage alloc] initWithData:imageData];
  NSPoint leftBottom = [self bounds].origin;
  NSPasteboard *pasteboard = [NSPasteboard pasteboardWithName:NSDragPboard];
  [pasteboard clearContents];
  [pasteboard writeObjects:[NSArray arrayWithObject:anObject]];
  
  [self dragImage:dragImage
               at:leftBottom
           offset:NSZeroSize
            event:anEvent
       pasteboard:pasteboard
           source:self
        slideBack:YES];
}

@end

@implementation CBItemView(Overridden)

- (id)initWithFrame:(NSRect)aRect {
  self = [super initWithFrame:aRect];
  if (self != nil) {
    delegate = nil;
    
    noteVisible = YES;
    noteHightlighted = NO;
    noteBacklighted = NO;
    
    [self registerForDraggedTypes:[NSArray arrayWithObject:NSPasteboardTypeString]];
    
    CGRect mainBounds = [self bounds];
    
    CGFloat textWidth = mainBounds.size.width - (2 * TEXT_PADDING);
    CGFloat textHeight = mainBounds.size.height - (2 * TEXT_PADDING);
    CGFloat textX = TEXT_PADDING;
    CGFloat textY = TEXT_PADDING;
    textRect = NSMakeRect(textX, textY, textWidth, textHeight);
    
    CGFloat buttonWidth = BUTTON_LENGTH;
    CGFloat buttonHeight = BUTTON_LENGTH;
    CGFloat buttonX = mainBounds.size.width - BUTTON_LENGTH - BUTTON_PADDING;
    CGFloat buttonY = mainBounds.size.height - BUTTON_LENGTH - BUTTON_PADDING;
    buttonRect = NSMakeRect(buttonX, buttonY, buttonWidth, buttonHeight);
    
    CGFloat noteLeftX = mainBounds.origin.x;
    CGFloat noteRightX = mainBounds.origin.x + mainBounds.size.width;
    CGFloat noteBottomY = mainBounds.origin.y;
    CGFloat noteTopY = mainBounds.origin.y + mainBounds.size.height;
    notePath = [NSBezierPath bezierPath];
    [notePath moveToPoint:NSMakePoint(noteLeftX, noteBottomY)];
    [notePath lineToPoint:NSMakePoint(noteRightX, noteBottomY)];
    [notePath lineToPoint:NSMakePoint(noteRightX, noteTopY)];
    [notePath lineToPoint:NSMakePoint(noteLeftX, noteTopY)];
    [notePath closePath];
    
    CGFloat crossLeftX = buttonRect.origin.x + CROSS_PADDING;
    CGFloat crossRightX = buttonRect.origin.x + buttonRect.size.width - CROSS_PADDING;
    CGFloat crossBottomY = buttonRect.origin.y + CROSS_PADDING;
    CGFloat crossTopY = buttonRect.origin.y + buttonRect.size.height - CROSS_PADDING;
    crossPath = [NSBezierPath bezierPath];
    [crossPath moveToPoint:NSMakePoint(crossLeftX, crossBottomY)];
    [crossPath lineToPoint:NSMakePoint(crossRightX, crossTopY)];
    [crossPath moveToPoint:NSMakePoint(crossRightX, crossBottomY)];
    [crossPath lineToPoint:NSMakePoint(crossLeftX, crossTopY)];
    [crossPath setLineWidth:CROSS_WIDTH];
    
    NSShadow *pageShadow = [[NSShadow alloc] init];
    [pageShadow setShadowColor:[NSColor colorWithCalibratedWhite:0
                                                           alpha:SHADOW_ALPHA]];
    [pageShadow setShadowBlurRadius:SHADOW_BLUR];
    [pageShadow setShadowOffset:CGSizeMake(0, SHADOW_OFFSET)];
    [self setShadow:pageShadow];
    
    noteDarkColor = [NSColor colorWithCalibratedRed:NOTE_RED
                                          green:NOTE_GREEN
                                           blue:NOTE_BLUE
                                          alpha:1];
    noteLightColor = [noteDarkColor highlightWithLevel:NOTE_HIGHLIGHT];
    crossDarkColor = [NSColor blackColor];
    crossLightColor = [crossDarkColor highlightWithLevel:CROSS_HIGHLIGHT];
    backlightColor = [NSColor colorWithCalibratedRed:BACKLIGHT_RED
                                               green:BACKLIGHT_GREEN
                                                blue:BACKLIGHT_BLUE
                                               alpha:BACKLIGHT_ALPHA];
        
    NSTrackingAreaOptions options = (NSTrackingMouseEnteredAndExited|
                                     NSTrackingActiveAlways);
    NSDictionary *mainData = [NSDictionary dictionaryWithObject:@"note"
                                                          forKey:@"area"];
    NSDictionary *buttonData = [NSDictionary dictionaryWithObject:@"button"
                                                           forKey:@"area"];
    NSTrackingArea *mainArea = [[NSTrackingArea alloc] initWithRect:mainBounds
                                                        options:options
                                                          owner:self
                                                       userInfo:mainData];
    NSTrackingArea *buttonArea = [[NSTrackingArea alloc] initWithRect:buttonRect
                                                              options:options
                                                                owner:self
                                                             userInfo:buttonData];
    [self addTrackingArea:mainArea];
    [self addTrackingArea:buttonArea];
  }
  return self;
}

- (void)mouseDown:(NSEvent *)theEvent {
  if (noteVisible) {
    NSPoint eventPoint = [theEvent locationInWindow];
    NSPoint localPoint = [self convertPoint:eventPoint
                                   fromView:nil];
    
    if (NSPointInRect(localPoint, buttonRect)) {
      [delegate itemView:self
           buttonClicked:@"dissmissButton"
               withEvent:nil];
    }
    else {
      [delegate itemView:self
        clickedWithEvent:theEvent];
    }
  }
  else {
    [[self superview] mouseDown:theEvent];
  }
}

- (void)mouseDragged:(NSEvent *)theEvent {
  if (noteVisible) {
    [delegate itemView:self
      draggedWithEvent:theEvent];
  }
  else {
    [[self superview] mouseDragged:theEvent];
  }
}

- (void)mouseEntered:(NSEvent *)theEvent {
  NSDictionary *userData = [theEvent userData];
  
  if ([[userData objectForKey:@"area"] isEqual:@"note"]) {
    noteHightlighted = YES;
  }
  if ([[userData objectForKey:@"area"] isEqual:@"button"]) {
    buttonIsHighlighted = YES;
  }
  
  [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
  NSDictionary *userData = [theEvent userData];
  
  if ([[userData objectForKey:@"area"] isEqual:@"note"]) {
    noteHightlighted = NO;
  }
  if ([[userData objectForKey:@"area"] isEqual:@"button"]) {
    buttonIsHighlighted = NO;
  }
  
  [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)aRect {  
  if (noteVisible) {
    if (noteHightlighted) {
      [noteLightColor setFill];
    }
    else {
      [noteDarkColor setFill];
    }
    [notePath fill];
    
    [string drawInRect:textRect];
    
    if (buttonIsHighlighted) {
      [crossDarkColor setStroke];
    }
    else {
      [crossLightColor setStroke];
    }
    [crossPath stroke];
  }
  else {
    if (noteBacklighted) {
      [backlightColor setFill];
    }
    else {
      [[NSColor clearColor] setFill];
    }
    [notePath fill];
  }
}

@end

@implementation CBItemView(Delegation)

- (NSDragOperation)draggingSourceOperationMaskForLocal:(BOOL)isLocal {
  return NSDragOperationMove;
}

- (BOOL)ignoreModifierKeysWhileDragging {
  return YES;
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
  noteBacklighted = YES;
  [self setNeedsDisplay:YES];
  return [sender draggingSourceOperationMask];
}

- (void)draggingExited:(id <NSDraggingInfo>)sender {
  noteBacklighted = NO;
  [self setNeedsDisplay:YES];
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
  NSArray *classes = [NSArray arrayWithObject:[NSAttributedString class]];
  NSPasteboard *pasteboard = [sender draggingPasteboard];
  NSArray *copiedItems = [pasteboard readObjectsForClasses:classes
                                                   options:nil];
  NSAttributedString *copiedString = [copiedItems objectAtIndex:0];
  [delegate itemView:self
      dropWithObject:copiedString];
  
  noteBacklighted = NO;
  return YES;
}

@end