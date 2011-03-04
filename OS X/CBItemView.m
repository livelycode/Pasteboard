#import "Cloudboard.h"

#define NOTE_PADDING 0

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

#define SHADOW_ALPHA 0.8
#define SHADOW_BLUR 3
#define SHADOW_OFFSET -4

#define BORDER_ALPHA 1

@implementation CBItemView(Private)

- (void)drawNotePathAtLeft:(CGFloat)left right:(CGFloat)right top:(CGFloat)top bottom:(CGFloat)bottom {
  NSBezierPath *notePath = [NSBezierPath bezierPath];
  [notePath moveToPoint:CGPointMake(left, bottom)];
  [notePath lineToPoint:CGPointMake(right, bottom)];
  [notePath lineToPoint:CGPointMake(right, top)];
  [notePath lineToPoint:CGPointMake(left, top)];
  [notePath closePath];
  [notePath fill];
  
  CGRect areaRect = CGRectMake(left, bottom, (right - left), (top - bottom));
  NSTrackingAreaOptions options = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways);
  NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"note" forKey:@"area"];
  noteArea = [[NSTrackingArea alloc] initWithRect:areaRect options:options owner:self userInfo:userInfo];
  [self addTrackingArea:noteArea];
}

- (void)drawTextAtLeft:(CGFloat)left right:(CGFloat)right top:(CGFloat)top bottom:(CGFloat)bottom {
  CGFloat textWidth = right - left;
  CGFloat textHeight = top - bottom;
  CGFloat textX = TEXT_PADDING;
  CGFloat textY = TEXT_PADDING;
  [string drawInRect:CGRectMake(textX, textY, textWidth, textHeight)];
}

- (void)drawCrossAtLeft:(CGFloat)left right:(CGFloat)right top:(CGFloat)top bottom:(CGFloat)bottom {
  NSBezierPath *crossPath = [NSBezierPath bezierPath];
  [crossPath moveToPoint:CGPointMake(left, bottom)];
  [crossPath lineToPoint:CGPointMake(right, top)];
  [crossPath moveToPoint:CGPointMake(right, bottom)];
  [crossPath lineToPoint:CGPointMake(left, top)];
  [crossPath setLineWidth:CROSS_WIDTH];
  [crossPath stroke];
  
  CGRect areaRect = CGRectMake(left, bottom, (right - left), (top - bottom));
  NSTrackingAreaOptions options = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways);
  NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"button" forKey:@"area"];
  buttonArea = [[NSTrackingArea alloc] initWithRect:areaRect options:options owner:self userInfo:userInfo];
  [self addTrackingArea:buttonArea];
}

@end

@implementation CBItemView

- (id)initWithFrame:(CGRect)aRect index:(NSInteger)itemIndex content:(NSAttributedString*)content delegate:(id <CBItemViewDelegate>)anObject {
  self = [super initWithFrame:aRect];
  if (self != nil) {
    index = itemIndex;
    delegate = anObject;
    string = content;
  }
  return self;
}

- (void)startDragWithEvent:(NSEvent *)anEvent object:(id <NSPasteboardWriting>)anObject {
  NSData *imageData = [self dataWithPDFInsideRect:[self bounds]];
  NSImage *dragImage = [[NSImage alloc] initWithData:imageData];
  NSPoint leftBottom = [self bounds].origin;
  NSPasteboard *pasteboard = [NSPasteboard pasteboardWithName:NSDragPboard];
  [pasteboard clearContents];
  [pasteboard writeObjects:[NSArray arrayWithObject:anObject]];
  [self dragImage:dragImage at:leftBottom offset:NSZeroSize event:anEvent pasteboard:pasteboard source:self slideBack:YES];
}

@end

@implementation CBItemView(Overridden)

- (void)mouseDown:(NSEvent *)theEvent {
  if (noteVisible) {
    NSPoint eventPoint = [theEvent locationInWindow];
    NSPoint localPoint = [self convertPoint:eventPoint fromView:nil];
    
    if (NSPointInRect(localPoint, [buttonArea rect])) {
      [delegate itemView:self buttonClicked:@"dissmissButton" withEvent:nil];
    }
    
    if (NSPointInRect(localPoint, [noteArea rect])) {
      [delegate itemView:self clickedWithEvent:theEvent];
    }
  }
  else {
    [[self superview] mouseDown:theEvent];
  }
}

- (void)mouseDragged:(NSEvent *)theEvent {
  if (noteVisible) {
    [delegate itemView:self draggedWithEvent:theEvent];
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
  CGRect mainBounds = [self bounds];
  CGFloat noteLeft = mainBounds.origin.x + NOTE_PADDING;
  CGFloat noteRight = mainBounds.origin.x + mainBounds.size.width - NOTE_PADDING;
  CGFloat noteBottom = mainBounds.origin.y + NOTE_PADDING;
  CGFloat noteTop = mainBounds.origin.y + mainBounds.size.height - NOTE_PADDING;
  
  CGFloat crossLeft = noteRight - CROSS_WIDTH - CROSS_PADDING;
  CGFloat crossRight = noteRight - CROSS_PADDING;
  CGFloat crossBottom = noteBottom + CROSS_WIDTH + CROSS_PADDING;
  CGFloat crossTop = noteBottom + CROSS_PADDING;
  
  NSColor *noteColor = [NSColor colorWithCalibratedRed:NOTE_RED green:NOTE_GREEN blue:NOTE_BLUE alpha:1];
  NSColor *crossColor = [NSColor blackColor];
  NSColor *backlightColor = [NSColor blueColor];

  if (noteVisible) {
    if (noteHightlighted) {
      [noteColor setFill];;
    }
    else {
      [noteColor setFill];
    }
    [self drawNotePathAtLeft:noteLeft right:noteRight top:noteTop bottom:noteBottom];
    
    [self drawTextAtLeft:noteLeft right:noteRight top:noteTop bottom:noteBottom];
    
    if (buttonIsHighlighted) {
      [crossColor setStroke];
    }
    else {
      [crossColor setStroke];
    }
    [self drawCrossAtLeft:crossLeft right:crossRight top:crossTop bottom:crossBottom];
  }
  else {
    if (noteBacklighted) {
      [backlightColor setFill];
    }
    else {
      [[NSColor clearColor] setFill];
    }
    [self drawNotePathAtLeft:noteLeft right:noteRight top:noteTop bottom:noteBottom];
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
  NSArray *copiedItems = [pasteboard readObjectsForClasses:classes options:nil];
  NSAttributedString *copiedString = [copiedItems objectAtIndex:0];
  [delegate itemView:self dropWithObject:copiedString];
  noteBacklighted = NO;
  return YES;
}

@end