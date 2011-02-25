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
        
        noteVisible = YES;
        noteHightlighted = NO;
        noteBacklighted = NO;
        
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
        NSDictionary *mainData = [NSDictionary dictionaryWithObject:@"note"
                                                              forKey:@"area"];
        NSTrackingArea *mainArea = [[NSTrackingArea alloc] initWithRect:mainBounds
                                                            options:options
                                                              owner:self
                                                           userInfo:mainData];
        [self addTrackingArea:mainArea];
        
        NSDictionary *buttonData = [NSDictionary dictionaryWithObject:@"button"
                                                              forKey:@"area"];
        NSTrackingArea *buttonArea = [[NSTrackingArea alloc] initWithRect:buttonRect
                                                                  options:options
                                                                    owner:self
                                                                 userInfo:buttonData];
        [self addTrackingArea:buttonArea];
    }
    return self;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    if (noteVisible)
    {
        NSPoint eventPoint = [theEvent locationInWindow];
        NSPoint localPoint = [self convertPoint:eventPoint
                                       fromView:nil];
        if (NSPointInRect(localPoint, buttonRect))
        {
            [delegate itemView:self
                 buttonClicked:@"dissmissButton"
                     withEvent:nil];
        }
        else
        {
            [delegate itemView:self
              clickedWithEvent:theEvent];
        }
    }
    else
    {
        [[self superview] mouseDown:theEvent];
    }
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    if (noteVisible)
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
    NSDictionary *userData = [theEvent userData];
    if ([[userData objectForKey:@"area"] isEqual:@"note"])
    {
        noteHightlighted = YES;
    }
    if ([[userData objectForKey:@"area"] isEqual:@"button"])
    {
        buttonIsHighlighted = YES;
    }
    
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    NSDictionary *userData = [theEvent userData];
    if ([[userData objectForKey:@"area"] isEqual:@"note"])
    {
        noteHightlighted = NO;
    }
    if ([[userData objectForKey:@"area"] isEqual:@"button"])
    {
        buttonIsHighlighted = NO;
    }
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)aRect
{
    CGRect viewBounds = [self bounds];
    
    if (noteVisible)
    {
        [gradient drawInBezierPath:notePath
                             angle:90];
        [string drawInRect:textRect];
        
        if (noteHightlighted)
        {
            NSColor *highlightColor = [NSColor colorWithCalibratedWhite:1
                                                                  alpha:0.2];
            [highlightColor set];
            [notePath fill];
        }
        
        NSColor* buttonColor = [NSColor colorWithCalibratedWhite:0.3
                                                           alpha:1];
        if (buttonIsHighlighted)
        {
            buttonColor = [NSColor blackColor];

        }
        [buttonColor set];
        
        CGFloat leftX = buttonRect.origin.x + CROSS_PADDING;
        CGFloat rightX = buttonRect.origin.x + buttonRect.size.width - CROSS_PADDING;
        CGFloat bottomY = buttonRect.origin.y + CROSS_PADDING;
        CGFloat topY = buttonRect.origin.y + buttonRect.size.height - CROSS_PADDING;
        [NSBezierPath setDefaultLineWidth:3];
        [NSBezierPath strokeLineFromPoint:NSMakePoint(leftX, bottomY)
                                  toPoint:NSMakePoint(rightX, topY)];
        [NSBezierPath strokeLineFromPoint:NSMakePoint(rightX, bottomY)
                                  toPoint:NSMakePoint(leftX, topY)];
    }
    else
    {
        NSBezierPath *path = [NSBezierPath bezierPathWithRect:viewBounds];
        NSColor *clearColor = [NSColor clearColor];
        [clearColor set];
        [path fill];
        
        if (noteBacklighted)
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
    noteBacklighted = YES;
    [self setNeedsDisplay:YES];
    return [sender draggingSourceOperationMask];
}

- (void)draggingExited:(id <NSDraggingInfo>)sender
{
    noteBacklighted = NO;
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