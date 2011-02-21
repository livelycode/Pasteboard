#import "Cocoa.h"

@interface CBItem : NSObject
{
    @private
    NSAttributedString *string;
}

- (id)initWithString:(NSAttributedString *)aString;

- (NSAttributedString *)string;

- (BOOL)isEqual:(id)anObject;

- (NSUInteger)hash;

@end