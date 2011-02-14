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
    NSPasteboardItem *item = [clipboard itemAtIndex:0];
    CFStringRef URI = (CFStringRef)[item availableTypeFromArray:types];
    CFStringRef URLType = (CFStringRef)[types objectAtIndex:0];
    CFStringRef textType = (CFStringRef)[types objectAtIndex:1];
    if (UTTypeConformsTo(URI, URLType))
    {
        NSString *path = [item stringForType:(NSString *)URI];
        NSURL *fileURL = [[NSURL alloc] initWithString:path];
        CBItemLayer *itemLayer = [[CBItemLayer alloc] initWithWithContentSize:CGSizeMake(200, 200)];
        [itemLayer setImageWithFile:fileURL];
        [itemLayer setDescription:[fileURL lastPathComponent]];
        [itemLayer setFontSize:16];
        [clipboardLayer setItemLayer:itemLayer
                              forRow:1
                              column:1];
    }
    if (UTTypeConformsTo(URI, textType))
    {
        NSLog(@"text");
    }
    [clipboardLayer needsDisplay];
}

@end