//
//  HTTPConnectionDelegate.h
//  cloudboard
//
//  Created by Mirko on 2/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HTTPServer.h>

@class HTTPServer, HTTPConnection;

@interface HTTPConnectionDelegate : NSObject {
@private
    
}
- (void)HTTPServer:(HTTPServer *)server didMakeNewConnection:(HTTPConnection *)connection;
- (void)HTTPConnection:(HTTPConnection *)connection didReceiveRequest:(HTTPServerRequest *)request;
@end