//
//  HTTPConnectionDelegate.h
//  cloudboard
//
//  Created by Mirko on 2/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cloudboard.h"

@class HTTPServer, HTTPConnection, CBSyncController;

@interface HTTPConnectionDelegate : NSObject {
@private
  CBSyncController *syncController;
  NSMutableArray* postURLs;
}
- (id)initWithSyncController: (CBSyncController*)controller;
- (void)HTTPServer:(HTTPServer *)server didMakeNewConnection:(HTTPConnection *)connection;
- (void)HTTPConnection:(HTTPConnection *)connection didReceiveRequest:(HTTPServerRequest *)request;
@end