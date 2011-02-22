#import "Cocoa.h"

@class CBItemView;

@protocol CBItemViewDelegate <NSObject>

@optional
- (void)itemViewClicked:(CBItemView *)itemView;

- (void)itemViewDismissButtonClicked:(CBItemView *)itemView;

- (void)itemViewDragOperationStarted:(CBItemView *)itemsView;

@end