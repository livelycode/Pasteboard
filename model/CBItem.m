#import "Cloudboard.h"

@implementation CBItem

- (id)initWithString:(NSAttributedString *)aString
{
    self = [super init];
    if (self != nil)
    {
        string = aString;
    }
    return self;
}

- (NSAttributedString *)string
{
    return string;
}

- (void)dealloc
{
    [super dealloc];
}

@end