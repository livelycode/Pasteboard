#import "Cocoa.h"
#import "CBItemViewDelegate.h"

@interface CBPasteView : UIButton
{
@private
  NSInteger itemFontSize;
  NSInteger itemPaddingX;
  NSInteger itemPaddingY;
  NSInteger pasteButtonPaddingX;
  NSInteger pasteButtonPaddingY;
  CBClipboardController* delegate;
  CGFloat lineWidth;
}
- (id)initWithFrame:(CGRect)aRect delegate:(id)anObject;
@end

@interface CBPasteView(Overridden)
- (void)drawRect:(CGRect)aRect;
@end

@interface CBPasteView(Private)
- (UIBezierPath *)notePathWithRect:(CGRect)noteRect;
- (void)drawBorderWithRect:(CGRect)aRect	;
- (void)handleTap:(UITapGestureRecognizer*)recognizer;
@end