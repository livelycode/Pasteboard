//
//  HTTPConnectionDelegate.m
//  cloudboard
//
//  Created by Mirko on 2/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HTTPConnectionDelegate.h"


@implementation HTTPConnectionDelegate

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}
-(void)HTTPServer:(HTTPServer *)server didMakeNewConnection:(HTTPConnection *)connection {
  
}
- (void)HTTPConnection:(HTTPConnection *)connection didReceiveRequest:(HTTPServerRequest *)request {
  
}
@end
