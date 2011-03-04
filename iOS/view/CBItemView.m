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

@implementation CBItemView(Private)

- (void)drawNotePathAtLeft:(CGFloat)left right:(CGFloat)right top:(CGFloat)top bottom:(CGFloat)bottom {
  UIBezierPath* notePath = [UIBezierPath bezierPath];
  [notePath moveToPoint:CGPointMake(left, bottom)];
  [notePath addLineToPoint:CGPointMake(right, bottom)];
  [notePath addLineToPoint:CGPointMake(right, top)];
  [notePath addLineToPoint:CGPointMake(left, top)];
  [notePath closePath];
  UIColor* noteDarkColor = [UIColor colorWithRed:NOTE_RED green:NOTE_GREEN blue:NOTE_BLUE alpha:1];
  [noteDarkColor setFill];
  [notePath fill];
}

- (void)drawTextAtLeft:(CGFloat)left right:(CGFloat)right top:(CGFloat)top bottom:(CGFloat)bottom {
  CGFloat textWidth = right - left;
  CGFloat textHeight = top - bottom;
  CGFloat textX = TEXT_PADDING;
  CGFloat textY = TEXT_PADDING;
  CGRect textRect = CGRectMake(textX, textY, textWidth, textHeight);
  [[string string] drawInRect:textRect withFont: [UIFont systemFontOfSize:16]];
}

- (void)drawCrossAtLeft:(CGFloat)left right:(CGFloat)right top:(CGFloat)top bottom:(CGFloat)bottom {
  UIBezierPath* crossPath = [UIBezierPath bezierPath];
  [crossPath moveToPoint:CGPointMake(left, bottom)];
  [crossPath addLineToPoint:CGPointMake(right, top)];
  [crossPath moveToPoint:CGPointMake(right, bottom)];
  [crossPath addLineToPoint:CGPointMake(left, top)];
  [crossPath setLineWidth:CROSS_LINE_WIDTH];
  UIColor* crossDarkColor = [UIColor blackColor];
  [crossDarkColor setStroke];
  [crossPath stroke];
}

@end

@implementation CBItemView

- (id)initWithFrame:(CGRect)aRect index:(NSInteger)itemIndex content:(NSAttributedString*)content delegate:(id <CBItemViewDelegate>)anObject {
  self = [super initWithFrame:aRect];
  if (self != nil) {
    index = itemIndex;
    delegate = anObject;
    string = content;
    [self setBackgroundColor:[UIColor clearColor]];
  }
  return self;
}

@end

@implementation CBItemView(Overridden)

- (void)drawRect:(CGRect)aRect {
  CGRect mainBounds = [self bounds];
  CGFloat noteLeft = mainBounds.origin.x + NOTE_PADDING;
  CGFloat noteRight = mainBounds.origin.x + mainBounds.size.width - NOTE_PADDING;
  CGFloat noteBottom = mainBounds.origin.y + NOTE_PADDING;
  CGFloat noteTop = mainBounds.origin.y + mainBounds.size.height - NOTE_PADDING;
  
  CGFloat crossLeft = noteRight - CROSS_WIDTH - CROSS_PADDING;
  CGFloat crossRight = noteRight - CROSS_PADDING;
  CGFloat crossBottom = noteBottom + CROSS_WIDTH + CROSS_PADDING;
  CGFloat crossTop = noteBottom + CROSS_PADDING;
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  UIColor* shadowColor = [UIColor colorWithWhite:0 alpha:SHADOW_ALPHA];
  CGContextSetShadowWithColor(context, CGSizeMake(0, SHADOW_OFFSET), SHADOW_BLUR, [shadowColor CGColor]);
  [self drawNotePathAtLeft:noteLeft right:noteRight top:noteTop bottom:noteBottom];
  CGContextRestoreGState(context);
  
  [self drawCrossAtLeft:crossLeft right:crossRight top:crossTop bottom:crossBottom];
  [self drawTextAtLeft:noteLeft right:noteRight top:noteTop bottom:noteBottom];
}

- (void)dealloc {
  [string release];
  [delegate release];
  [super dealloc];
}
@end