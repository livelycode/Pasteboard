#import "Cocoa.h"

@class CBItemView;

typedef enum {
  CBItemViewAreaMain,
  CBItemViewAreaDismiss
} CBItemViewArea;

@protocol CBItemViewDelegate <NSObject>

@optional
- (void)itemView:(CBItemView *)view clickedWithEvent:(NSEvent *)event;

- (void)itemView:(CBItemView *)view areaClicked:(CBItemViewArea)area withEvent:(NSEvent *)event;

- (void)itemView:(CBItemView *)view draggedWithEvent:(NSEvent *)event;

- (void)itemView:(CBItemView *)view didReceiveDropWithObject:(id <NSPasteboardReading>)object;

@end