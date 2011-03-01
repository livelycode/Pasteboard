#import "Cocoa.h"

@class CBItemView;

@protocol CBItemViewDelegate <NSObject>

@optional
- (void)itemView:(CBItemView *)itemView
clickedWithEvent:(NSEvent *)anEvent;

- (void)itemView:(CBItemView *)itemView
   buttonClicked:(NSString *)aName
       withEvent:(NSEvent *)anEvent;

- (void)itemView:(CBItemView *)itemView
draggedWithEvent:(NSEvent *)anEvent;

- (void)itemView:(CBItemView *)itemView
  dropWithObject:(id <NSPasteboardReading>)anObject;

@end