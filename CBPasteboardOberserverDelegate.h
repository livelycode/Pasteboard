#import "Cocoa.h"

@protocol CBPasteboardOberserverDelegate <NSObject>

@required

- (void)systemPasteboardDidChange:(NSPasteboard *)aPasteboard;

@end