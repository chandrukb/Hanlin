//
//  HNServiceManager.h
//  Hanlin
//
//  Created by Balachandran on 03/03/18.
//  Copyright © 2018 BALACHANDRAN K. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNServiceManager : NSObject

+ (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password completionHandler:(void (^)(NSDictionary *response)) successResponse ErrorHandler:(void(^)(NSError* error))failureResponse;

+ (void)updateUserWithAction:(NSString *)actionUrl completionHandler:(void (^)(NSDictionary *response)) successResponse ErrorHandler:(void(^)(NSError* error))failureResponse payLoadDictionary:(NSDictionary *) payload;

+ (void)executeRequestWithUrl:(NSString *)actionUrl completionHandler:(void (^)(NSArray *responseArray)) successResponse ErrorHandler:(void(^)(NSError* error))failureResponse;

+ (void)executeRequestWithUrl:(NSString *)actionUrl completionHandler:(void (^)(NSArray *responseArray)) successResponse ErrorHandler:(void(^)(NSError* error))failureResponse payLoadDictionary:(NSDictionary *) payload;

@end
