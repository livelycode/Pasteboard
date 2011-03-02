#import "Cocoa.h"
#import "CBItemViewDelegate.h"

@interface CBItemView : UIView
{
  @private
  id delegate;
  NSAttributedString* string;
    
  UIBezierPath* notePath;
  UIBezierPath* crossPath;
  CGRect textRect;
  CGRect buttonRect;

  BOOL noteVisible;
}

- (id <CBItemViewDelegate>)delegate;

- (void)setDelegate:(id <CBItemViewDelegate>)anObject;

- (NSAttributedString *)text;

- (void)setText:(NSAttributedString *)aString;

- (BOOL)isNoteVisible;

- (void)setNoteVisible:(BOOL)visible;

@end

@interface CBItemView(Overridden)


@end

@interface CBItemView(Delegation)


@end

@interface CBItemView(Private)

- (void)dismiss;

@end