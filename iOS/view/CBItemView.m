#import "Cloudboard.h"

#define NOTE_PADDING 10

#define TEXT_PADDING 12

#define CROSS_WIDTH 16
#define CROSS_PADDING 10
#define CROSS_LINE_WIDTH 3
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
#define SHADOW_OFFSET 4

#define BORDER_ALPHA 1

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

- (void)setText:(NSAttributedString *)aString; {
  [string autorelease];
  string = aString;
  [self setNeedsDisplay];
}

- (BOOL)isNoteVisible {
  return noteVisible;
}

- (void)setNoteVisible:(BOOL)visible {
  noteVisible = visible;
  [self setNeedsDisplay];
}

@end

@implementation CBItemView(Overridden)

- (id)initWithFrame:(CGRect)aRect {
  self = [super initWithFrame:aRect];
  if (self != nil) {
    delegate = nil;
    noteVisible = NO;
    [self setBackgroundColor:[UIColor clearColor]];
    
    CGRect mainBounds = [self bounds];
    
    CGFloat noteLeftX = mainBounds.origin.x + NOTE_PADDING;
    CGFloat noteRightX = mainBounds.origin.x + mainBounds.size.width - NOTE_PADDING;
    CGFloat noteBottomY = mainBounds.origin.y + NOTE_PADDING;
    CGFloat noteTopY = mainBounds.origin.y + mainBounds.size.height - NOTE_PADDING;
    
    notePath = [UIBezierPath bezierPath];
    [notePath moveToPoint:CGPointMake(noteLeftX, noteBottomY)];
    [notePath addLineToPoint:CGPointMake(noteRightX, noteBottomY)];
    [notePath addLineToPoint:CGPointMake(noteRightX, noteTopY)];
    [notePath addLineToPoint:CGPointMake(noteLeftX, noteTopY)];
    [notePath closePath];
    
    CGFloat textWidth = noteRightX - noteLeftX;
    CGFloat textHeight = noteTopY - noteBottomY;
    CGFloat textX = TEXT_PADDING;
    CGFloat textY = TEXT_PADDING;
    textRect = CGRectMake(textX, textY, textWidth, textHeight);
    
    CGFloat crossLeftX = noteRightX - CROSS_WIDTH - CROSS_PADDING;
    CGFloat crossRightX = noteRightX - CROSS_PADDING;
    CGFloat crossBottomY = noteBottomY + CROSS_WIDTH + CROSS_PADDING;
    CGFloat crossTopY = noteBottomY + CROSS_PADDING;
    crossPath = [UIBezierPath bezierPath];
    [crossPath moveToPoint:CGPointMake(crossLeftX, crossBottomY)];
    [crossPath addLineToPoint:CGPointMake(crossRightX, crossTopY)];
    [crossPath moveToPoint:CGPointMake(crossRightX, crossBottomY)];
    [crossPath addLineToPoint:CGPointMake(crossLeftX, crossTopY)];
    [crossPath setLineWidth:CROSS_LINE_WIDTH];
  }
  return self;
}

- (void)drawRect:(CGRect)aRect {
  if (noteVisible) {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIColor* shadowColor = [UIColor colorWithWhite:0 alpha:SHADOW_ALPHA];
    CGContextSetShadowWithColor(context, CGSizeMake(0, SHADOW_OFFSET), SHADOW_BLUR, [shadowColor CGColor]);
    UIColor* noteDarkColor = [UIColor colorWithRed:NOTE_RED green:NOTE_GREEN blue:NOTE_BLUE alpha:1];
    [noteDarkColor setFill];
    [notePath fill];
    CGContextRestoreGState(context);
    
    [string drawInRect:textRect];
    
    UIColor* crossDarkColor = [UIColor blackColor];
    [crossDarkColor setStroke];
    [crossPath stroke];
  }
  else {
    [[UIColor whiteColor] setFill];
    [notePath fill];
  }
}

- (void)dealloc {
  [crossPath release];
  [notePath release];
  [string release];
  [super dealloc];
}
@end