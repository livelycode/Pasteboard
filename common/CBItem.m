#import "Cloudboard.h"

@implementation CBItem

- (id)initWithString:(NSString *)aString
{
    self = [super init];
    if (self != nil)
    {
        string = [aString retain];
    }
    return self;
}

- (id)initWithAttributedString:(NSAttributedString *)aString
{
  self = [self initWithString:[aString string]];
  return self;
}

- (NSString *)string
{
    return string;
}

- (BOOL)isEqual:(id)anObject
{
    BOOL isEqual = NO;
    if ([anObject isMemberOfClass:[self class]])
    {
        if ([string isEqual:[anObject string]])
        {
            isEqual = YES;
        }
    }
    return isEqual;
}

- (NSUInteger)hash
{
    return [string hash];
}

- (void)dealloc {
  [string release];
  [super dealloc];
}

@end