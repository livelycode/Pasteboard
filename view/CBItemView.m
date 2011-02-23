#import "Cloudboard.h"

#define TEXT_PADDING 12
#define BUTTON_PADDING 8
#define BUTTON_LENGTH 16

@implementation CBItemView

- (void)mouseDown:(NSEvent *)theEvent
{
    if (visible)
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
    if (visible)
    {
        [delegate itemView:self
          draggedWithEvent:theEvent];
    }
    else
    {
        [[self superview] mouseDragged:theEvent];
    }
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
    NSLog(@"enter");
    return [sender draggingSourceOperationMask];
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

- (void)draggingExited:(id <NSDraggingInfo>)sender
{
    NSLog(@"exit");
}

- (id)initWithFrame:(NSRect)aRect;
{
    self = [super initWithFrame:aRect];
    if (self != nil)
    {
        visible = YES;
        
        [self registerForDraggedTypes:[NSArray arrayWithObject:NSPasteboardTypeString]];
        
        textField = [[NSTextField alloc] initWithFrame:CGRectZero];
        [textField setBordered:NO];
        [textField setBackgroundColor:[NSColor clearColor]];
        [textField setSelectable:NO];
        [self addSubview:textField];
        
        button = [[NSButton alloc] initWithFrame:CGRectZero];
        [button setImage:[NSImage imageNamed:NSImageNameStopProgressTemplate]];
        [button setButtonType:NSMomentaryChangeButton];
        [button setBordered:NO];
        [[button cell] setImageScaling:NSImageScaleProportionallyDown];
        [button setAction:@selector(dismiss)];
        [button setTarget:self];
        [self addSubview:button];	
        
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
        
        
    }
    return self;
}

- (void)setDelegate:(id <CBItemViewDelegate>)anObject
{
    delegate = anObject;
}

- (void)setText:(NSAttributedString *)aString;
{
    string = aString;
    [self setNeedsDisplay:YES];
}

- (void)setVisible:(BOOL)isVisible
{
    visible = isVisible;
    if (visible)
    {
        [self setAlphaValue:1];
    }
    else
    {
        [self setAlphaValue:0];
    }
}

- (BOOL)isVisible
{
    return visible;
}

- (void)drawRect:(NSRect)aRect
{
    CGRect viewBounds = [self bounds];
    NSPoint leftBottom = NSMakePoint(viewBounds.origin.x, viewBounds.origin.y);
    NSPoint leftTop = NSMakePoint(viewBounds.origin.x, viewBounds.size.height);
    NSPoint rightBottom = NSMakePoint(viewBounds.size.width, viewBounds.origin.y);
    NSPoint rightTop = NSMakePoint(viewBounds.size.width, viewBounds.size.height);
    
    CGFloat textWidth = viewBounds.size.width - (2 * TEXT_PADDING);
    CGFloat textHeight = viewBounds.size.height - (2 * TEXT_PADDING);
    CGFloat textX = TEXT_PADDING;
    CGFloat textY = TEXT_PADDING;
    [textField setFrame:CGRectMake(textX, textY, textWidth, textHeight)];
    [textField setAttributedStringValue:string];
    [textField setNeedsDisplay:YES];
    
    CGFloat buttonWidth = BUTTON_LENGTH;
    CGFloat buttonHeight = BUTTON_LENGTH;
    CGFloat buttonX = viewBounds.size.width - BUTTON_LENGTH - BUTTON_PADDING;
    CGFloat buttonY = viewBounds.size.height - BUTTON_LENGTH - BUTTON_PADDING;;
    [button setFrame:CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight)];
    
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path moveToPoint:leftBottom];
    [path lineToPoint:rightBottom];
    [path lineToPoint:rightTop];
    [path lineToPoint:leftTop];
    [path lineToPoint:leftBottom];
    [path closePath];
    [gradient drawInBezierPath:path
                         angle:90];
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