#import "Cocoa.h"
#import "CBItemViewDelegate.h"

@interface CBItemView : UIView
{
  @private
  id delegate;
  NSInteger index;
  NSAttributedString* string;
    
  UIBezierPath* notePath;
  UIBezierPath* crossPath;
  CGRect textRect;
  CGRect buttonRect;
}

- (id)initWithFrame:(CGRect)aRect index:(NSInteger)itemIndex content:(NSAttributedString*)content;

- (id <CBItemViewDelegate>)delegate;

- (void)setDelegate:(id <CBItemViewDelegate>)anObject;

- (NSAttributedString *)text;

@end

@interface CBItemView(Overridden)


@end

@interface CBItemView(Delegation)


@end

@interface CBItemView(Private)

- (void)dismiss;

@end