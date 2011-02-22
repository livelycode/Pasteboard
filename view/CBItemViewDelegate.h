#import "Cocoa.h"

@class CBItemView;


@protocol CBItemViewDelegate <NSObject>

@optional
- (void)itemViewClicked:(CBItemView *)itemView;

- (void)itemViewDismissButtonClicked:(CBItemView *)itemView;

- (void)itemViewDragged:(CBItemView *)itemView
              withEvent:(NSEvent *)anEvent;

- (void)itemViewReceivedDropWithObject:(id <NSPasteboardReading>)anObject;

@end