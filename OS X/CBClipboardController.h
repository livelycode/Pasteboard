#import "Cocoa.h"
#import "CBClipboardViewDelegate.h"

@class CBClipboard;
@class CBClipboardView;

@interface CBClipboardController : NSObject
{
@private
  CBClipboard *clipboard;
  CBClipboardView *clipboardView;
  id changeListener;
}

- (id)initWithFrame:(CGRect)aFrame viewController:(id)viewController;

- (void)setItem:(CBItem *)newItem atIndex:(NSInteger)anIndex;

- (void)insertItem:(CBItem *)newItem atIndex:(NSInteger)anIndex;

- (BOOL)clipboardContainsItem:(CBItem *)anItem;

- (void)addChangeListener:(id)anObject;

@end

@interface CBClipboardController(Delegation) <CBClipboardViewDelegate>

- (void)clipboardView:(CBClipboardView *)aClipboardView didReceiveClick:(NSEvent *)theEvent
       forItemAtIndex:(NSUInteger)anIndex;

- (void)clipboardView:(CBClipboardView *)aClipboardView didReceiveClick:(NSEvent *)theEvent
    forButtonWithName:(NSString *)aName atIndex:(NSUInteger)anIndex;

- (void)clipboardView:(CBClipboardView *)aClipboardView didReceiveDragging:(NSEvent *)theEvent
       forItemAtIndex:(NSUInteger)anIndex;

- (void)clipboardView:(CBClipboardView *)aClipboardView didReceiveDrop:(id <NSPasteboardReading>)anObject
      fromItemAtIndex:(NSUInteger)anIndex;

@end