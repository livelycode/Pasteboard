#import "Cocoa.h"
#import "CBItemViewDelegate.h"

@interface CBItemView : UIView
{
  @private
  id delegate;
  NSInteger index;
  NSString* string;
}

- (id)initWithFrame:(CGRect)aRect index:(NSInteger)itemIndex content:(NSString*)content delegate:(id <CBItemViewDelegate>)anObject;

@end

@interface CBItemView(Overridden)


@end

@interface CBItemView(Delegation)
- (void)handleTap:(UITapGestureRecognizer*)recognizer;
@end

@interface CBItemView(Private)
- (void)drawNotePathAtLeft:(CGFloat)left right:(CGFloat)right top:(CGFloat)top bottom:(CGFloat)bottom;
- (void)drawTextAtLeft:(CGFloat)left right:(CGFloat)right top:(CGFloat)top bottom:(CGFloat)bottom;

@end