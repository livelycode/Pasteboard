#import "Cocoa.h"

@class CBItemView;

@protocol CBItemViewDelegate <NSObject>

@optional
- (void)itemViewClicked:(CBItemView *)view index:(NSInteger)index;

@end