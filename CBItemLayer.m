#import "Cloudboard.h"

@implementation CBItemLayer

- (id)initWithItem:(CBItem *)anItem forTypes:(NSArray *)types
{
    self = [super init];
    if (self != nil)
    {
        NSString *URI = [anItem bestMatchForArray:types];
        NSLog(@"%@", URI);
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

- (void)setColor:(NSColor *)aColor;
{
    NSColor *RGBColor = [aColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    CGFloat red = [RGBColor redComponent];
    CGFloat green = [RGBColor greenComponent];
    CGFloat blue = [RGBColor blueComponent];
    CGFloat alpha = [RGBColor alphaComponent];
    CGColorRef colorRef = CGColorCreateGenericRGB(red, green, blue, alpha);
    [contentLayer setBackgroundColor:colorRef];
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

- (CALayer *)layerWithContentSize:(CGSize)aSize
{
    contentLayer = [CATextLayer layer];
    [contentLayer setFrame:CGRectMake(0, 20, aSize.width, aSize.height)];
    descriptionLayer = [CATextLayer layer];
    [descriptionLayer setFrame:CGRectMake(0, 0, aSize.width, 20)];
    mainLayer = [CALayer layer];
    [mainLayer setFrame:CGRectMake(0, 0, aSize.width, aSize.height + 20)];
    [mainLayer addSublayer:contentLayer];
    [mainLayer addSublayer:descriptionLayer];
	return mainLayer; 
}

@end