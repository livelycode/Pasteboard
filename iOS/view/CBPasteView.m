#import "Cloudboard.h"

@implementation CBPasteView(Private)

- (UIBezierPath *)notePathWithRect:(CGRect)noteRect {
  return [UIBezierPath bezierPathWithRoundedRect:noteRect cornerRadius:16];
}

- (void)drawBorderWithRect:(CGRect)aRect {
  CGFloat width = CGRectGetWidth(aRect) / 52;
  CGRect highlightRect = CGRectOffset(aRect, 0, 1);
  UIBezierPath *highlightPath = [UIBezierPath bezierPathWithRoundedRect:highlightRect cornerRadius:16];
  [highlightPath setLineWidth:width+2];
  [[UIColor woodLightColor] setStroke];
  [highlightPath stroke];
  
  UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:aRect cornerRadius:16];
  [borderPath setLineWidth:width+2];
  [[UIColor woodBorderColor] setStroke];
  [borderPath stroke];
  
  UIBezierPath *embossPath = [UIBezierPath bezierPathWithRoundedRect:aRect cornerRadius:16];;
  [embossPath setLineWidth:width];
  [[UIColor woodDarkColor] setStroke];
  [embossPath stroke];
  [[UIColor woodStructureColor] setStroke];
  [embossPath stroke];
}

- (void)drawTextWithRect:(CGRect)textRect color:(UIColor *)aColor offset:(CGFloat)anOffset strokeWidth:(NSUInteger)aWidth {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  //CGContextSelectFont(context, "Lucida Grande Bold", (CGRectGetHeight(textRect) / 2), kCGEncodingMacRoman);  
  if(aWidth == 0) {
    CGContextSetFillColor(context, CGColorGetComponents([aColor CGColor]));
    CGContextSetTextDrawingMode (context, kCGTextFill);
  } else {
    CGContextSetRGBFillColor(context, 0, 0, 0, 0);
    CGContextSetStrokeColor(context, CGColorGetComponents([aColor CGColor]));
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
  
  /*
  UIFont *font = [UIFont fontWithName:@"Lucida Grande Bold" size:(CGRectGetHeight(textRect) / 2)];
  NSString *string = @"Paste";
  NSNumber *strokeWidth = [NSNumber numberWithUnsignedInteger:aWidth];
  NSArray *objects = [NSArray arrayWithObjects:font, aColor, strokeWidth, nil];
  NSArray *keys = [NSArray arrayWithObjects:UIFontAttributeName, UIForegroundColorAttributeName, NSStrokeWidthAttributeName, nil];
  NSDictionary *attributes = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
  CGSize size = [string sizeWithAttributes:attributes];
  CGContextSet
  CGFloat widthDelta = (CGRectGetWidth(textRect) - size.width) / 2;
  CGFloat heightDelta = (CGRectGetHeight(textRect) - size.height) / 2;
  CGRect rect = CGRectInset(textRect, widthDelta, heightDelta);
  [string drawInRect:CGRectOffset(rect, 0, anOffset) withAttributes:attributes];
   */
}

- (void)handleTap:(UITapGestureRecognizer*)recognizer {
  [delegate handleTapFromPasteView:self];
}

@end

@implementation CBPasteView(Overridden)

- (void)drawRect:(CGRect)aRect {
  CGRect frame = CGRectInset([self bounds], ITEM_PADDING_X, ITEM_PADDING_Y);
  [self drawBorderWithRect:CGRectInset(frame, 16, 4)];
  
  UIColor *background = [UIColor woodDarkColor];
  UIColor *border = [UIColor woodBorderColor];
  UIColor *highlight = [UIColor woodLightColor];
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
    /*UIFont *font = [UIFont fontWithName:@"Helvetica Bold" size:40];
    UIColor *color = [UIColor colorWithWhite:0 alpha:0.2];
    self.titleLabel.font = font;
    self.titleLabel.textColor = color;
    [self setTitle:@"Paste" forState:UIControlStateNormal];*/
  }
  return self;
}

@end