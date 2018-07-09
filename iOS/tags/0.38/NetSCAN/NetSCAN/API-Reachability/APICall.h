//
//  APICall.h
//  NetSCAN
//
//  Created by Issa Al Zayed on 10/23/17.
//  Copyright © 2017 User. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APICall : NSObject <NSURLSessionDelegate>
    
typedef void (^CompletionBlock)(id, NSUInteger, NSData *, NSError*);
@property (strong, nonatomic) CompletionBlock block;
    
-(NSMutableDictionary*)getResponseForURL:(NSString *)builtURL JsonToPost:(NSString *)jsonString isAuthenticationRequired:(bool)authrequired method:(NSString *)method errorTitle:(NSString *)errorTitle hideLoader:(BOOL)hideLoader AndCompletionHandler:(CompletionBlock)completionHandler;
    
@end
