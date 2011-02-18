#import "Cocoa.h"

@class CBItemView;

@protocol CBItemViewDelegate <NSObject>

- (void)itemViewClicked:(CBItemView *)itemView;

- (void)itemViewDismissButtonClicked:(CBItemView *)itemView;

@end