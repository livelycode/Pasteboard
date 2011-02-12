#import "Cloudboard.h"

@implementation CBItemLayer

- (id)initWithWithContentSize:(CGSize)aSize
{
    self = [super init];
    if (self != nil)
    {
        contentLayer = [CATextLayer layer];
        [contentLayer setFrame:CGRectMake(0, 20, aSize.width, aSize.height)];
        
        descriptionLayer = [CATextLayer layer];
        [descriptionLayer setFrame:CGRectMake(0, 0, aSize.width, 20)];
        
        [self setFrame:CGRectMake(0, 0, aSize.width, aSize.height + 20)];
        [self addSublayer:contentLayer];
        [self addSublayer:descriptionLayer];
    }
    return self;
}

- (void)setImageWithFile:(NSURL *)fileURL;
{
    NSDictionary* options = [NSDictionary dictionaryWithObject:(id)kCFBooleanTrue
                                                        forKey:(id)kQLThumbnailOptionIconModeKey];
    CGImageRef imageRef = QLThumbnailImageCreate(kCFAllocatorDefault, (CFURLRef) fileURL, size, (CFDictionaryRef)options);
    if (imageRef != NULL)
    {
        [contentLayer setContents:(id)imageRef];
        [contentLayer setContentsGravity:kCAGravityCenter];
        CFRelease(imageRef);
    }
    else
    {
        NSString *path = [fileURL path];
        NSImage *image = [[NSWorkspace sharedWorkspace] iconForFile:path];
        [image setSize:size];
        [contentLayer setContents:image];
        [contentLayer setContentsGravity:kCAGravityResizeAspect];
    }
}

- (void)setText:(NSString *)aString;
{
    [contentLayer setWrapped:YES];
    [contentLayer setTruncationMode:kCATruncationEnd];
    [contentLayer setAlignmentMode:kCAAlignmentLeft];
    [contentLayer setString:aString];
}

- (void)setDescription:(NSString *)aString
{
    [descriptionLayer setAlignmentMode:kCAAlignmentCenter];
    [descriptionLayer setString:aString];
}

- (void)setFontSize:(CGFloat)fontSize
{
    [contentLayer setFontSize:fontSize];
    [descriptionLayer setFontSize:fontSize];
}

@end