#import "Cloudboard.h"

@implementation CBClipboardController

- (id)initWithClipboard:(CBClipboard *)aClipboard layer:(CALayer *)aLayer;
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

- (void)updateItemnLayers
{
    NSLog(@"foo");
}

@end

@implementation CBClipboardController(Delegation)

- (void)systemPasteboardDidChange:(NSPasteboard *)aPasteboard;
{
    for (NSPasteboardItem *item in [aPasteboard pasteboardItems])
    {
        [clipboard insertItem:item
                      AtIndex:0];
        
        NSPasteboardItem *item = [clipboard itemAtIndex:0];
        CFStringRef URI = (CFStringRef)[item availableTypeFromArray:types];
        CFStringRef URLType = (CFStringRef)[types objectAtIndex:0];
        CFStringRef textType = (CFStringRef)[types objectAtIndex:1];
        if (UTTypeConformsTo(URI, URLType))
        {
            NSLog(@"URL");
        }
        if (UTTypeConformsTo(URI, textType))
        {
            NSLog(@"text");
        }
    }
}

@end