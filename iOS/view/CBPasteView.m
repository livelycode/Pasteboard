#import "Cloudboard.h"

@implementation CBPasteView(Private)

- (UIBezierPath *)notePathWithRect:(CGRect)noteRect {
  return [UIBezierPath bezierPathWithRoundedRect:noteRect cornerRadius:16];
}

- (void)drawBorderWithRect:(CGRect)aRect {
  CGFloat width = CGRectGetWidth(aRect) / 52;
  CGRect highlightRect = CGRectOffset(aRect, 0, 1);
  CGFloat cornerRadius = CGRectGetWidth(aRect) / 12;
  UIBezierPath *highlightPath = [UIBezierPath bezierPathWithRoundedRect:highlightRect cornerRadius:cornerRadius];
  [highlightPath setLineWidth:width+2];
  [[UIColor woodHighlightColor] setStroke];
  [highlightPath stroke];
  
  UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:aRect cornerRadius:cornerRadius];
  [borderPath setLineWidth:width+2];
  [[UIColor woodBorderColor] setStroke];
  [borderPath stroke];
  
  UIBezierPath *embossPath = [UIBezierPath bezierPathWithRoundedRect:aRect cornerRadius:cornerRadius];;
  [embossPath setLineWidth:width];
  [[UIColor woodBackgroundColor] setStroke];
  [embossPath stroke];
  [[UIColor woodStructureColor] setStroke];
  [embossPath stroke];
}

- (void)drawTextWithRect:(CGRect)textRect color:(UIColor *)aColor offset:(CGFloat)anOffset strokeWidth:(NSUInteger)aWidth {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  if(aWidth == 0) {
    CGContextSetFillColorWithColor(context, [aColor CGColor]);
    CGContextSetTextDrawingMode (context, kCGTextFill);
  } else {
    CGContextSetRGBFillColor(context, 0, 0, 0, 0);
    CGContextSetLineWidth(context, aWidth);
    CGContextSetStrokeColorWithColor(context, [aColor CGColor]);
    CGContextSetTextDrawingMode (context, kCGTextStroke);
  }
  NSString* string = @"Paste";
  UIFont* font = [UIFont fontWithName:@"Helvetica-Bold" size:(CGRectGetHeight(textRect) / 2)];
  CGSize size = [string sizeWithFont:font];
  CGFloat widthDelta = (CGRectGetWidth(textRect) - size.width) / 2;
  CGFloat heightDelta = (CGRectGetHeight(textRect) - size.height) / 2;
  CGRect rect = CGRectInset(textRect, widthDelta, heightDelta);
  [string drawInRect:CGRectOffset(rect, 0, -anOffset) withFont:font];
  CGContextRestoreGState(context);
}

- (void)handleTap:(UITapGestureRecognizer*)recognizer {
  [delegate handleTapFromPasteView:self];
}

@end

@implementation CBPasteView(Overridden)

- (void)drawRect:(CGRect)aRect {
  CGRect frame = CGRectInset([self bounds], ITEM_PADDING_X, ITEM_PADDING_Y);
  [self drawBorderWithRect:CGRectInset(frame, PASTE_BUTTON_PADDING_X, PASTE_BUTTON_PADDING_Y)];
  
  UIColor *background = [UIColor woodBackgroundColor];
  UIColor *border = [UIColor woodBorderColor];
  UIColor *highlight = [UIColor woodHighlightColor];
  UIColor *structure = [UIColor woodStructureColor];
  [self drawTextWithRect:frame color:highlight offset:-1 strokeWidth:0];
  [self drawTextWithRect:frame color:background offset:0 strokeWidth:0];
  [self drawTextWithRect:frame color:structure offset:0 strokeWidth:0];
  [self drawTextWithRect:frame color:border offset:0 strokeWidth:1];
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
  }
  return self;
}

@end