//
//  ConnectManager.h
//  StudyAbroad
//
//  Created by tqnd on 14-8-11.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

@protocol ConnectManagerDelegate;

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"

typedef enum {
    RequestNewsType = 7,
    RequestRegister = 2,
    RequestLogin = 3
}ConnectAct;

typedef enum {
    ConnectTypeGET = 0,
    ConnectTypePOST,
    ConnectTypeDown,
    ConnectTypeUpload
}ConnectType;

typedef enum {
    ConnectStatusStop = 0,
    ConnectStatusStart,
    ConnectStatusPause,
}ConnectStatus;

@interface ConnectManager : NSObject <ASIHTTPRequestDelegate, ASIProgressDelegate>

@property (nonatomic, assign) ConnectType type;
@property (nonatomic, assign) BOOL syn;
@property (nonatomic, assign) ConnectStatus status;
@property (nonatomic, retain) ASINetworkQueue *queue;
@property (nonatomic, retain) ASIFormDataRequest *httpRequest;
@property (nonatomic, retain) id<ConnectManagerDelegate>delegate;

- (void)doActionWithAct:(ConnectAct)act
                       params:(NSDictionary *)params
                     delegate:(id) delegate;

@end

@protocol ConnectManagerDelegate <NSObject>

- (void)didRequestFinish:(NSDictionary *)result;

@end
