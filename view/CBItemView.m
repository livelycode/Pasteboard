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
    visible = visible;
    if (visible)
    {
        [dismissButton setHidden:NO];
    }
    else
    {
        [dismissButton setHidden:YES];
    }
    [dismissButton setNeedsDisplay:YES];
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
        
        CGRect viewBounds = [self bounds];
        NSTrackingAreaOptions options = (NSTrackingMouseEnteredAndExited|
                                         NSTrackingActiveAlways);
        NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:viewBounds
                                                            options:options
                                                              owner:self
                                                           userInfo:nil];
        [self addTrackingArea:area];
        
        CGFloat textWidth = viewBounds.size.width - (2 * TEXT_PADDING);
        CGFloat textHeight = viewBounds.size.height - (2 * TEXT_PADDING);
        CGFloat textX = TEXT_PADDING;
        CGFloat textY = TEXT_PADDING;
        textField = [[NSTextField alloc] initWithFrame:CGRectMake(textX, textY, textWidth, textHeight)];
        [textField setBordered:NO];
        [textField setBackgroundColor:[NSColor clearColor]];
        [textField setSelectable:NO];
        [self addSubview:textField];
        
        CGFloat buttonWidth = BUTTON_LENGTH;
        CGFloat buttonHeight = BUTTON_LENGTH;
        CGFloat buttonX = viewBounds.size.width - BUTTON_LENGTH - BUTTON_PADDING;
        CGFloat buttonY = viewBounds.size.height - BUTTON_LENGTH - BUTTON_PADDING;
        dismissButton = [[NSButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight)];
        [dismissButton setImage:[NSImage imageNamed:NSImageNameStopProgressTemplate]];
        [dismissButton setButtonType:NSMomentaryChangeButton];
        [dismissButton setBordered:NO];
        [[dismissButton cell] setImageScaling:NSImageScaleProportionallyDown];
        [dismissButton setAction:@selector(dismiss)];
        [dismissButton setTarget:self];
        [self addSubview:dismissButton];	
        
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
        
        [self registerForDraggedTypes:[NSArray arrayWithObject:NSPasteboardTypeString]];
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
        NSPoint leftBottom = NSMakePoint(viewBounds.origin.x, viewBounds.origin.y);
        NSPoint leftTop = NSMakePoint(viewBounds.origin.x, viewBounds.size.height);
        NSPoint rightBottom = NSMakePoint(viewBounds.size.width, viewBounds.origin.y);
        NSPoint rightTop = NSMakePoint(viewBounds.size.width, viewBounds.size.height);
        
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path moveToPoint:leftBottom];
        [path lineToPoint:rightBottom];
        [path lineToPoint:rightTop];
        [path lineToPoint:leftTop];
        [path lineToPoint:leftBottom];
        [path closePath];
        [gradient drawInBezierPath:path
                             angle:90];
        
        if (isHightlighted)
        {
            NSColor *highlightColor = [NSColor colorWithCalibratedWhite:1
                                                                  alpha:0.2];
            [highlightColor set];
            [path fill];
        }
        
        [textField setAttributedStringValue:string]; 
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