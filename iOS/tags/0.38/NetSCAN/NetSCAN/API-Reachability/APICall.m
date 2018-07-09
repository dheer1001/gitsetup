//
//  APICall.m
//  NetSCAN
//
//  Created by Issa Al Zayed on 10/23/17.
//  Copyright © 2017 User. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APICall.h"

@implementation APICall
    
-(NSMutableDictionary*)getResponseForURL:(NSString *)builtURL JsonToPost:(NSString *)jsonString isAuthenticationRequired:(bool)authrequired method:(NSString *)method errorTitle:(NSString *)errorTitle hideLoader:(BOOL)hideLoader AndCompletionHandler:(CompletionBlock)completionHandler
    {
        _block = [completionHandler copy];
        NSMutableDictionary *response;
        NSURL *url=[NSURL URLWithString:[builtURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSMutableDictionary *sessionHeaders = [[NSMutableDictionary alloc] init];
        [sessionHeaders setValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
        [sessionHeaders setValue:@"no-cache" forKey:@"cache-control"];
        if (authrequired){
            NSDictionary * loginResponse = [[NSUserDefaults standardUserDefaults] valueForKey:@"loginResponse"];
            [sessionHeaders setValue:[loginResponse valueForKey:@"api_key"] forKey:@"api_key"];
        }
        int timeOut = 60;
        [defaultConfigObject setHTTPAdditionalHeaders:sessionHeaders];
        defaultConfigObject.allowsCellularAccess = YES;
        defaultConfigObject.timeoutIntervalForRequest = timeOut;
        defaultConfigObject.timeoutIntervalForResource = timeOut;
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate:self delegateQueue: [NSOperationQueue mainQueue]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOut];
        NSString *charactersToEscape = @"!*'();:@&=+$,/?%#[]\" {}";
        NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
        NSString *escapedLoginString = [jsonString stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
        NSMutableData *postData = [[NSMutableData alloc] initWithData:[[NSString stringWithFormat:@"request=%@", escapedLoginString] dataUsingEncoding:NSUTF8StringEncoding]];
        
        request.HTTPBody = postData;
        request.HTTPMethod = method;
        NSURLSessionDataTask *dataTask=[defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *urlResponse, NSError *error){
            if (error == nil){
                if (urlResponse != nil){
                    NSUInteger statusCode = [(NSHTTPURLResponse *)urlResponse statusCode];
                    NSDictionary *Dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                    if (Dic != nil){
                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) Dic;
                        _block(httpResponse, statusCode, data, error);
                    } else {
                        _block(nil,statusCode, data, error);
                    }
                } else {
                    _block(nil,0, data, error);
                }
            } else {
                    _block(nil, 0, data, error);
                }
            }];
        [dataTask resume];
        return response;
    }
    
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler{
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
    }
}
    
@end
