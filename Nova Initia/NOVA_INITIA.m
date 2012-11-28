//
//  NOVA_INITIA.m
//  Nova Initia iPhone
//
//  Created by svp on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NOVA_INITIA.h"
#import "NIAppDelegate.h"
#import "CommonCrypto/CommonDigest.h"
#import "LoginModel.h"
#import "User.h"
#import "SBJson.h"

@interface NOVA_INITIA(){
    NSMutableData *receivedData;
}
@end

@implementation NOVA_INITIA

static NOVA_INITIA *instance;

@synthesize prefs;

@synthesize curUrl, urlHash, domainHash;

@synthesize doorwayId, doorwayHint, doorwayUserId, doorwayUrl;
@synthesize tradepost, readMessages, doorway;


- (NSUserDefaults *)prefs{
    if(!prefs){
        prefs = [NSUserDefaults standardUserDefaults];
    }
    return prefs;
}

// Get instance of the class (singleton)
+ (NOVA_INITIA *) getInstance{
    @synchronized(self){
        if(instance == nil)
            instance = [[NOVA_INITIA alloc] init];
    }
    
    return instance;
}

- (NSString *) login:(NSString *)username:(NSString *)password{
    return [[[LoginModel alloc] init] login:username:password];
}

-(NSString *)sendRequest:(NSString *)method :(NSString *)url :(NSString *)params{
    
    NSString *response = nil;
    NSData *data = [params dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *length = [NSString stringWithFormat:@"%d" , [data length]];
    
    // Creat the request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:method];
    [request setURL:[NSURL URLWithString:url]];
    [request setValue:length forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    
    //Make connection using the request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(conn != nil){
        receivedData = [[NSMutableData alloc] init];
        CFRunLoopRun(); // connection events get processed even if something blocks the main run loop
        response = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding];
    }
    else{
        NSLog(@"Invalid URL");
    }
    
    return response;
}

- (NSString *)sendRequest2:(NSString *)method:(NSString *)url:(NSString *)params:(BOOL)noHeader{
    
    NSString *response = nil;
    NSData *data = [params dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *length = [NSString stringWithFormat:@"%d" , [data length]];
    
    // Create the request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:method];
    [request setURL:[NSURL URLWithString:url]];
    [request setValue:length forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    
//    NSLog(@"paramsB = %@",params);
//    NSString *myparams = [params JSONRepresentation];
//    NSLog(@"paramsA = %@",myparams);
    
    if(!noHeader){
        NSString *lastKey = [[User getInstance] lastKey];
        [request setValue:lastKey forHTTPHeaderField:@"X-NOVA-INITIA-LASTKEY"];
    }
    
    //Make connection using the request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(conn != nil){
        receivedData = [[NSMutableData alloc] init];
        CFRunLoopRun(); // connection events get processed even if something blocks the main run loop
        response = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding];
    }
    else{
        NSLog(@"Invalid URL");
    }
    
    return response;
    
}

#pragma NSURLConnection methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    // This method is called when the server has determined that it
    
    // has enough information to create the NSURLResponse.
    
    
    
    // It can be called multiple times, for example in the case of a
    
    // redirect, so each time we reset the data.
    
    
    
    // receivedData is an instance variable declared elsewhere.
    
    [receivedData setLength:0];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    // Append the new data to receivedData.
    
    [receivedData appendData:data];
    CFRunLoopStop(CFRunLoopGetCurrent()); // stop current RunLoop, response received
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);}



@end