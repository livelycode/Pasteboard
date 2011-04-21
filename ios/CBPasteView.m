#import "Cloudboard.h"

@implementation CBPasteView(Private)
- (void)initDeviceSpecificParams {
  if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    itemFontSize = 16;
    itemPaddingX = 16;
    itemPaddingY = 24;
    pasteButtonPaddingX = 16;
    pasteButtonPaddingY = 4;
  } else {
    itemFontSize = 10;
    itemPaddingX = 6;
    itemPaddingY = 10;
    pasteButtonPaddingX = 0;
    pasteButtonPaddingY = -2;
  }
}

- (UIBezierPath *)notePathWithRect:(CGRect)noteRect {
  return [UIBezierPath bezierPathWithRoundedRect:noteRect cornerRadius:16];
}

- (void)drawBorderWithRect:(CGRect)aRect {
  CGFloat width = CGRectGetWidth(aRect) / 52;
  CGRect highlightRect = CGRectOffset(aRect, 0, 1/SCALE);
  CGFloat cornerRadius = CGRectGetWidth(aRect) / 12;
  UIBezierPath *highlightPath = [UIBezierPath bezierPathWithRoundedRect:highlightRect cornerRadius:cornerRadius];
  [highlightPath setLineWidth:width+2/SCALE];
  [[UIColor woodHighlightColor] setStroke];
  [highlightPath stroke];
  
  UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:aRect cornerRadius:cornerRadius];
  [borderPath setLineWidth:width+2/SCALE];
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
    CGContextSetLineWidth(context, aWidth/SCALE);
    CGContextSetStrokeColorWithColor(context, [aColor CGColor]);
    CGContextSetTextDrawingMode (context, kCGTextStroke);
  }
  NSString* string = @"Paste";
  UIFont* font = [UIFont fontWithName:@"Helvetica-Bold" size:(CGRectGetHeight(textRect) / 2)];
  CGSize size = [string sizeWithFont:font];
  CGFloat widthDelta = (CGRectGetWidth(textRect) - size.width) / 2;
  CGFloat heightDelta = (CGRectGetHeight(textRect) - size.height) / 2;
  CGRect rect = CGRectInset(textRect, widthDelta, heightDelta);
  [string drawInRect:CGRectOffset(rect, 0, -anOffset/SCALE) withFont:font];
  CGContextRestoreGState(context);
}

- (void)handleTap:(UITapGestureRecognizer*)recognizer {
  [delegate handleTapFromPasteView:self];
}

@end

@implementation CBPasteView(Overridden)

- (void)drawRect:(CGRect)aRect {
  CGRect frame = CGRectInset([self bounds], itemPaddingX, itemPaddingY);
  [self drawBorderWithRect:CGRectInset(frame, pasteButtonPaddingX, pasteButtonPaddingY)];
  
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
    [self initDeviceSpecificParams];
    delegate = anObject;
    lineWidth = CGRectGetWidth(aRect) / 60;
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:recognizer];
  }
  return self;
}

@end