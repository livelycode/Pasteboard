#import "Cocoa.h"

@interface CBItem : NSObject
{
    @private
    NSPasteboardItem* pasteboardItem;
}

- (id)initWithPasteboardItem:(NSPasteboardItem *)anItem;

- (NSString *)bestMatchForArray:(NSArray *)URIs;

@end