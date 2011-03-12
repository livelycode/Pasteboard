#import "Cloudboard.h"

@implementation CBPasteView(Private)

- (UIBezierPath *)notePathWithRect:(CGRect)noteRect {
  return [UIBezierPath bezierPathWithRoundedRect:noteRect cornerRadius:16];
}

- (void)drawBorderWithPath:(UIBezierPath *)aPath {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  UIColor* shadowColor = [UIColor colorWithWhite:0 alpha:0.4];
  CGContextSetShadowWithColor(context, CGSizeMake(0, 2), 8, [shadowColor CGColor]);
  [[UIColor colorWithWhite:1 alpha:0.8] setStroke];
  [aPath setLineWidth:lineWidth];
  CGFloat dash[2] = {24, 6};
  [aPath setLineDash:dash count:2 phase:0];
  [aPath stroke];
  CGContextRestoreGState(context);
}

- (void)handleTap:(UITapGestureRecognizer*)recognizer {
  [delegate handleTapFromPasteView:self];
}

@end

@implementation CBPasteView(Overridden)

- (void)drawRect:(CGRect)aRect {
  CGRect noteRect = CGRectInset([self bounds], 32, 32);
  [self drawBorderWithPath:[self notePathWithRect:noteRect]];
}

@end

@implementation CBPasteView

- (id)initWithFrame:(CGRect)aRect delegate:(CBClipboardController*)anObject {
  self = [super initWithFrame:aRect];
  if (self != nil) {
    delegate = anObject;
    lineWidth = CGRectGetWidth(aRect) / 60;
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:recognizer];
    UIFont *font = [UIFont fontWithName:@"Helvetica Bold" size:40];
    UIColor *color = [UIColor colorWithWhite:0 alpha:0.2];
    self.titleLabel.font = font;
    self.titleLabel.textColor = color;
    [self setTitle:@"Paste" forState:UIControlStateNormal];
  }
  return self;
}

@end