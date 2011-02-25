#import "Cloudboard.h"

#define TEXT_PADDING 12
#define BUTTON_PADDING 8
#define BUTTON_LENGTH 16

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

- (BOOL)isVisible
{
    return isVisible;
}

- (void)setVisible:(BOOL)visible
{
    isVisible = visible;
    [self setNeedsDisplay:YES];
}

- (void)startDragWithEvent:(NSEvent *)anEvent
                    object:(id <NSPasteboardWriting>)anObject
{
    NSData *imageData = [self dataWithPDFInsideRect:[self bounds]];
    NSImage *dragImage = [[NSImage alloc] initWithData:imageData];
    NSPoint leftBottom = [self bounds].origin;
    NSPasteboard *pasteboard = [NSPasteboard pasteboardWithName:NSDragPboard];
    [pasteboard clearContents];
    [pasteboard writeObjects:[NSArray arrayWithObject:anObject]];
    
    [self dragImage:dragImage
                 at:leftBottom
             offset:NSZeroSize
              event:anEvent
         pasteboard:pasteboard
             source:self
          slideBack:YES];
}

@end

@implementation CBItemView(Overridden)

- (id)initWithFrame:(NSRect)aRect;
{
    self = [super initWithFrame:aRect];
    if (self != nil)
    {
        delegate = nil;
        
        isVisible = YES;
        isHightlighted = NO;
        isBacklighted = NO;
        
        [self registerForDraggedTypes:[NSArray arrayWithObject:NSPasteboardTypeString]];
        
        CGRect mainBounds = [self bounds];
                
        NSPoint leftBottom = NSMakePoint(mainBounds.origin.x, mainBounds.origin.y);
        NSPoint leftTop = NSMakePoint(mainBounds.origin.x, mainBounds.size.height);
        NSPoint rightBottom = NSMakePoint(mainBounds.size.width, mainBounds.origin.y);
        NSPoint rightTop = NSMakePoint(mainBounds.size.width, mainBounds.size.height);
        notePath = [NSBezierPath bezierPath];
        [notePath moveToPoint:leftBottom];
        [notePath lineToPoint:rightBottom];
        [notePath lineToPoint:rightTop];
        [notePath lineToPoint:leftTop];
        [notePath lineToPoint:leftBottom];
        [notePath closePath];
        
        CGFloat textWidth = mainBounds.size.width - (2 * TEXT_PADDING);
        CGFloat textHeight = mainBounds.size.height - (2 * TEXT_PADDING);
        CGFloat textX = TEXT_PADDING;
        CGFloat textY = TEXT_PADDING;
        textRect = NSMakeRect(textX, textY, textWidth, textHeight);
        
        CGFloat buttonWidth = BUTTON_LENGTH;
        CGFloat buttonHeight = BUTTON_LENGTH;
        CGFloat buttonX = mainBounds.size.width - BUTTON_LENGTH - BUTTON_PADDING;
        CGFloat buttonY = mainBounds.size.height - BUTTON_LENGTH - BUTTON_PADDING;
        buttonRect = NSMakeRect(buttonX, buttonY, buttonWidth, buttonHeight);
        
        NSShadow *pageShadow = [[NSShadow alloc] init];
        [pageShadow setShadowColor:[NSColor colorWithCalibratedWhite:0
                                                               alpha:0.5]];
        [pageShadow setShadowBlurRadius:2];
        [pageShadow setShadowOffset:CGSizeMake(0, -4)];
        [self setShadow:pageShadow];
        
        NSColor *startingColor = [NSColor colorWithCalibratedRed:0.9
                                                           green:0.8
                                                            blue:0.3
                                                           alpha:1];
        NSColor *endingColor = [NSColor colorWithCalibratedRed:0.9
                                                         green:0.8
                                                          blue:0.4
                                                         alpha:1];
        gradient = [[NSGradient alloc] initWithStartingColor:startingColor
                                                 endingColor:endingColor];
        
        NSTrackingAreaOptions options = (NSTrackingMouseEnteredAndExited|
                                         NSTrackingActiveAlways);
        NSTrackingArea *mainArea = [[NSTrackingArea alloc] initWithRect:mainBounds
                                                            options:options
                                                              owner:self
                                                           userInfo:nil];
        [self addTrackingArea:mainArea];
    }
    return self;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    if (isVisible)
    {
        [delegate itemView:self
          clickedWithEvent:theEvent];
    }
    else
    {
        [[self superview] mouseDown:theEvent];
    }
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    if (isVisible)
    {
        [delegate itemView:self
          draggedWithEvent:theEvent];
    }
    else
    {
        [[self superview] mouseDragged:theEvent];
    }
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    isHightlighted = YES;
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    isHightlighted = NO;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)aRect
{
    CGRect viewBounds = [self bounds];
    
    if (isVisible)
    {
        [gradient drawInBezierPath:notePath
                             angle:90];
        
        [string drawInRect:textRect];
        
        if (isHightlighted)
        {
            NSColor *highlightColor = [NSColor colorWithCalibratedWhite:1
                                                                  alpha:0.2];
            [highlightColor set];
            [notePath fill];
        }
    }
    else
    {
        NSBezierPath *path = [NSBezierPath bezierPathWithRect:viewBounds];
        NSColor *clearColor = [NSColor clearColor];
        [clearColor set];
        [path fill];
        
        if (isBacklighted)
        {
            NSColor *highlightColor = [NSColor colorWithCalibratedRed:0.5
                                                                green:0.5
                                                                 blue:1
                                                                alpha:0.2];
            [highlightColor set];
            [path fill];
        }
    }
}

@end

@implementation CBItemView(Delegation)

- (NSDragOperation)draggingSourceOperationMaskForLocal:(BOOL)isLocal
{
    return NSDragOperationMove;
}

- (BOOL)ignoreModifierKeysWhileDragging
{
    return YES;
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    isBacklighted = YES;
    [self setNeedsDisplay:YES];
    return [sender draggingSourceOperationMask];
}

- (void)draggingExited:(id <NSDraggingInfo>)sender
{
    isBacklighted = NO;
    [self setNeedsDisplay:YES];
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    NSArray *classes = [NSArray arrayWithObject:[NSAttributedString class]];
    NSPasteboard *pasteboard = [sender draggingPasteboard];
    NSArray *copiedItems = [pasteboard readObjectsForClasses:classes
                                                     options:nil];
    NSAttributedString *copiedString = [copiedItems objectAtIndex:0];
    [delegate itemView:self
        dropWithObject:copiedString];
    return YES;
}

@end

@implementation CBItemView(Private)

- (void)dismiss
{
    [delegate itemView:self
         buttonClicked:@"dissmissButton"
             withEvent:nil];
}

@end