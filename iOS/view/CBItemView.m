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

#define BORDER_ALPHA 1

@implementation CBItemView(Private)

- (UIBezierPath *)notePathWithRect:(CGRect)noteRect {
  UIBezierPath *path = [UIBezierPath bezierPath];
  [path moveToPoint:CGPointMake(CGRectGetMinX(noteRect), CGRectGetMinY(noteRect))];
  [path addLineToPoint:CGPointMake(CGRectGetMaxX(noteRect), CGRectGetMinY(noteRect))];
  [path addLineToPoint:CGPointMake(CGRectGetMaxX(noteRect), CGRectGetMaxY(noteRect))];
  [path addLineToPoint:CGPointMake(CGRectGetMinX(noteRect), CGRectGetMaxY(noteRect))];
  [path closePath];
  return path;
}

- (void)drawBorderWithPath:(UIBezierPath *)aPath {
  [aPath addClip];
  [[UIColor colorWithWhite:1 alpha:0.3] setStroke];
  [aPath setLineWidth:2];
  [aPath stroke];
}

- (void)drawNoteWithPath:(UIBezierPath *)aPath {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  UIColor* shadowColor = [UIColor colorWithWhite:0 alpha:0.4];
  CGContextSetShadowWithColor(context, CGSizeMake(0, 2), 8, [shadowColor CGColor]);
  
  UIColor* noteDarkColor = [UIColor colorWithRed:NOTE_RED green:NOTE_GREEN blue:NOTE_BLUE alpha:1];
  [noteDarkColor setFill];
  [aPath fill];
  
  CGContextRestoreGState(context);
/*
  NSColor *endingColor = [NSColor colorWithCalibratedRed:0.9 green:0.8 blue:0.4 alpha:1];
  NSColor *startingColor = [endingColor highlightWithLevel:0.3];
  NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:startingColor endingColor:endingColor];
  [gradient drawInBezierPath:aPath angle:270];
  [NSGraphicsContext restoreGraphicsState];*/
}

- (void)drawTextAtRect:(CGRect)textRect {
  [string drawInRect:textRect withFont: [UIFont systemFontOfSize:16]];
}

@end

@implementation CBItemView

- (id)initWithFrame:(CGRect)aRect content:(NSString*)content delegate:(id <CBItemViewDelegate>)anObject {
  self = [super initWithFrame:aRect];
  if (self != nil) {
    delegate = anObject;
    string = content;
    [self setBackgroundColor:[UIColor clearColor]];
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:recognizer];
  }
  return self;
}

@end

@implementation CBItemView(Overridden)

- (void)drawRect:(CGRect)aRect {
  CGRect noteRect = CGRectInset([self bounds], 24, 24);
  UIBezierPath *notePath = [self notePathWithRect:noteRect];
  [self drawNoteWithPath:notePath];
  [self drawBorderWithPath:notePath];
  [self drawTextAtRect:CGRectInset(noteRect, 8, 8)];
}

- (void)dealloc {
  [string release];
  [delegate release];
  [super dealloc];
}
@end

@implementation CBItemView(Delegation)

- (void)handleTap:(UITapGestureRecognizer*)recognizer {
  [delegate handleTapFromItemView:self];
}

@end

