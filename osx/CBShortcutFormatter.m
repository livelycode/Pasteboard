//
//  CBShortcutFormatter.m
//  cloudboard-mac
//
//  Created by Mirko on 3/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CBShortcutFormatter.h"


@implementation CBShortcutFormatter

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (NSString *)stringForObjectValue:(id)anObject {
  return (NSString*)anObject;
}

- (BOOL)getObjectValue:(id *)anObject forString:(NSString *)string errorDescription:(NSString **)error {
  anObject = &string;
  return YES;
}

- (void)dealloc
{
    [super dealloc];
}

@end
