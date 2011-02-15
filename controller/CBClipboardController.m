#import "Cloudboard.h"

@implementation CBClipboardController

- (id)initWithClipboard:(CBClipboard *)aClipboard
                  layer:(CBClipboardLayer *)aLayer;
{
    self = [super init];
    if (self != nil)
    {
        clipboard = aClipboard;
        clipboardLayer = aLayer;
        types = nil;
    }
    return self;
}

- (void)setTypes:(NSArray *)anArray
{
    types = anArray;
}

- (void)updateItemLayers
{
    for (CALayer *layer in [clipboardLayer sublayers])
    {
        [layer removeFromSuperlayer];
    }
    
    NSUInteger row = 1;
    NSUInteger column = 1;
    for (NSPasteboardItem *item in [clipboard items])
    {
        CBSettings *settings = [CBSettings sharedSettings];
        CGFloat opacity = [settings floatForKey:@"shadowOpacity"];
        CGFloat radius = [settings floatForKey:@"shadowRadius"];
        CGFloat offset = [settings floatForKey:@"shadowOffset"];
        CGFloat padding = [settings floatForKey:@"pagePadding"];
        CGSize itemSize = [clipboardLayer itemLayerSize];
        NSString *URI = [item availableTypeFromArray:types];

        CBItemLayer *itemLayer = [[CBItemLayer alloc] initWithWithContentSize:itemSize];
        [itemLayer setPadding:padding];
        [itemLayer setShadowWithOpacity:opacity
                                 radius:radius
                                 offset:offset];
        [itemLayer setText:[item stringForType:URI]];	
        [itemLayer setFontSize:16];
        
        [clipboardLayer setItemLayer:itemLayer
                              forRow:row
                              column:column];
        column = column + 1;
        if (column > [clipboardLayer columns])
        {
            row = row + 1;
            column = 1;
        }
        [clipboardLayer needsDisplay]; 
    }
    
}

@end