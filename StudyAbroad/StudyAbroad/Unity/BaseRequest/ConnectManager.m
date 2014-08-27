//
//  ConnectManager.m
//  StudyAbroad
//
//  Created by tqnd on 14-8-11.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#define HTTP_TYPE @"POST"

#import "ConnectManager.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"

@implementation ConnectManager

- (void)doActionWithAct:(ConnectAct)act params:(NSDictionary *)params delegate:(id)delegate {
    self.type = [params[@"act"] intValue];
    self.status = ConnectStatusStart;
    NSString *url = CONNECT_URL;
    url = [url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.httpRequest = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
    [self.httpRequest setRequestMethod:HTTP_TYPE];
    [self.httpRequest setPostValue:@7 forKey:@"act"];
    self.httpRequest.delegate = self;
    self.delegate = delegate;
    if (self.syn) {
        [self.httpRequest startSynchronous];
    } else {
        [self.httpRequest startAsynchronous];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSData *data = request.responseData;
    NSString *response = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    NSMutableDictionary *result = [response objectFromJSONString];
    [result setObject:[NSNumber numberWithInt:self.type] forKey:@"act"];
    DELEGATE_CALLBACK_ONE_PARAMETER(_delegate, didRequestFinish:, result);
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setObject:[NSNumber numberWithInt:-1] forKey:@"errorCode"];
    [result setObject:[NSNumber numberWithInt:self.type] forKey:@"act"];
}

@end
