#import "Cocoa.h"
#import "CBItemViewDelegate.h"

@interface CBItemView : UIView
{
  @private
  id delegate;
  NSInteger index;
  NSAttributedString* string;
}

- (id)initWithFrame:(CGRect)aRect index:(NSInteger)itemIndex content:(NSAttributedString*)content;

- (void)setDelegate:(id <CBItemViewDelegate>)anObject;

@end

@interface CBItemView(Overridden)


@end

@interface CBItemView(Delegation)


@end