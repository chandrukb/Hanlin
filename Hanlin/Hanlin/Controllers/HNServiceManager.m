//
//  HNServiceManager.m
//  Hanlin
//
//  Created by Balachandran on 03/03/18.
//  Copyright © 2018 BALACHANDRAN K. All rights reserved.
//

#import "HNServiceManager.h"
#import <ASIHTTPRequest/ASIHTTPRequest.h>
#import <ASIHTTPRequest/ASIFormDataRequest.h>
#import "HNConstants.h"
#import "JSON.h"

@implementation HNServiceManager

+ (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password completionHandler:(void (^)(NSDictionary *response)) successResponse ErrorHandler:(void(^)(NSError* error))failureResponse
{
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:NO];
    NSURL *url = [NSURL URLWithString:[HN_ROOTURL stringByAppendingString:HN_LOGIN_USER]];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setUseKeychainPersistence:YES];
    [request setPostValue:username forKey:HN_USERNAME];
    [request setPostValue:password forKey:HN_REQ_PASSWORD];
    
    [request setCompletionBlock:^{
        if (request.responseStatusCode == 400) {
            NSLog(@"Invalid code");
        } else if (request.responseStatusCode == 403) {
            NSLog(@"Code already used");
        } else if (request.responseStatusCode == 200) {
            NSString *resString = [request responseString];
            NSArray *responseArray = [resString JSONValue];
            NSDictionary *response = responseArray[0];
            successResponse(response);
            request = nil;
        }
    }];
    [request setFailedBlock:^{
        failureResponse([request error]);
        request = nil;
    }];
    [request startAsynchronous];
}

+ (void)updateUserWithAction:(NSString *)actionUrl completionHandler:(void (^)(NSDictionary *response)) successResponse ErrorHandler:(void(^)(NSError* error))failureResponse payLoadDictionary:(NSDictionary *) payload
{
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:NO];
    NSURL *url = [NSURL URLWithString:[HN_ROOTURL stringByAppendingString:actionUrl]];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    for(id key in payload) {
        if([key isEqualToString:HN_REQ_USERFILE])
        {
            [request setData:UIImagePNGRepresentation([payload objectForKey:key]) withFileName:@"png" andContentType:@"multipart/form-data" forKey:key];
        }
        else
        {
            [request setPostValue:[payload objectForKey:key] forKey:key];
        }        
    }
    
    [request setCompletionBlock:^{
        if (request.responseStatusCode == 400) {
            NSLog(@"Invalid code");
        } else if (request.responseStatusCode == 403) {
            NSLog(@"Code already used");
        } else if (request.responseStatusCode == 200) {
            NSString *resString = [request responseString];
            NSArray *responseArray = [resString JSONValue];
            NSDictionary *response = responseArray[0];
            successResponse(response);
            request = nil;
        }
    }];
    [request setFailedBlock:^{
        failureResponse([request error]);
        request = nil;
    }];
    [request startAsynchronous];
}

+ (void)executeRequestWithUrl:(NSString *)actionUrl completionHandler:(void (^)(NSArray *responseArray)) successResponse ErrorHandler:(void(^)(NSError* error))failureResponse
{
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:NO];
    NSURL *url = [NSURL URLWithString:[HN_ROOTURL stringByAppendingString:actionUrl]];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setCompletionBlock:^{
        if (request.responseStatusCode == 400) {
            NSLog(@"Invalid code");
        } else if (request.responseStatusCode == 403) {
            NSLog(@"Code already used");
        } else if (request.responseStatusCode == 200) {
            NSString *resString = [request responseString];
            NSArray *response = [resString JSONValue];
            successResponse(response);
            request = nil;
        }
    }];
    [request setFailedBlock:^{
        failureResponse([request error]);
        request = nil;
    }];
    [request startAsynchronous];
}

+ (void)executeRequestWithUrl:(NSString *)actionUrl completionHandler:(void (^)(NSArray *responseArray)) successResponse ErrorHandler:(void(^)(NSError* error))failureResponse payLoadDictionary:(NSDictionary *) payload
{
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:NO];
    NSURL *url = [NSURL URLWithString:[HN_ROOTURL stringByAppendingString:actionUrl]];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    for(id key in payload) {
        [request setPostValue:[payload objectForKey:key] forKey:key];
    }
    
    [request setCompletionBlock:^{
        if (request.responseStatusCode == 400) {
            NSLog(@"Invalid code");
        } else if (request.responseStatusCode == 403) {
            NSLog(@"Code already used");
        } else if (request.responseStatusCode == 200) {
            NSString *resString = [request responseString];
            NSArray *response = [resString JSONValue];
            successResponse(response);
            request = nil;
        }
    }];
    [request setFailedBlock:^{
        failureResponse([request error]);
        request = nil;
    }];
    [request startAsynchronous];
}

@end
