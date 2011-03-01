#import "Cloudboard.h"

#define TEXT_PADDING 12
#define BUTTON_PADDING 8
#define BUTTON_LENGTH 16
#define CROSS_PADDING 4

static inline void
drawButton(NSRect aRect)
{
    
}

@implementation CBItemView

- (id <CBItemViewDelegate>)delegate
{
    return delegate;
}

- (void)setDelegate:(id <CBItemViewDelegate>)anObject
{
    delegate = anObject;
}

- (NSAttributedString *)text
{
    return string;
}

- (void)setText:(NSAttributedString *)aString;
{
    string = aString;
    [self setNeedsDisplay:YES];
}

- (BOOL)isNoteVisible
{
    return noteVisible;
}

- (void)setNoteVisible:(BOOL)visible
{
    noteVisible = visible;
    [self setNeedsDisplay:YES];
}

@end

@implementation CBItemView(Overridden)

- (id)initWithFrame:(CGRect)aRect {
  self = [super initWithFrame:aRect];
  return self;
}