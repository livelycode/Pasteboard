#import "Cocoa.h"

@class CBItemView;

@protocol CBItemViewDelegate <NSObject>

@optional
- (void)itemViewClicked:(CBItemView *)itemView;

- (void)itemViewDismissButtonClicked:(CBItemView *)itemView;

- (void)itemView:(CBItemView *)itemView
   dragWithEvent:(NSEvent *)anEvent;

- (void)itemView:(CBItemView *)itemView
  dropWithObject:(id <NSPasteboardReading>)anObject;

@end