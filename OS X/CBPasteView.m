#import "Cloudboard.h"

#define NOTE_PADDING 0

#define TEXT_PADDING 5

#define COPY_FONT_SIZE 50

#define NOTE_RED 0.9
#define NOTE_GREEN 0.8
#define NOTE_BLUE 0.3
#define NOTE_HIGHLIGHT 0.2

#define SHADOW_ALPHA 0.8
#define SHADOW_BLUR 3
#define SHADOW_OFFSET -4

#define BORDER_ALPHA 1

@implementation CBPasteView(Private)

- (void)drawNotePathAtRect:(CGRect)noteRect {
  NSBezierPath *notePath = [NSBezierPath bezierPath];
  [notePath moveToPoint:CGPointMake(CGRectGetMinX(noteRect), CGRectGetMinY(noteRect))];
  [notePath lineToPoint:CGPointMake(CGRectGetMaxX(noteRect), CGRectGetMinY(noteRect))];
  [notePath lineToPoint:CGPointMake(CGRectGetMaxX(noteRect), CGRectGetMaxY(noteRect))];
  [notePath lineToPoint:CGPointMake(CGRectGetMinX(noteRect), CGRectGetMaxY(noteRect))];
  [notePath closePath];
  [notePath fill];
  
  NSTrackingAreaOptions options = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways);
  NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"note" forKey:@"area"];
  noteArea = [[NSTrackingArea alloc] initWithRect:noteRect options:options owner:self userInfo:userInfo];
  [self addTrackingArea:noteArea];
}

- (void)drawPasteButtonAtRect:(CGRect)rect {
  NSColor* textColor;
  if(mouseDown) {
    textColor = [NSColor grayColor];
  } else {
    textColor = [NSColor blackColor];
  }
  NSMutableParagraphStyle* centerStyle = [[NSMutableParagraphStyle alloc] init];
  [centerStyle setAlignment:NSCenterTextAlignment];
  NSDictionary *attributes = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSFont fontWithName:@"Monaco" size:COPY_FONT_SIZE], NSFontAttributeName,
                              textColor, NSForegroundColorAttributeName, 
                              centerStyle, NSParagraphStyleAttributeName,
                              nil];
  NSAttributedString *copyText = [[NSAttributedString alloc] initWithString:@"Paste" attributes:attributes];
  [copyText drawInRect:rect];
}

@end

@implementation CBPasteView

- (id)initWithFrame:(CGRect)aRect index:(NSInteger)itemIndex delegate:(id)anObject {
  self = [super initWithFrame:aRect];
  if (self != nil) {
    index = itemIndex;
    delegate = anObject;
    mouseOver = NO;
    mouseDown = NO;
  }
  return self;
}

@end

@implementation CBPasteView(Overridden)

- (void)mouseDown:(NSEvent *)theEvent {
  mouseDown = YES;
  [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent {
  mouseDown = NO;
  NSLog(@"up");
  [self setNeedsDisplay:YES];
  [delegate pasteViewClicked:self index:index];
}

- (void)mouseEntered:(NSEvent *)theEvent {
  if(mouseOver == NO) {
    mouseOver = YES;
    [self setNeedsDisplay:YES];
  }
}

- (void)mouseExited:(NSEvent *)theEvent {
  if(mouseOver == YES) {
    mouseOver = NO;
    [self setNeedsDisplay:YES];
  }
}

- (void)drawRect:(NSRect)aRect {
  CGRect mainBounds = [self bounds];
  CGRect noteRect = CGRectMake(CGRectGetMinX(mainBounds) + NOTE_PADDING,
                               CGRectGetMinY(mainBounds) + NOTE_PADDING,
                               CGRectGetWidth(mainBounds) - 2*NOTE_PADDING,
                               CGRectGetHeight(mainBounds) - 2*NOTE_PADDING);
  NSColor *noteColor = [NSColor colorWithCalibratedRed:NOTE_RED green:NOTE_GREEN blue:NOTE_BLUE alpha:1];
  [noteColor setFill];
  [self drawNotePathAtRect:noteRect];
  //if(mouseOver) {
    [self drawPasteButtonAtRect: CGRectOffset(noteRect, 0, -(CGRectGetHeight(noteRect) - COPY_FONT_SIZE)/2)];
  //}
}

@end