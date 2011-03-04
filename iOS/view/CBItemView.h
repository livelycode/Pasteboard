#import "Cocoa.h"
#import "CBItemViewDelegate.h"

@interface CBItemView : UIView
{
  @private
  id delegate;
  NSInteger index;
  NSAttributedString* string;
}

- (id)initWithFrame:(CGRect)aRect index:(NSInteger)itemIndex content:(NSAttributedString*)content delegate:(id <CBItemViewDelegate>)anObject;

@end

@interface CBItemView(Overridden)


@end

@interface CBItemView(Delegation)


@end

@interface CBItemView(Private)
- (void)drawNotePathAtLeft:(CGFloat)left right:(CGFloat)right top:(CGFloat)top bottom:(CGFloat)bottom;
- (void)drawTextAtLeft:(CGFloat)left right:(CGFloat)right top:(CGFloat)top bottom:(CGFloat)bottom;
- (void)drawCrossAtLeft:(CGFloat)left right:(CGFloat)right top:(CGFloat)top bottom:(CGFloat)bottom;

@end