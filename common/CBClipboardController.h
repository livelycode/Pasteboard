#import "Cocoa.h"
#import "CBClipboardViewDelegate.h"

@class CBClipboard;
@class CBClipboardView;
@class CBSettingsController;

@interface CBClipboardController : NSObject
{
    @private
    CBClipboard *clipboard;
    CBClipboardView *clipboardView;
    id changeListener;
    CBSettingsController *settingsController;
    NSButton *settingsButton;
}
							
- (id)initWithFrame:(CGRect)aFrame
     viewController:(id)viewController;

- (void)insertItem:(CBItem *)newItem
           atIndex:(NSInteger)anIndex;

- (BOOL)clipboardContainsItem:(CBItem *)anItem;

- (void)addChangeListener:(id)anObject;

@end

@interface CBClipboardController(Delegation) <CBClipboardViewDelegate>

- (void)clipboardView:(CBClipboardView *)aClipboardView
      didReceiveClick:(NSEvent *)theEvent
       forItemAtIndex:(NSUInteger)anIndex;

- (void)clipboardView:(CBClipboardView *)aClipboardView
      didReceiveClick:(NSEvent *)theEvent
    forButtonWithName:(NSString *)aName
              atIndex:(NSUInteger)anIndex;

- (void)clipboardView:(CBClipboardView *)aClipboardView
   didReceiveDragging:(NSEvent *)theEvent
       forItemAtIndex:(NSUInteger)anIndex;

- (void)clipboardView:(CBClipboardView *)aClipboardView
       didReceiveDrop:(id <NSPasteboardReading>)anObject
      fromItemAtIndex:(NSUInteger)anIndex;

@end