#import "Cocoa.h"

@interface CBItem : NSObject
{
    @private
    NSAttributedString *string;
}

- (id)initWithString:(NSAttributedString *)aString;

- (NSAttributedString *)string;

@end