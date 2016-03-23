//
//  Connect.m
//  InstantPros
//
//  Created by Kuznetsov Andrey on 31/07/15.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "ServerConnect.h"
#import "Reachability.h"

@implementation ServerConnect

+ (ServerConnect *)sharedManager {
    static ServerConnect *sharedManager = nil;
    static dispatch_once_t onceToken=0;
    dispatch_once(&onceToken, ^{
        sharedManager = [[ServerConnect alloc] initWithBaseURL:[NSURL URLWithString: kWSApiBaseUrl]];
        sharedManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [sharedManager.requestSerializer setTimeoutInterval:30.0];
        sharedManager.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    return sharedManager;
}

- (void)GET:(NSString *)url
 withParams:(NSDictionary *)params
  onSuccess:(SuccessBlock)completionBlock
  onFailure:(FailureBlock)failureBlock
{
    // Check out network connection
    NetworkStatus networkStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        [SHAlertHelper showOkAlertWithTitle:@"Error" message:@"We are unable to connect to our servers.\rPlease check your connection."];
        
        failureBlock(-1, nil);
        return;
    }
    
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completionBlock(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //Error
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSInteger statusCode = response.statusCode;

        NSLog(@"%@", error);
        [SHAlertHelper showOkAlertWithTitle:@"Connection Error" andMessage:@"Error occurs while connecting to web-service. Please try again!" andOkBlock:nil];
        
        failureBlock(statusCode, nil);
    }];
}

- (void)POST:(NSString *)url
 withParams:(NSDictionary *)params
  onSuccess:(SuccessBlock)completionBlock
  onFailure:(FailureBlock)failureBlock
{
    // Check out network connection
    NetworkStatus networkStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        [SHAlertHelper showOkAlertWithTitle:@"Error" message:@"We are unable to connect to our servers.\rPlease check your connection."];
        
        failureBlock(-1, nil);
        return;
    }
    
    [self POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completionBlock(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //Error
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSInteger statusCode = response.statusCode;

        NSLog(@"%@", error);
        [SHAlertHelper showOkAlertWithTitle:@"Connection Error" andMessage:@"Error occurs while connecting to web-service. Please try again!" andOkBlock:nil];

        failureBlock(statusCode, nil);
    }];
}

- (void)UploadFiles:(NSString *)url
            withData:(NSArray *)datas
          withParams:(NSDictionary *)params
           onSuccess:(SuccessBlock)completionBlock
           onFailure:(FailureBlock)failureBlock
{
    // Check out network connection
    NetworkStatus networkStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        [SHAlertHelper showOkAlertWithTitle:@"Error" message:@"We are unable to connect to our servers.\rPlease check your connection."];
        
        failureBlock(-1, nil);
        return;
    }
    
    [self POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSDictionary *dict in datas) {
            if ([dict[@"fileType"] isEqualToString:@"image"]) {
                [formData appendPartWithFileData:dict[@"data"] name:dict[@"name"] fileName:dict[@"fileName"] mimeType:dict[@"mimeType"]];
            }
        }
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        completionBlock(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //Error
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog( @"status code: %d", (int)response.statusCode );
        NSLog(@"userInfo: %@", error.userInfo);
        NSLog(@"%@", error);
        
        NSInteger statusCode = response.statusCode;
        
//        NSLog(@"%@", error);
//        [SHAlertHelper showOkAlertWithTitle:@"Connection Error" andMessage:@"Error occurs while connecting to web-service. Please try again!" andOkBlock:nil];

        failureBlock(statusCode, nil);
    }];
}



@end
