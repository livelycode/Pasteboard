#import "Cocoa.h"

@class CBItemView;

@protocol CBItemViewDelegate <NSObject>

@optional
- (void)itemView:(CBItemView *)itemView
clickedWithEvent:(NSEvent *)anEvent;

- (void)itemViewDismissButtonClicked:(CBItemView *)itemView;

- (void)itemView:(CBItemView *)itemView
   dragWithEvent:(NSEvent *)anEvent;

- (void)itemView:(CBItemView *)itemView
  dropWithObject:(id <NSPasteboardReading>)anObject;

@end